#!/bin/sh

list=""
list="${list} Submission_Data_JanA_Aug_RMDUP "
list="${list} Submission_Data_JanA_Aug_MuEG_RMDUP "
list="${list} Submission_Data_JanA_Jul1_RMDUP "
list="${list} Submission_Data_JanA_Jul1_MuEG_RMDUP "
list="${list} Submission_Data_JanA_Jul2_RMDUP "
list="${list} Submission_Data_JanA_Jul2_MuEG_RMDUP "
list="${list} Submission_Data_JanA_Oct_RMDUP "
list="${list} Submission_Data_JanA_Oct_MuEG_RMDUP "
list="${list} Submission_Data_JanB_RMDUP "
list="${list} Submission_Data_JanB_MuEG_RMDUP "

for f in $list ;
do
  ./Submit.sh $f
done
