#!/bin/bash
[[ -z $1 ]] && echo "please give a name" && exit 1

name="$1"

vagrant destroy
vagrant up
vagrant package --output "se-$name-$(date +%Y%m%d).box"
