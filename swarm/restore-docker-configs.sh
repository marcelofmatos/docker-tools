config_list=$(ls -1 configs)

for config in $config_list; do
  docker config create $config configs/$config
done;


