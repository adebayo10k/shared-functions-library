# shared-functions-library
The set of functions that are being shared by most of my bash shell scripts.

# Files
shared-bash-functions.inc.sh - contains commonly used functions.
shared-bash-constants.inc.sh - contains collected literal like regular expressions.
symlink_lib_file.inc.sh - creates symbolic links back to the above two files in their local git repo locations.

FLOWCHART MODEL

# Purpose
The library files shared-bash-functions.inc.sh and shared-bash-constants.inc.sh are included (sourced) by many main bash shell utility/application programs.
They must first be "installed", meaning symlinks must be created on the system (in locations like /usr/local/lib), where those main bash programs can expect to find them.

# Requirements
None.

# Prerequisites
None.

# Installation
git clone https://github.com/adebayo10k/shared-functions-library.git


# Running the Script
Running the script simply results in symbolic links in handy locations that reference back to these files (presumably in their local git project locations). 
Just cd to wherever these files are, and execute them directly in their directory, something like: 

cd path/to/shared-functions-library/ && ./shared-bash-functions.inc.sh && ./shared-bash-constants.inc.sh

EXPECTED OUTPUT:

Depending on whether the script has been run previously, something like:

The symbolic link [/home/user/.local/share/lib10k/shared-bash-functions.inc.sh] already exists OK

Creating symbolic link:
TARGET	: /home/user/bin/utils/shared-functions-library/shared-bash-functions.inc.sh
LINK	: /usr/local/lib/lib10k/shared-bash-functions.inc.sh

The symbolic link [/home/user/.local/share/lib10k/shared-bash-constants.inc.sh] already exists OK

Creating symbolic link:
TARGET	: /home/user/bin/utils/shared-functions-library/shared-bash-constants.inc.sh
LINK	: /usr/local/lib/lib10k/shared-bash-constants.inc.sh

That command only needs to be executed once, although it is idempotent in any case.

# Configuration
The locations of these commonly shared library files (or at least the symbolic links to them) are ideal variables to be exported to environment every time a user logs in.
So for example, assuming the location /usr/local/lib/lib10k/ was accessibe and writable, you could optionally update your ~/.bashrc file with:

export SHARED_LIBRARIES_DIR='usr/local/lib/lib10k/'


# Parameters
None.

# Logging
None.

# License


# Contact














