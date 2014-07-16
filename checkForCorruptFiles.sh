#!/bin/sh

echo "Following jobs have problem: "

for file in errFiles/*.err
do 
  error=`grep FatalRootError $file`
  if [ "$error" != "" ]; then
    echo $file
   # echo "  Error: $error" 
  fi
done

