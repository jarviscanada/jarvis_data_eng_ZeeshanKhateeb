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

# Collect system usage data
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Get host_id
host_id=$(PGPASSWORD=$psql_password psql -h $psql_host -p $psql_port -U $psql_user -d $db_name \
-c "SELECT id FROM host_info WHERE hostname='$(hostname -f)';" | sed -n 3p | xargs)

# Collect memory usage (MB)
memory_free=$(vmstat --unit M 1 2 | tail -1 | awk '{print $4}')

# Collect CPU usage
cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat 1 2 | tail -1 | awk '{print $14}')

# Collect disk IO
disk_io=$(vmstat -d 1 2 | tail -1 | awk '{print $10}')

# Collect disk available (MB)
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/M//')

# Construct INSERT statement
insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

# Execute INSERT
PGPASSWORD=$psql_password psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$insert_stmt"

exit $?
