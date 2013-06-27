# Commands to control local apache2 server installation on Mac

alias apache2start='sudo apachectl start'
alias apache2stop='sudo apachectl stop'
alias apache2restart='sudo apachectl restart'
alias apache2load='sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
alias apache2unload='sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist'