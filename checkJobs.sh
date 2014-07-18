#!/bin/sh

INPUTDIR=$1

ERRDIR=errFiles
RESULTDIR=${INPUTDIR/Submission_/results_}

for file in $INPUTDIR/*.py
do 
  file_py=`basename $file`
  file_err=`basename $file .py`.err
  file_root=`basename $file .py`.root
  file_root=${file_root/_cfg_/_}
  
  if [ ! -e ${RESULTDIR}/$file_root ]; then
    echo ${INPUTDIR}/$file_py
  else
    error=`grep FatalRootError $ERRDIR/$file_err`
    error="${error}`grep \"job killed\" $ERRDIR/$file_err`"
    if [ "$error" != "" ]; then
      echo ${INPUTDIR}/$file_py 
    fi
  fi

done

