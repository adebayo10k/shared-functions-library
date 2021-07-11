#
# library of contants and literals that are reused in the same contexts by multilple scripts in the 10k domain

# exit codes are required by main scripts for the shell session

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
export E_UNKNOWN_ERROR=32


# abs filepath with trailing / 
ABS_FILEPATH_WITH_TB_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+(/){1}$' 
# abs filepath without trailing / 
ABS_FILEPATH_NO_TB_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+$' 
# abs filepath with or without trailing / 
ABS_FILEPATH_FLEX_TB_REGEX='^(/{1}[A-Za-z0-9._~:@-]+)+(/)?$'
#email regex
EMAIL_REGEX='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$'
# ^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$
# ^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:].]{2,4}$ ]]
# file extension regex
FILE_EXTENSION_REGEX='^\.{1}[A-Za-z0-9]+$'


