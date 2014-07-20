#!/bin/bash


sublist=$1

if [ "$sublist" == "" ]; then
    echo "Please pass an Submission list file!"
    exit 1;
fi


if [ -d $outDir ]; then
    echo "results directory exists!"
else
    mkdir $outDir
fi

if [[ ! -d outFiles ]]; then mkdir outFiles; fi;
if [[ ! -d errFiles ]]; then mkdir errFiles; fi;



curDir=`pwd`

for f in $(cat ${sublist})
  do

  submitDir=`dirname $f`

  appendName=${submitDir#*Submission_}
  outDir=results_${appendName}

  NAME=`basename $f .py`
  f2=`basename $f`

  echo ${NAME}
  
  qsub -v jobName=${NAME},curDir=${curDir},submitDir=${submitDir},cfgFile=${f2},outDir=${outDir} -N "$NAME" submitFile.pbs.sh
  
done
