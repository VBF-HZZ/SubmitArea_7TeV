#!/bin/sh

FILE=$1
FILEOUT=$2

OUTDIR=`dirname $FILEOUT`
if [ ! -e $OURDIR ]; then
  mkdir -p $OUTDIR
fi

if [ -e $FILEOUT ]; then
  rm $FILEOUT
fi

touch $FILEOUT

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
   echo $file1 >> $FILEOUT
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
     # also check file size
     location=${file1%_*\'}
     location=${location/\'file:/}
     location=`dirname $location`
     #list all files
     ls -l ${location}/${str1b}*.root
     bigfilename=""
     bigfilesize="0"
     for onefile in ${location}/${str1b}*.root;
     do
       onefilesize=`ls -l ${onefile} | awk {'print $5'}`
       echo $onefile $onefilesize
       if [ "$onefilesize" -gt "$bigfilesize" ]; then
         bigfilesize=$onefilesize
         bigfilename=$onefile
       fi
     done
     # choose the biggest filesize ()
     echo "'file:${bigfilename}'" >> $FILEOUT
    
   fi
 fi

done

