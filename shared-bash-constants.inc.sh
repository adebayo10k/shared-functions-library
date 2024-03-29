#!/bin/bash
# This library file is included by many main bash shell utility/application programs.
# It can optionally be first "installed", meaning symlinks are created on the system, \
#in locations (like /usr/local/lib) expected by those main bash programs. To do this installation, just
# execute this file from its' local git project repository directory:
# Use this command:
# cd path/to/shared-functions-library/ && ./shared-bash-constants.inc.sh
# That install only need be done once, although it is idempotent in any case.


# Get path to this script. 
# It will be to either THIS library script OR a main script, depending on runtime.
lib_script_path="$(readlink -f $0)" 
lib_script_basename="$(basename $lib_script_path)"
lib_script_dirname="$(dirname $lib_script_path)"

if [[ $lib_script_basename =~ 'shared-bash-constants.inc.sh' ]] 
then
	# we must be running this script directly, to create symlinks
	source "${lib_script_dirname}/symlink_lib_file.inc.sh"
fi

#===============
# COMMON LITERALS
#===============

# Library of constants and literals that are reused in the same contexts by multilple scripts in the 10k domain

RED='\033[31m'
RED_BOLD='\033[1;31m'
BLUE='\033[34m'
BLUE_BOLD='\033[1;34m'
BROWN='\033[33m'
BROWN_BOLD='\033[1;33m'
GREEN='\033[32m'
GREEN_BOLD='\033[1;32m'
NC='\033[0m' # No Color

# exit codes required by main script and any sporned child shells
## EXIT CODES:
export E_UNEXPECTED_BRANCH_ENTERED=10
export E_OUT_OF_BOUNDS_BRANCH_ENTERED=11
export E_INCORRECT_NUMBER_OF_ARGS=12
export E_UNEXPECTED_ARG_VALUE=13
export E_REQUIRED_FILE_NOT_FOUND=20
export E_REQUIRED_PROGRAM_NOT_FOUND=21
export E_UNKNOWN_RUN_MODE=30
export E_UNKNOWN_EXECUTION_MODE=31
export E_FILE_NOT_ACCESSIBLE=40
export E_INCORRECT_FILE_TYPE=43
export E_INCORRECT_HOST=50
export E_UNKNOWN_ERROR=99


# abs filepath with trailing / 
ABS_FILEPATH_WITH_TS_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+(/){1}$' 
# abs filepath without trailing / 
ABS_FILEPATH_NO_TS_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+$' 
# abs filepath with or without trailing / 
ABS_FILEPATH_FLEX_TS_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+(/)?$'

#email regex
EMAIL_REGEX='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$'
# ^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$
# ^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:].]{2,4}$ ]]
# file extension regex
FILE_EXTENSION_REGEX='^\.{1}[A-Za-z0-9]+$'

# basic URL for only obligitary http, https schema.
# No anchors to allow concatenation with other regexes.
BASIC_URL_REGEX='http(s)?:\/\/(www\.)?[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[a-zA-Z0-9-]{2,}(\/)?'

# relative base filepath, with or without extension
# No leading anchor to allow concatenation with other regexes.
REL_FILEPATH_REGEX='([A-Za-z0-9\._~:@-]+/)+[A-Za-z0-9\._~:@-]+$'

# file basename, with or without extension
# No leading anchor to allow concatenation with other regexes.
FILE_BASENAME_REGEX='[A-Za-z0-9_\-]+(\.[A-Za-z0-9\._\-])?$'
# file basename, with or without extension
# with Leading anchor
FILE_BASENAME_LA_REGEX='^([A-Za-z0-9_\-])+\.?([A-Za-z0-9\._\-])+$'

# file basename, with or without extension
# with Leading anchor
# with possible ONE shell expansion only
FILE_BASENAME_LA_WITH_SE_REGEX='^(\.{1,2}/)*[A-Za-z0-9\._-]+$'

# abs filepath without trailing /, with possible ONE shell expansion only
#ABS_FILEPATH_NO_TS_WITH_SE_REGEX='^\.{1,2}(/{1}[A-Za-z0-9._~\-]+)+$' 



