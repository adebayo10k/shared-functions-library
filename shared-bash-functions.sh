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


