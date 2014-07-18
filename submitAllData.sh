#!/bin/sh

list=""
#list="${list} Submission_Data_JanA_Aug "
#list="${list} Submission_Data_JanA_Aug_MuEG "
list="${list} Submission_Data_JanA_Jul1 "
list="${list} Submission_Data_JanA_Jul1_MuEG "
list="${list} Submission_Data_JanA_Jul2 "
list="${list} Submission_Data_JanA_Jul2_MuEG "
#list="${list} Submission_Data_JanA_Oct "
#list="${list} Submission_Data_JanA_Oct_MuEG "
#list="${list} Submission_Data_JanB "
#list="${list} Submission_Data_JanB_MuEG "

for f in $list ;
do
  ./Submit.sh $f
done
