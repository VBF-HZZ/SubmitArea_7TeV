#!/bin/bash




if [ "$1" == "" ]; then
    echo "Please pass an Submission directory!"
    exit 1;
fi

appendName=${1#*Submission_}
outDir=results_${appendName}

if [ -d $outDir ]; then
    echo "results directory exists!"
    exit 1;
else
    mkdir $outDir
if [[ ! -d outFiles ]]; then mkdir outFiles; fi;
if [[ ! -d errFiles ]]; then mkdir errFiles; fi;
fi


submitDir=$1
curDir=`pwd`

for f in $(ls ${submitDir}/*.py)
  do

  f2=${f#${submitDir}/}
  NAME=${f2%%.py*}

  echo ${NAME}
  
  qsub -v jobName=${NAME},curDir=${curDir},submitDir=${submitDir},cfgFile=${f2},outDir=${outDir} -N "$NAME" submitFile.pbs.sh
  
done