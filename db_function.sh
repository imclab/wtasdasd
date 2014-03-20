
function do_mysql_query(){
        mysql -u root -ptest u7006751_oc $1
}

containsElement () {
  local e
  for e in ${@:2}; do
        if [[ $e == $1 ]]; then
                echo "1";
                return;
        fi
  done
  echo "0";
}
