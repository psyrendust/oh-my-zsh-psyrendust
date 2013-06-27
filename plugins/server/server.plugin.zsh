# Start an HTTP server from a directory, optionally specifying the port
# param: port number
# $ server
# $ $ server 8080

function server()
{
  local port="${1:-8000}"
  if  [[ $('uname') == 'Darwin' ]]; then

    open "http://localhost:${port}/"

  elif  [[ $('uname') == '^(CYGWIN_NT-6.1-WOW64)' ]]; then

    cygstart "http://localhost:${port}/"

  fi

  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}