#!/bin/sh

for file in `ls -1 errFiles/*.err | grep 7TeV`; 
do 
  exist=`grep $file err.log`; 
  if [ "$exist" == "" ]; then echo $file; fi ; 
done
