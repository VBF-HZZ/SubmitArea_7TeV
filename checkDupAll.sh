#!/bin/sh

for DIR in Data_JanA_Aug Data_JanA_Aug_MuEG  Data_JanA_Jul1 Data_JanA_Jul1_MuEG Data_JanA_Jul2 \
Data_JanA_Jul2_MuEG Data_JanA_Oct Data_JanA_Oct_MuEG Data_JanB Data_JanB_MuEG ;
do
  echo in $DIR
  for FILE in $DIR/*.txt;
  do
    echo checking file $FILE
    ./checkDuplicatedFiles.sh $FILE
  done
done
