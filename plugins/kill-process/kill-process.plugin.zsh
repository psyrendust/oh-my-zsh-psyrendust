# Kill a process by name
function killname() {
  process_name=$1;
  len=${#process_name};
  new_process_name="[${process_name:0:1}]${process_name:1:$len}";
  ps -A | grep -i $new_process_name | awk '{ print "Found: "$0 }';
  if [ $len = 1 ]; then
    echo "Do you wish to kill these processes? (y/n) ";
  else
    echo "Do you wish to kill this process? (y/n) ";
  fi
  read resp;
  case $resp in
    [Yy]* ) ps -A | grep -i $new_process_name | awk '{print $1}' | xargs kill -9;;
    [Nn]* ) echo "Goodbye"; return;;
  esac
}
