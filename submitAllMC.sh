#!/bin/sh

list=""
list="${list} Submission_HZZSamples_RMDUP "

for f in $list ;
do
  ./Submit.sh $f
done
