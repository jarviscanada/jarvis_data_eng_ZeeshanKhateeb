
#!/bin/sh

# Validate argument count (at least 1 argument: create|start|stop)
if [ "$#" -lt 1 ]; then
  echo "Illegal number of parameters"
  echo "Usage: $0 create|start|stop [psql_host] [psql_port] [db_name] [psql_user] [psql_password]"
  exit 1
fi

cmd=$1
psql_host=$2
psql_port=$3
db_name=$4
psql_user=$5
psql_password=$6

container_name="jrvs-psql"
volume_name="pgdata"
image="postgres"
port="5432"

# Start docker if not running
sudo systemctl status docker >/dev/null 2>&1 || sudo systemctl start docker

# Check container existence
docker container inspect $container_name >/dev/null 2>&1
container_status=$?

case $cmd in
create)
  if [ $# -ne 6 ]; then
    echo "Usage: $0 create psql_host psql_port db_name psql_user psql_password"
    exit 1
  fi

    if [ $container_status -eq 0 ]; then
      echo "Container already exists"
      exit 1
    fi

    docker volume inspect $volume_name >/dev/null 2>&1 || docker volume create $volume_name

 docker run --name $container_name \
  -e POSTGRES_USER=$psql_user \
  -e POSTGRES_PASSWORD=$psql_password \
  -e POSTGRES_DB=$db_name \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -d \
  -p $psql_port:5432 \
  -v $volume_name:/var/lib/postgresql/data \
  $image

    exit $?
    ;;

  start|stop)
    if [ $container_status -ne 0 ]; then
      echo "Container does not exist"
      exit 1
    fi

    docker container $cmd $container_name
    exit $?
    ;;

  *)
    echo "Illegal command"
    echo "Commands: create|start|stop"
    exit 1
    ;;
esac
