#!/bin/bash

# Assign CLI arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Validate argument count
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# Collect hardware specifications
hostname=$(hostname -f)

cpu_number=$(lscpu | egrep "^CPU\(s\):" | awk '{print $2}')
cpu_architecture=$(lscpu | egrep "Architecture:" | awk '{print $2}')
cpu_model=$(lscpu | egrep "Model name:" | sed 's/Model name:[ \t]*//')
cpu_mhz=$(lscpu | grep "Model name:" | sed 's/.*@ //; s/GHz//' | awk '{printf "%.0f", $1*1000}')
echo "cpu_mhz=$cpu_mhz"
l2_cache=$(lscpu | egrep "L2 cache:" | awk '{print $3}' | sed 's/K//')

total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')

timestamp=$(date '+%Y-%m-%d %H:%M:%S')


# Construct INSERT statement
insert_stmt="INSERT INTO host_info(hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,l2_cache,total_mem,timestamp) VALUES('$hostname','$cpu_number','$cpu_architecture','$cpu_model',$cpu_mhz,$l2_cache,$total_mem,'$timestamp');"
echo "$insert_stmt"
# Export password for psql
export PGPASSWORD=$psql_password

# Execute INSERT
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
