#!/bin/bash
# This script creates symbolic links to shared library files from writable locations like /usr/local/lib.
# This script is included in all shared library files, which in turn are included by most main programs.
# This script is only executed during library file "installation" process (described in library files).

#================================
# SYMLINK BACK TO LIBRARY FILE FROM user_dir
#================================

# add symlinks to user locations.
function add_symlink(){
	local user_dir="$1"

	# create a lib10k/ subdirectory
	lib_link_dir="${user_dir}/lib10k"
	if [[ $user_dir =~ '/usr/local/lib' ]] # root owned directory
	then
		sudo mkdir -p "$lib_link_dir" >/dev/null 2>&1
	else
		mkdir -p "$lib_link_dir" >/dev/null 2>&1
	fi

	# create symlink to library file
	lib_link="${lib_link_dir}/${script_basename}"
	if [ ! -h "$lib_link" ]  # file exists and is a symbolic link (not)
	then
		echo "Creating symbolic link:"
		echo "TARGET	: $script_path"
		echo "LINK	: $lib_link" && echo
		if [[ $user_dir =~ '/usr/local/lib' ]] # root owned directory
		then
			sudo ln -s "$script_path" "$lib_link" >/dev/null 2>&1
		else
			ln -s "$script_path" "$lib_link" >/dev/null 2>&1
		fi
	else
		echo "The symbolic link [$lib_link] already exists OK" && echo
	fi
}

# if runtime basename matches shared-bash-functions.sh || shared-bash-constants.inc.sh
# then we must be creating symbolic links to library files in a local git repository.
# TODO: Put library script filenames into an array
if [[ $script_basename =~ 'shared-bash-functions.inc.sh'  ]] || \
[[ $script_basename =~ 'shared-bash-constants.inc.sh'  ]]
then
	for user_dir in "${HOME}/.local/share" '/usr/local/lib'
	do
		add_symlink "$user_dir"
	done
fi


