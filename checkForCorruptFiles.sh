#!/bin/bash

for i in *.err
  do 

  echo $i
  cat $i | grep FatalRootError

done

