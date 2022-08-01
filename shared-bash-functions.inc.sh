#!/bin/bash
# This library file is included by many main bash shell utility/application programs.
# It can optionally be first "installed", meaning symlinks are created on the system, \
#in locations (like /usr/local/lib) expected by those main bash programs. To do this installation, just
# execute this file from its' local git project repository directory:
# Use this command:
# cd path/to/shared-functions-library/ && ./shared-bash-functions.inc.sh
# That install only need be done once, although it is idempotent in any case.

# Get path to this script. 
# It will be to either THIS library script OR a main script, depending on runtime.
lib_script_path="$(readlink -f $0)" 
lib_script_basename="$(basename $lib_script_path)"
lib_script_dirname="$(dirname $lib_script_path)"

if [[ $lib_script_basename =~ 'shared-bash-functions.inc.sh' ]] 
then
	# we must be running this script directly, to create symlinks
	source "${lib_script_dirname}/symlink_lib_file.inc.sh"
fi

#===============
# COMMON FUNCTIONS
#===============

# exit program with non-zero exit code
function lib10k_exit_with_error()
{	
	error_code="$1"
	error_message="$2"

	echo "error code: $error_code"
	echo "$error_message"
	#echo "USAGE: $(basename $0) ABSOLUTE_FILEPATH..."
	echo && exit $error_code
}

############################################
# programs that are not built-ins  must be in the regular user PATH \
# or use their absolute paths, but these may vary with host system
function lib10k_check_program_requirements() 
{
	declare -a dependencies=( "$@" )
	for program_name in "${dependencies[@]}"
	do
	# TODO: why can't root super user run the type command?
	  if type "$program_name" >/dev/null 2>&1
		then
			echo "\"${program_name}\" already installed OK"
		else
			echo "\"${program_name}\" is NOT installed."
			echo "program dependencies are: ${program_dependencies[@]}"
  			msg="Required program not found. Exiting now..."
			lib10k_exit_with_error "$E_REQUIRED_PROGRAM_NOT_FOUND" "$msg"
		fi
	done
	echo
}
############################################
# programs that are not built-ins  must be in the regular user PATH \
# or use their absolute paths, but these may vary with host system
# check program dependencies, report only if missing.
function lib10k_check_program_dependencies() 
{
	declare -a dependencies=( "$@" )
	for program_name in "${dependencies[@]}"
	do
		# TODO: why can't root super user run the type command?
	  	if ! (type "$program_name" >/dev/null 2>&1)
		then
			echo "\"${program_name}\" is NOT installed."
			echo "program dependencies are: ${program_dependencies[@]}"
  			msg="Required program not found. Exiting now..."
			lib10k_exit_with_error "$E_REQUIRED_PROGRAM_NOT_FOUND" "$msg"
		fi
	done
	echo
}
############################################

function lib10k_display_program_header()
{
	local program_title="${1}"
	local original_author="${2}"

	# Display a program header and give user option to leave if here in error:
    echo
    echo -e "\033[33mWelcome to the \"$program_title\" program\033[0m"
	echo -e "\033[33mAuthor: $original_author\033[0m" 
    echo

	if [ ! $USER = 'root' ]
	then
		echo "Hello, ${USER}!" && echo
	fi
}

############################################

# give user option to leave if, for example...
# here in error,
# or cannot proceed due to some error or failure.
function lib10k_get_user_permission_to_proceed()
{
	local msg="$1"

	echo -e "$msg"
	echo "Enter q to quit program NOW, or just press ENTER to continue." && echo

	read last_chance
	case $last_chance in 
		[qQ])	#echo && echo "Goodbye! Exiting now..."
				#	exit 0 #
				return 1 # negative
				;;
		*)		#echo && echo "Ok, continuing..." && echo
				return 0 # affirmative
				;;
	esac
}
############################################
# generalist function to handle user responses and return expected int
function lib10k_get_user_response()
{
	for msg in "$@"
	do
		echo -e "$msg"
		#echo -e "$msg" && prompt="$msg"
	done

	read user_response
	#read -p "$prompt" && user_response="${REPLY}"

	# where user just presses ENTER
	[ -z "$user_response" ] && return 0

	case $user_response in
		[nN]) return 3 #
				;;
		[yY]) return 2 #
				;;
		[qQ]) return 1 #
				;;
		*)		return 999 #
				;;
	esac
}
############################################
# generalist function to handle user responses and return expected int
function lib10k_get_user_response1()
{
	for msg in "$@"
	do
		echo -e "$msg"
		#echo -e "$msg" && prompt="$msg"
	done

	read user_response
	#read -p "$prompt" && user_response="${REPLY}"

	# where user just presses ENTER
	[ -z "$user_response" ] && return 0

	case $user_response in
		[nN]) return 3 #
				;;
		[yY]) return 2 #
				;;
		[qQ]) return 1 #
				;;
		*)		return 999 #
				;;
	esac
}
############################################



# quick check that number of program arguments is within the valid range
function lib10k_check_no_of_program_args()
{
	#echo && echo "Entered into function ${FUNCNAME[0]}" && echo
	
	# establish that number of parameters is valid
	if [ $actual_no_of_program_parameters -lt $min_expected_no_of_program_parameters -o \
	$actual_no_of_program_parameters -gt $max_expected_no_of_program_parameters  ]
	then
		msg="Incorrect number of command line arguments. Exiting now..."
		lib10k_exit_with_error "$E_INCORRECT_NUMBER_OF_ARGS" "$msg"
	fi
	
	#echo && echo "Leaving from function ${FUNCNAME[0]}" && echo
}

############################################

# test whether this host is authorised to run this program
function lib10k_entry_test()
{
	local allow=42 # initialise to non-zero fail state
	# if authorised_host_list is empty, skip this test (allow host entry by default), \
	# otherwise do this test
	if [ ${#authorised_host_list} -ne 0 ]
	then
		for authorised_host in ${authorised_host_list[@]}
		do
			# set allow to 0 or 1 (1 being fail/deny)
			[ $authorised_host == $actual_host ] && allow=0 || allow=1
			[ "$allow" -eq 0 ] && \
			echo "TESTED. The current host is authorised to used this program OK." && break
		done
	else
		# Test skipped, as zero specifically authorised host, meaning 'allow all hosts'
		# Test for 42 here?
		echo "TEST SKIPPED. The current host is authorised to used this program OK."
	fi

	# if loop finished with allow=1, deny the current host
	[ $allow -eq 1 ] && \
	msg="TESTED. Unathorised Host. Exiting now..." && \
	lib10k_exit_with_error "$E_INCORRECT_HOST" "$msg"
}

############################################

function lib10k_display_current_config_file()
{
	echo && echo CURRENT CONFIGURATION FILE...
	echo "==========================="

	cat "$config_file_fullpath" && echo
}

############################################

# - trim leading and trailing space characters
function lib10k_sanitise_input_spaces_both_ends()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	# while....?

	# TRIM TRAILING AND LEADING SPACES AND TABS
	test_line=${test_line%%[[:blank:]]}
	test_line=${test_line##[[:blank:]]}

	echo "test line after space cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
############################################
# for example to prepare 
function lib10k_remove_trailing_fwd_slash()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	# TRIM TRAILING / FOR ABSOLUTE PATHS:
    while [[ "$test_line" == *'/' ]]
    do
        echo "FOUND ENDING SLASH"
        test_line=${test_line%'/'}
    done    

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
############################################
# for example, to prepare file path to append another
function lib10k_remove_leading_fwd_slash()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	# TRIM LEADING / FOR RELATIVE PATHS:
    while [[ "$test_line" == '/'* ]]
    do
        echo "FOUND LEADING SLASH"
        test_line=${test_line#'/'}
    done  

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
############################################
# 
function lib10k_make_abs_pathname()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	while [[ "$test_line" == *'/' ]] ||\
	 [[ "$test_line" == *[[:blank:]] ]] ||\
	 [[ "$test_line" == [[:blank:]]* ]]
	do
		# call the appropriate set of functions
		lib10k_sanitise_input_spaces_both_ends "$test_line"
		lib10k_remove_trailing_fwd_slash "$test_line"
	done

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
############################################
function lib10k_make_rel_pathname()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	while [[ "$test_line" == *'/' ]] ||\
	 [[ "$test_line" == *[[:blank:]] ]] ||\
	 [[ "$test_line" == [[:blank:]]* ]] ||\
	 [[ "$test_line" == '/'* ]]
	do
		# call the appropriate set of functions
		lib10k_sanitise_input_spaces_both_ends "$test_line"
		lib10k_remove_trailing_fwd_slash "$test_line"
		lib10k_remove_leading_fwd_slash "$test_line"
	done

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
############################################

# generic need to test for access to a directory. 3 logical states:
# 0. directory exists and is cd-able (actully do the cd)
# 1. directory exists and is not cd-able
# 2. neither of those, so directory does NOT exist
# 
function lib10k_test_dir_path_access()
{
	#echo && echo "ENTERED INTO FUNCTION ${FUNCNAME[0]}" && echo

	local test_result=
	local test_dir_fullpath="$1"

	#echo "test_dir_fullpath is set to: $test_dir_fullpath"

	if [ -d "$test_dir_fullpath" ] && cd "$test_dir_fullpath" 2>/dev/null
	then
		# directory file found and accessible
		# echo "directory "$test_dir_fullpath" found and accessed ok" && echo
		test_result=0
	elif [ -d "$test_dir_fullpath" ] ## 
	then
		# directory file found BUT NOT accessible CAN'T RECOVER FROM THIS
		echo "directory "$test_dir_fullpath" found, BUT NOT accessed ok" && echo
		test_result=1
		echo "Returning from function \"${FUNCNAME[0]}\" with test result code: $E_FILE_NOT_ACCESSIBLE"
		return $E_FILE_NOT_ACCESSIBLE
	else
		# -> directory not found: THIS CAN BE RESOLVED BY CREATING THE DIRECTORY
		test_result=1
		echo "Returning from function \"${FUNCNAME[0]}\" with test result code: $E_REQUIRED_FILE_NOT_FOUND"
		return $E_REQUIRED_FILE_NOT_FOUND
	fi

	# echo && echo "LEAVING FROM FUNCTION ${FUNCNAME[0]}" && echo

	return "$test_result"
}
############################################

# AS ABOVE, BUT DON'T ACTUALLY cd TO THE DIR BEING TESTED.

# generic need to test for access to a directory. 3 logical states:
# 0. directory exists and is cd-able (cd in a child shell)
# 1. directory exists and is not cd-able
# 2. neither of those, so directory does NOT exist
# 
function lib10k_test_dir_path_access1()
{
	#echo && echo "ENTERED INTO FUNCTION ${FUNCNAME[0]}" && echo

	local test_result=
	local test_dir_fullpath="$1"

	#echo "test_dir_fullpath is set to: $test_dir_fullpath"

	if [ -d "$test_dir_fullpath" ] && (cd "$test_dir_fullpath" 2>/dev/null)
	then
		# directory file found and accessible
		# echo "directory "$test_dir_fullpath" found and accessed ok" && echo
		test_result=0
	elif [ -d "$test_dir_fullpath" ] ## 
	then
		# directory file found BUT NOT accessible CAN'T RECOVER FROM THIS
		echo "directory "$test_dir_fullpath" found, BUT NOT accessed ok" && echo
		test_result=1
		echo "Returning from function \"${FUNCNAME[0]}\" with test result code: $E_FILE_NOT_ACCESSIBLE"
		return $E_FILE_NOT_ACCESSIBLE
	else
		# -> directory not found: THIS CAN BE RESOLVED BY CREATING THE DIRECTORY
		test_result=1
		echo "Returning from function \"${FUNCNAME[0]}\" with test result code: $E_REQUIRED_FILE_NOT_FOUND"
		return $E_REQUIRED_FILE_NOT_FOUND
	fi

	# echo && echo "LEAVING FROM FUNCTION ${FUNCNAME[0]}" && echo

	return "$test_result"
}
# test that the parameter we got is of the correct form for an absolute file | sanitised directory path 
# if this test fails, there's no point doing anything further
# 
function lib10k_test_file_path_valid_form()
{
	#echo && echo "ENTERED INTO FUNCTION ${FUNCNAME[0]}" && echo

	local test_result=
	local test_file_fullpath=$1
	
	#echo "test_file_fullpath is set to: $test_file_fullpath"
	#echo "test_dir_fullpath is set to: $test_dir_fullpath"

	if [[ $test_file_fullpath =~ $ABS_FILEPATH_FLEX_TS_REGEX ]] || [[ $test_file_fullpath =~ $FILE_BASENAME_LA_WITH_SE_REGEX ]] 
	then
		#echo "THE FORM OF THE INCOMING PARAMETER IS OF A VALID ABSOLUTE FILE PATH"
		test_result=0
	else
		echo "AN INCOMING PARAMETER WAS SET, BUT WAS NOT A MATCH FOR:" \
        echo "OUR KNOWN PATH FORM REGEX "$ABS_FILEPATH_FLEX_TS_REGEX"" && echo
		echo "Returning with a non-zero test result..."
		test_result=1
		return $E_UNEXPECTED_ARG_VALUE
	fi 

	#echo && echo "LEAVING FROM FUNCTION ${FUNCNAME[0]}" && echo

	return "$test_result"
}

############################################

# test for read access to file 
# 
function lib10k_test_file_path_access()
{
	echo && echo "ENTERED INTO FUNCTION ${FUNCNAME[0]}" && echo

	test_result=
	test_file_fullpath=$1

	echo "test_file_fullpath is set to: $test_file_fullpath"

	# test for expected file type (regular) and read permission
	if [ -f "$test_file_fullpath" ] && [ -r "$test_file_fullpath" ]
	then
		# test file found and accessible
		echo "Test file found to be readable" && echo
		test_result=0
	else
		# -> return due to failure of any of the above tests:
		test_result=1 # just because...
		echo "Returning from function \"${FUNCNAME[0]}\" with test result code: $E_REQUIRED_FILE_NOT_FOUND"
		return $E_REQUIRED_FILE_NOT_FOUND
	fi

	echo && echo "LEAVING FROM FUNCTION ${FUNCNAME[0]}" && echo

	return "$test_result"
}

############################################


