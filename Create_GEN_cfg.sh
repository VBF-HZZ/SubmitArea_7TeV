#!/bin/bash             


if [[ "$2" == "" ]]; then
    JobsPerDataset=5
else
JobsPerDataset=$2
fi
weightEvents=True #True or False

if [ "$1" == "" ]; then 
    echo "Please pass a dir with txt files for datasets to be processed!"
    exit 1;
fi


dir=${1}


if [ ! -d "Submission_GEN_${dir}" ]
      then mkdir Submission_GEN_${dir}
fi


cd $dir

for f in $(ls *.txt)
  do
  
  patTuples=$(cat $f)
  
  txtFile=${f%%.txt*}
  
  mH=$(../bin/getHiggsMass.exe ${txtFile} )  
  if [[ "$mH" == "0" ]]; then
      isSignal="False"
  else
      isSignal="True"
  fi
  
  CrossSect=$(../bin/getCrossSection.exe ${txtFile} )
  FilterEff=$(../bin/getFilterEff.exe ${txtFile} )
  nEvents=$(../bin/getNEvents.exe ${txtFile} )
  
  workDir=../Submission_GEN_${dir}
  cfgSRC2=../${cfgSRC}
  
  echo $f
  
  nJobsPerDataset=${JobsPerDataset}  
  nLines=$(cat $f | wc -l)
  
  nFilesPerJob=$( echo "scale=0;${nLines}/${nJobsPerDataset}" | bc)
  nFilesLeftover=$( echo "${nLines}%${nJobsPerDataset}" | bc)
  
  nJobsPerDataset=${JobsPerDataset}
  
  if(( $nLines < $nJobsPerDataset)); then
      nJobsPerDataset=$nLines
      nFilesPerJob=1
      nFilesLeftover=0
  fi
  

  if [[ "$nFilesLeftover" == "0" ]]; then
  totalJobs=${nJobsPerDataset}
      
      for(( i=0; i<${totalJobs}; i++ ));
	do
	counterArray[$i]=${nFilesPerJob}
      done
  else
     let totalJobs=${nJobsPerDataset}+1
     let lastJob=${nJobsPerDataset}
      
      for(( i=0; i<${totalJobs}; i++ ));
	do
	
	if [[ "$i" == "$lastJob" ]]; then
	    counterArray[$i]=${nFilesLeftover}
	else
	    counterArray[$i]=${nFilesPerJob}
	fi
      done
      
  fi
  
    
  tmpCounter=1
  arrayCounter=0
  jobCounter=0
  
  files=""
  while read line
    do

    if [[ "$tmpCounter" != "${counterArray[arrayCounter]}" ]]; then
      
	files+=$line,
	let tmpCounter=${tmpCounter}+1
    else
	files+=$line
	let arrayCounter=${arrayCounter}+1
	
	cfgFile=${txtFile}_cfg_${jobCounter}.py
	let jobCounter=${jobCounter}+1
	
echo "import FWCore.ParameterSet.Config as cms

process = cms.Process(\"UFHZZ4LAnalysis\")

process.load(\"FWCore.MessageService.MessageLogger_cfi\")
process.MessageLogger.cerr.FwkReport.reportEvery = 1000
process.MessageLogger.categories.append('UFHZZ4LAna')
process.load(\"Configuration.StandardSequences.MagneticField_cff\")

process.Timing = cms.Service(\"Timing\",
                             summaryOnly = cms.untracked.bool(True)
                             )


process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(-1) )

myfilelist = cms.untracked.vstring()
myfilelist.extend( [

" >> ${workDir}/${cfgFile}

echo $files >> ${workDir}/${cfgFile}

echo "

]
)

process.source = cms.Source(\"PoolSource\",
                             duplicateCheckMode = cms.untracked.string('noDuplicateCheck'),
                             fileNames = myfilelist)

process.TFileService = cms.Service(\"TFileService\",
                                   fileName = cms.string(\""${txtFile}_${jobCounter}".root\")
                                   )

process.GENAna = cms.EDAnalyzer('UFHZZ4LGenEvents')

process.p = cms.Path(process.GENAna)





" >> ${workDir}/${cfgFile}

files=""
tmpCounter=1


  fi


done < $f

jobCounter=0
done

cd ../