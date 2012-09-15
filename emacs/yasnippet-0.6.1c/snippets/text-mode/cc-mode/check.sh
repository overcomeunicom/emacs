#!/bin/bash
cd /home/ric/emacs/yasnippet-0.6.1c/snippets/text-mode/cc-mode
file_list=`ls c++-mode`
part_file_list=""
count=0
path="c++-mode/"
prefix="part"
postfix=".gz"
index=0
split_delim=" "
for file in $file_list
do
count=$((count+1))
if [ $count -eq 50 ]; then
index=$((index+1))
gzip -c $part_file_list >> $prefix$index$postfix
part_file_list=$split_delim
count=0
fi
part_file_list=$part_file_list$split_delim$path$file
done
index=$((index+1))
gzip -c $part_file_list >> $prefix$index$postfix
