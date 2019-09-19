#!/usr/bin/env bash

REQS="req_1 req_2 req_3 req_4 req_5 req_6 req_7 req_8"
REQS_SPECIFIC="req_spec_1"
WARNINGS="warn_1 warn_2 warn_4"

SPATCH="spatch"
CC="clang"

function int_handler {
	exit 1;
}

function print_usage {
	echo -e "Usage: ${0} needs 1 parameter 'source directory'"
	echo -e "Example: ${0} ./project_dir"
}

trap int_handler SIGINT SIGTERM SIGKILL SIGABRT SIGQUIT


if [ $# -lt 1 ]; then
	print_usage
	exit -1
fi
if [ $1 == "--help" -o $1 == "-h" ]; then
	print_usage
	exit -1
fi

SRC_DIR=${@}
CURR_DIR=$(dirname $0)
COCCI_DIR="${CURR_DIR}/cocci"
TEST_DIR="${CURR_DIR}/tests"

# Read the description requirement inside the coccinelle script.
# Print the description in the standard output.
function read_description
{
	req=$1

	in=false
	description=""
	while read line
	do
		echo $line | grep -q "^// .*$" # is a commentar ?
		if [ $? -eq 0 ]; then
			echo $line | grep -q "^// DESCRIPTION: "
			if [ $? -eq 0 ]; then 
				in=true # it is the begin of the description
				line=$(echo $line | sed "s/\/\/ DESCRIPTION: //g")
				description="${description} ${line}"
			elif $in; then
				line=$(echo $line | sed "s/\/\/ //g")
				description="${description} ${line}"
			fi
		else
			in=false # it is not the description anymore
		fi
	done < "${COCCI_DIR}/${req}.cocci";
	echo $description
}

# Execute the coccinelle script corresponding to the requirement given in argument.
# Print the result in the standard output.
function check_req
{
	req=$1

	description=$(read_description ${req})
	if [ "$description" == "" ]; then
		description="Description for $req is missing !"
	fi

	echo "check ${req}: ${description}"
	for dir in ${SRC_DIR}; do
		# Execute the script on the source files of the sub-directories
		${SPATCH} --sp-file "${COCCI_DIR}/${req}.cocci" --dir "${dir}" --no-loops 2>/dev/null | \
			sed "s/.* \([^ ]*.c\)::\([0-9][0-9]*\)]]/\t\"\1\" at line \2/g"
		if [ $? -ne 0 ]; then
			exit -1
		fi
	done
}

# Transform lines with number to a list of sorted number separated by blanks.
function to_one_line
{
	sort -g | awk 'BEGIN {ls = ""} {if (ls == "") ls = $1; else ls = ls " " $1;} END {print ls}'
}

# Find the "not good" markers in a test source code.
# Print the list of lines in the standard output.
function find_not_good
{
	grep -n "not good" "$1" | cut -f1 -d: | to_one_line
}

function test_req
{
	req=$1

	description=$(read_description ${req})
	if [ "$description" == "" ]; then
		description="Description for $req is missing !"
	fi
	echo "test ${req}: ${description}"

	# Verify the test file exists
	ls "${TEST_DIR}/${req}.c" > /dev/null 2>&1 
	if [ $? -ne 0 ]; then
		echo -e "\tTest file for $req is missing !";
		return
	fi

	# Verify the test source code can be compiled
	${CC} -w -c "${TEST_DIR}/${req}.c" -o - > /dev/null
	if [ $? -ne 0 ]; then
		echo -e "\tTest file for $req cannot be compiled !";
		return
	fi

	# Find the lines with an error in the test file
	expected_lines=$(find_not_good "${TEST_DIR}/${req}.c")

	# Execute the script on the test file
	found_lines=$(${SPATCH} --sp-file "${COCCI_DIR}/${req}.cocci" "${TEST_DIR}/${req}.c" --no-loops 2>/dev/null | \
		sed "s/.* \([^ ]*.c\)::\([0-9][0-9]*\)]]/\2/g" | to_one_line)
	if [ $? -ne 0 ]; then
		exit -1
	fi

	# Compare the script output with expected one
	if [ "$expected_lines" != "$found_lines" ]; then
		echo -e "\tError found in $req requirement."
		echo -e "\t\tExpected error lines: $expected_lines"
		echo -e "\t\tError lines: $found_lines"
	fi
}


for req in ${REQS}; do
	test_req ${req}
	check_req ${req}
done
for req in ${REQS_SPECIFIC}; do
	test_req ${req}
	check_req ${req}
done
for req in ${WARNINGS}; do
	test_req ${req}
	check_req ${req}
done
