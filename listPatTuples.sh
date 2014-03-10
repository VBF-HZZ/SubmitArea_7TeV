#!/bin/bash


numberOfJobsPerDataset=5

if [ -z "$1" ]; then 
    echo "Please pass a directory on the T2! (from /cms/data/store/user/snowball/)"
    exit 1;
fi

curDir=`pwd`

listDir=$curDir/patTuples

if [ ! -d $listDir ]; then
    mkdir $listDir
fi


cd /cms/data/store/user/snowball/$1

jobCounter=0

for d in $(ls .)
  do

  outFile=$d.txt
  
  if [ -f $listDir/$outFile ]; then
      rm $listDir/$outFile
  fi
  
  fileCount=$(ls -1 $d | wc -l)
  counter=1

  echo $d

  for f in $(ls $d/*.root) 
    do
    
    dir=$(pwd)
    
  
    
    if [ "$counter" == "$fileCount" ];
	then 
	fileList="'file:$dir/$f'"
    else
	fileList="'file:$dir/$f'"
    fi

  

    echo $fileList >> $listDir/$outFile
    let counter=$counter+1
    
  done
  
done

cd ~

  