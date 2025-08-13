#!/bin/bash

cd ~/iros_ws/cpu

Now_time=$(date);
echo -e "\e[1;32mNow_time:${Now_time} \e[0m" && sleep 1;
echo -e "\e[32mOk, Now start to analyse the record_cpu.txt! \e[0m" && sleep 0.1;
cat record_cpu.txt | awk -F " " '{if(($10>100 && $13=="iros")||($11>40 && $13=="comm_bridge")||($10>200 && $13=="lslam"))print $10"\t"$11"\t"$12" \t"$13}' > analyse.txt
echo -e "\e[33mOk, Analyse finish! \e[0m" && sleep 0.1;