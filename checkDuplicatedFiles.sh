#!/bin/sh

FILE=$1

duplicated="dup"

# loop all files
for file1 in `cat $FILE`;
do
 str1=${file1%_*\'}
 str1=${str1/\'file:/}
 str1=`basename $str1`
 str1b=${str1%_*}_

 nfiles=`grep $str1b $FILE | wc -l`

 if [ "$nfiles" -eq "1" ]; then
   echo $str1b
   grep $str1b $FILE
 else
   booked="false"
   for dupstr in $duplicated;
   do
     if [ "$dupstr" == "$str1b" ];
     then
       booked="true"
     fi
   done
   if [ "$booked" == "false" ]; then
       echo duplicated $str1b
       grep $str1b $FILE
       duplicated="$duplicated $str1b"
   fi
 fi

done

