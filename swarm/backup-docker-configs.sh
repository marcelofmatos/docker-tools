#!/bin/bash

service_name="backup-all-configs"
config_list=( `docker config ls --format "{{ .Name }}"` )

cmd="docker service create \
  --name $service_name \
  --constraint node.hostname==`hostname` "

for config in "${config_list[@]}"
do
  cmd=$cmd" --config ${config}"
done

cmd=$cmd" nginx"
echo $cmd
#exit 0
$cmd

tar_file="backup_`date +\"%Y%m%d-%H%M%S\"`.tar"
container_id=`docker ps -f "label=com.docker.swarm.service.name=$service_name" -q`

echo $tar_file
echo $container_id

docker exec -w /usr/local $container_id sh -c "mkdir /usr/local/configs && find / -maxdepth 1 -type f -exec cp {} /usr/local/configs \;"
docker exec -w /usr/local $container_id sh -c "tar -cvf /usr/local/$tar_file -C /usr/local/configs ."

docker cp $container_id:/usr/local/$tar_file .

docker service rm $service_name
