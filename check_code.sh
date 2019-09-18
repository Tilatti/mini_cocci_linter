#!/usr/bin/env bash

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

# Try to find the requirement description in the reqs.txt file.
# Print the description in the standard output.
function find_desc
{
	req=$(echo "$1" | tr '[:lower:]' '[:upper:]')
	is_next=0
	is_opt_next=0

	while read line
	do
		if [ "$is_next" -eq "1" ]; then
			echo "${line}";
			break 1
		fi
		if [ "-- ${req} --" == "${line}" ]; then
			is_next=1
		fi
	done < ${CURR_DIR}/reqs.txt
}

# Execute the coccinelle script corresponding to the requirement given in argument.
# Print the result in the standard output.
function check_req
{
	req=$1
	desc=$(find_desc ${req})
	if [ "$desc" == "" ]; then
		desc="Description for ${req} is missing, please modify reqs.txt";
	fi
	echo "-> ${req} : ${desc} <-"
	for dir in ${SRC_DIR}; do
		result=$(${SPATCH} --sp-file "${COCCI_DIR}/${req}.cocci" --dir "${dir}" --no-loops 2>&1)
		if [ $? -ne 0 ]; then
			echo "$result"
			exit -1
		fi
		echo "${result}" | grep -q "TODO"
		if [ $? -eq 0 ]; then
			echo "$result"
		fi
	done
	echo "$result" | grep "view:"
}

COCCI_DIR="${CURR_DIR}/cocci"
SPATCH="spatch"

REQS="req_1 req_2 req_3 req_4 req_5 req_6 req_7 req_8"
REQS_SPECIFIC="req_spec_1"
WARNINGS="warn_1 warn_2 warn_4"

echo "--> Mandatory requirements <--"
for req in ${REQS}; do
	check_req ${req}
done
echo "--> Mandatory project specific requirements <--"
for req in ${REQS_SPECIFIC}; do
	check_req ${req}
done
echo "--> Warnings <--"
for req in ${WARNINGS}; do
	check_req ${req}
done
