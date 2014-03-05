# Commands to control local apache2 server installation on Mac

alias apstart='sudo apachectl start'
alias apstop='sudo apachectl stop'
alias aprestart='sudo apachectl restart'
alias apload='sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
alias apunload='sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
