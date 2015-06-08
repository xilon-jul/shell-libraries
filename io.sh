# Exposes $p that holds the result of the read
function prompt {
  local def=""
  local timeout=0;
  if [ ! -z ${2:-} ]; then
        def=$2;
  fi  
  if [ ! -z ${3:-} ]; then
        timeout=$3;
  fi  
  echo -e "$1 [default=$def]"
  if [ $timeout -eq 0 ]; then
          read p
  else 
          read -t "$timeout" p
  fi  
  if [ -z "$p" ]; then
          p=$def;
  fi  
}

