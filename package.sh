#!/bin/bash
[[ -z $1 ]] && echo "please give a name" && exit 1

name="$1"

vagrant destroy -f # just to be sure

sed -e 's/#config.ssh.insert_key/config.ssh.insert_key/' \
    -i Vagrantfile
vagrant up
vagrant halt
sed -e 's/config.ssh.insert_key/#config.ssh.insert_key/' \
    -i Vagrantfile
vagrant up
#vagrant ssh
vagrant package --output "se-$name-$(date +%Y%m%d).box"

vagrant destroy -f # cleanup after making the box
