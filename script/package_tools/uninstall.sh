#!/bin/bash

# 卸载/home/lum/iros_ws/下的所有deb
echo "start unload  package........."
for i in `dpkg-query -S /home/lum/iros_ws/ | sed 's|: */home/lum/iros_ws.*$||' | tr -d ',' |tr ' ' '\n' |sort | uniq`; do 
  echo "start dpkg -P $i"
  sudo dpkg -P $i
  echo "finish dpkg -P $i"
done
echo "finish unload  package........."