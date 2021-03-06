# shared-functions-library
This project repository is generally added to other project repositories as a submodule.
It contains the set of functions that used in common by most of the development bash shell scripts found in [adebayo10k](https://github.com/adebayo10k) repositories.

## Files
- shared-bash-functions.inc.sh - contains commonly used functions.
- shared-bash-constants.inc.sh - contains collected literals like regular expressions.
- symlink_lib_file.inc.sh - creates symbolic links back to the above two files in their local git repo locations.

## Purpose
The library files _shared-bash-functions.inc.sh_ and _shared-bash-constants.inc.sh_ are included (sourced) by many main bash shell utility/application programs.
They must first be "installed", meaning symlinks must be created on the system (in readable locations like _/usr/local/lib_), where those main bash programs can expect to find them.

## Requirements
None.

## Prerequisites
None.

## Installation

``` bash
git clone https://github.com/adebayo10k/shared-functions-library.git
```

## Running the Script
Running the script simply results in symbolic links in handy locations that reference back to these files (presumably still in their local git project locations). 
Just `cd` to wherever these files are, and execute them directly in their directory, something like: 

``` bash
cd path/to/shared-functions-library/ && ./shared-bash-functions.inc.sh && ./shared-bash-constants.inc.sh
```

The previous command only needs to be executed once, although it is idempotent in any case.

EXPECTED OUTPUT:

Something like...

```
Creating symbolic link:
TARGET	: /home/user/bin/utils/shared-functions-library/shared-bash-functions.inc.sh
LINK	: /usr/local/lib/lib10k/shared-bash-functions.inc.sh

Creating symbolic link:
TARGET	: /home/user/bin/utils/shared-functions-library/shared-bash-constants.inc.sh
LINK	: /usr/local/lib/lib10k/shared-bash-constants.inc.sh
```

...Or if the scripts have been run previously, something like...

```
The symbolic link [/home/user/.local/share/lib10k/shared-bash-functions.inc.sh] already exists OK

The symbolic link [/home/user/.local/share/lib10k/shared-bash-constants.inc.sh] already exists OK
```


## Configuration
The directory locations of these commonly shared library files (or at least the symbolic links to them) are ideal variables to be exported to the environment every time a user logs in.
So for example, assuming the location _/usr/local/lib/lib10k/_ was accessibe and writable, you could optionally update your _~/.bashrc_ file with:

``` bash
export SHARED_LIBRARIES_DIR='usr/local/lib/lib10k/'
```


## Parameters
None.

## Logging
None.

## License


## Contact














