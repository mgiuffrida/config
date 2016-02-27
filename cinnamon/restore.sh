#!/bin/bash

#cp -r ~/.cinnamon/configs ~/.cinnamon_configs.bak

cd `dirname $0`
for config_dir in */ ; do
  backup_config_file=$(find "$config_dir" -type f)
  echo $backup_config_file
  echo $config_dir
  current_config_file=$(find ~/.cinnamon/configs/$config_dir -type f)
  echo $current_config_file
  cp $backup_config_file $current_config_file
done
