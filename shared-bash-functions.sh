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

	echo "EXIT CODE: $error_code" | tee -a $LOG_FILE
	echo "$error_message" | tee -a $LOG_FILE && echo && sleep 1
	echo "USAGE: $(basename $0) ABSOLUTE_FILEPATH..." | tee -a $LOG_FILE && echo && sleep 1

	exit $error_code
}

################################################################
