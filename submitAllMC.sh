#!/bin/sh

list=""
list="${list} Submission_HZZSamples "

for f in $list ;
do
  ./Submit.sh $f
done
