#!/bin/sh

list=""
list="${list} Submission_HZZSamples_test2 "

for f in $list ;
do
  ./Submit.sh $f
done
