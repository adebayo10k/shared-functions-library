#



# set the environment variable in ~/.bashrc file on all hosts with :
# export SHARED_LIBRARIES_DIR=$HOME/.local/share/lib10k

# mkdir "$HOME/.local/share/lib10k"

# symlink from $HOME/.local/share/lib10k/shared-bash-functions.sh to the git repository

# add code to source the library file at beginning of EVERY script, using:
# ${SHARED_LIBRARIES_DIR}/shared-bash-functions.sh

# exit program with non-zero exit code
function lib10k_exit_with_error()
{	
	error_code="$1"
	error_message="$2"

	echo "error code: $error_code"
	echo "$error_message"
	#echo "USAGE: $(basename $0) ABSOLUTE_FILEPATH..."
	echo && sleep 1

	exit $error_code
}

################################################################
# programs must all be in the PATH for both regular and root user.
# they're not built-ins
# could use their absolute paths, but these may vary with host system
function check_program_requirements() 
{
	declare -a dependencies=( "$@" )

	echo
	echo "PROGRAM REQUIREMENTS CHECK"
	echo "=========================="

	for program_name in "${dependencies[@]}"
	do
	  if type "$program_name" >/dev/null 2>&1
		then
			echo "$program_name already installed OK"
		else
			echo "${program_name} is NOT installed."
			echo "program dependencies are: ${program_dependencies[@]}"
  			msg="Required program not found. Exiting now..."
			lib10k_exit_with_error "$E_REQUIRED_PROGRAM_NOT_FOUND" "$msg"
		fi
	done

}

################################################################

function display_program_header()
{
	#program_title="${1}"
	#original_author="${2}"

	# Display a program header and give user option to leave if here in error:
    echo
    echo -e "			\033[33m==============================================================\033[0m";
    echo -e "			\033[33m||			Welcome to the $program_title			\033[0m";
	echo -e "			\033[33m||			Author: $original_author					\033[0m"; 
	echo -e "			\033[33m==============================================================\033[0m";
    echo

	if type cowsay > /dev/null 2>&1
	then
		cowsay "Hello, ${USER}!"
	fi
}

################################################################
# - trim leading and trailing space characters
function sanitise_input_spaces_both_ends()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	# while....?

	# TRIM TRAILING AND LEADING SPACES AND TABS
	test_line=${test_line%%[[:blank:]]}
	test_line=${test_line##[[:blank:]]}

	echo "test line after space cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
################################################################
# for example to prepare 
function remove_trailing_fwd_slash()
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
################################################################
# for example, to prepare file path to append another
function remove_leading_fwd_slash()
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
################################################################
# 
function make_abs_pathname()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	while [[ "$test_line" == *'/' ]] ||\
	 [[ "$test_line" == *[[:blank:]] ]] ||\
	 [[ "$test_line" == [[:blank:]]* ]]
	do
		# call the appropriate set of functions
		sanitise_input_spaces_both_ends "$test_line"
		remove_trailing_fwd_slash "$test_line"
	done

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
################################################################
function make_rel_pathname()
{
	test_line="${1}"
	echo "test line on entering "${FUNCNAME[0]}" is: $test_line" && echo

	while [[ "$test_line" == *'/' ]] ||\
	 [[ "$test_line" == *[[:blank:]] ]] ||\
	 [[ "$test_line" == [[:blank:]]* ]] ||\
	 [[ "$test_line" == '/'* ]]
	do
		# call the appropriate set of functions
		sanitise_input_spaces_both_ends "$test_line"
		remove_trailing_fwd_slash "$test_line"
		remove_leading_fwd_slash "$test_line"
	done

	echo "test line after trim cleanups in "${FUNCNAME[0]}" is: $test_line" && echo
}
################################################################

# generic need to test for access to a directory. 3 logical states:
# 0. directory exists and is cd-able
# 1. directory exists and is not cd-able
# 2. neither of those, so directory does NOT exist
# 
function test_dir_path_access
{
	echo && echo "ENTERED INTO FUNCTION ${FUNCNAME[0]}" && echo

	test_result=
	test_dir_fullpath=$1

	echo "test_dir_fullpath is set to: $test_dir_fullpath"

	if [ -d "$test_dir_fullpath" ] && cd "$test_dir_fullpath" 2>/dev/null
	then
		# directory file found and accessible
		echo "directory "$test_dir_fullpath" found and accessed ok" && echo
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

	echo && echo "LEAVING FROM FUNCTION ${FUNCNAME[0]}" && echo

	return "$test_result"
}
################################################################





