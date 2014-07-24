#!/bin/sh

for DIR in HZZSamples ;
do
  echo in $DIR
  outdir="${DIR}_RMDUP"
  if [ ! -e $outdir ]; then 
    mkdir $outdir
  fi

  for FILE in $DIR/*.txt;
  do
    echo checking file $FILE
    basefile=`basename $FILE`
    ./removeDuplicatedFiles.sh $FILE $outdir/$basefile
  done
done
