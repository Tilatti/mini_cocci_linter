#!/usr/bin/env bash

# Strict mode
set -o pipefail -o noclobber -o nounset

# Handle signals
function int_handler {
	exit 1;
}
trap int_handler SIGINT SIGTERM SIGKILL SIGABRT SIGQUIT

function print_usage {
	echo -e "Usage:"
	echo -e "\tExecute requirements on source code of a directory: ${0} [-r <requirement>] <directory>"
	echo -e "\tExecute the test cases: ${0} -t [-r <requirement>]"
	echo -e "\tPrint this help: ${0} -h"
}

# Parse the options
opt_tests=false
opt_reqs="all"
while getopts "htr:" opt; do
	case "$opt" in
		h)
			print_usage
			exit 0
			;;
		t)
			opt_tests=true
			;;
		r)
			opt_reqs=$OPTARG
			;;
	esac
done

# Parse the directories
shift $((OPTIND-1))
if $opt_tests; then
	directories=""
else
	if [ $# -lt 1 ]; then
		print_usage;
		exit -1;
	fi
	directories=$@
fi

SPATCH="/usr/bin/env spatch"
CC="/usr/bin/env clang"

SRC_DIR=${@}
CURR_DIR=$(dirname $0)
COCCI_DIR="${CURR_DIR}/cocci"
TEST_DIR="${CURR_DIR}/tests"

# Read the description requirement inside the coccinelle script.
# Print the description in the standard output.
function read_description
{
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
	done < "$1"
	echo $description
}

# Print the requirement description with the test/check result status (OK/NOK/UNKNOWN)
function print_description_and_status
{
	req=$1
	status=$2 # OK/NOK/UNKNOWN
	
	# Get the description in the comments of the script file
	description=$(read_description "${COCCI_DIR}/${req}.cocci")
	if [ "$description" == "" ]; then
		description="Description for $req is missing !"
	fi

	# Print the description with the status
	if [ $status == "OK" ]; then
		echo -e "check ${req}: ${description} [\e[32mOK\e[0m]"
	elif [ $status == "NOK" ]; then
		echo -e "check ${req}: ${description} [\e[31mNOK\e[0m]"
	else
		echo -e "check ${req}: ${description} [\e[1;33mUNKNOWN\e[0m]"
	fi
}

# Transform lines with number to a list of sorted number separated by blanks.
function to_one_line
{
	sort -g | tr "\n" " "
}

# Find the "not good" markers in a test source code.
# Print the list of lines in the standard output.
function find_not_good
{
	grep -n "not good" "$1" | cut -f1 -d: | to_one_line
}

# Execute the coccinelle script corresponding to the requirement given in argument.
# Print the result in the standard output.
function check_req
{
	req=$1
	directories=$2

	# Verify the script file exists
	ls "${COCCI_DIR}/${req}.cocci" > /dev/null 2>&1 
	if [ $? -ne 0 ]; then
		echo -e "\tScript file for $req is missing !";
		return 1;
	fi

	has_error=false
	for dir in $directories; do
		# Execute the script on the source files of the sub-directories
		log=$(${SPATCH} --sp-file "${COCCI_DIR}/${req}.cocci" --dir "${dir}" --no-loops 2>/dev/null)
		if [ $? -ne 0 ]; then
			echo -e "\tFail to execute the script file ${req}"
			return 1;
		fi

		# Count the number of errors detected by the script
		error_count=$(echo -e "$log" | grep -c "\(WARNING\|ERROR\)")
		if [ $error_count -gt 0 ]; then
			has_error=true
		fi

		# Print the detected error locations
		echo -e "$log" | sed "s/.* \([^ ]*.c\)::\([0-9][0-9]*\)]]/\t\"\1\" at line \2/g"
	done

	if $has_error; then
		return 2
	else
		return 0
	fi
}

# Execute the requirement on the test case.
# Print the test result in the standard output.
function test_req
{
	req=$1

	# Verify the test file exists
	ls "${TEST_DIR}/${req}.c" > /dev/null 2>&1 
	if [ $? -ne 0 ]; then
		echo -e "\tTest file for $req is missing !";
		return 1;
	fi
	# Verify the script file exists
	ls "${COCCI_DIR}/${req}.cocci" > /dev/null 2>&1 
	if [ $? -ne 0 ]; then
		echo -e "\tScript file for $req is missing !";
		return 1;
	fi

	# Verify the test source code can be compiled
	${CC} -w -c "${TEST_DIR}/${req}.c" -o - > /dev/null
	if [ $? -ne 0 ]; then
		echo -e "\tTest file for $req cannot be compiled !";
		return 1;
	fi

	# Find the lines with an error in the test file
	expected_lines=$(find_not_good "${TEST_DIR}/${req}.c")

	# Execute the script on the test file
	found_lines=$(${SPATCH} --sp-file "${COCCI_DIR}/${req}.cocci" "${TEST_DIR}/${req}.c" --no-loops 2>/dev/null | \
		sed "s/.* \([^ ]*.c\)::\([0-9][0-9]*\)]]/\2/g" | to_one_line)
	if [ $? -ne 0 ]; then
		echo -e "\tSpatch execution failed !";
		return 1;
	fi

	# Compare the script output with expected one
	if [ "$expected_lines" != "$found_lines" ]; then
		echo -e "\tError found in $req requirement."
		echo -e "\t\tExpected error lines: $expected_lines"
		echo -e "\t\tError lines: $found_lines"
		return 2
	fi
	
	return 0;
}

declare -a ALL_REQS=("req_1" "req_2" "req_3" "req_4" "req_5" "req_6" "req_7" "req_8" "req_spec_1" "warn_1" "warn_2" "warn_4")

if [ $opt_reqs == "all" ]; then
	reqs=${ALL_REQS[@]}
else
	reqs=($opt_reqs)
fi
for req in ${reqs[@]}; do
	if $opt_tests; then
		output=$(test_req "$req")
	else
		output=$(check_req $req $directories)
	fi
	ret=$?

	if [ $ret -eq 0 ]; then
		print_description_and_status "$req" "OK"
	elif [ $ret -eq 2 ]; then
		print_description_and_status "$req" "NOK"
	else
		print_description_and_status "$req" "UNKNOWN"
	fi

	if [ "$output" != "" ]; then
		echo -e "${output}"
	fi
done
