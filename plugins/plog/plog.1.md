plog(1) -- logfile helper function
==================================

## SYNOPSIS

__plog__ _NAMESPACE_ _MESSAGE_  
__plog__ \[_-l_ | _-e_\] _NAMESPACE_ _MESSAGE_  
__plog__ \[_-d_\] _NAMESPACE_  

## DESCRIPTION

Output to a logfile located in _$HOME/.psyrendust_. The _NAMESPACE_ argument is appended to the name of the logfile.

__-l__     append a _MESSAGE_ to a logfile for a given _NAMESPACE_

__-e__     append a _MESSAGE_ to an error logfile for a given _NAMESPACE_

__-d__     delete the log and error logfile for a given _NAMESPACE_

__--help__ display this help and exit

## EXAMPLES

Log a message to a logfile named _foobar_ (saves to _$HOME/.psyrendust/log-foobar.log_).
    __plog__ _-l_ foobar "Logging foobar message"  

You can optionally choose to pass no _OPTION_ which is equivalent to __plog__ _-l_.
    __plog__ foobar "Logging foobar message"  


Log an error message to a logfile named _foobar_ (saves to _$HOME/.psyrendust/log-error-foobar.log).
    __plog__ _-e_ foobar "Logging foobar message"  


Delete all _foobar_ logfiles (deletes _$HOME/.psyrendust/log-foobar.log_ and _$HOME/.psyrendust/log-error-foobar.log_).
    __plog__ _-d_ foobar  

## AUTHOR

    Written by Larry Gordon

## COPYRIGHT

    Copyright (C) 2013 Free Software Foundation, Inc.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
    This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.
