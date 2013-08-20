# Kill a process by name
function killname() {
  processname=$1;
  len=${#processname};
  newprocessname="[${processname:0:1}]${processname:1:$len}";
  ps -A | grep -i $newprocessname | awk '{ print "Found: "$0 }';
  if [ $len = 1 ]; then
    echo "Do you wish to kill these processes? (y/n) ";
  else
    echo "Do you wish to kill this process? (y/n) ";
  fi
  read resp;
  case $resp in
    [Yy]* ) ps -A | grep -i $newprocessname | awk '{print $1}' | xargs kill -9;;
    [Nn]* ) echo "Goodbye"; return;;
  esac
}