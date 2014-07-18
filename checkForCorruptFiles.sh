#!/bin/sh

echo "Following jobs have problem: "

for file in errFiles/*.err
do 
  error=`grep FatalRootError $file`
  error="${error}`grep \"job killed\" $file`"

  if [ "$error" != "" ]; then
    #echo $file
    #echo "  Error: $error" 
    ls Submission*/`basename $file .err`.py
  fi
done

