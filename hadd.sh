#!/bin/sh

INDIR=results_HZZSamples_RMDUP
OUTDIR=rootFiles
hadd ${OUTDIR}/ZZ_2e2mu.root ${INDIR}/ZZTo2e2mu*.root 
hadd ${OUTDIR}/ZZ_4e.root ${INDIR}/ZZTo4e*.root
hadd ${OUTDIR}/ZZ_4mu.root ${INDIR}/ZZTo4mu*.root
hadd ${OUTDIR}/ZZto2e2tau.root ${INDIR}/ZZTo2e2tau*.root
hadd ${OUTDIR}/ZZto2mu2tau.root ${INDIR}/ZZTo2mu2tau*.root
hadd ${OUTDIR}/ZZto4tau.root ${INDIR}/ZZTo4tau*.root
hadd ${OUTDIR}/ggZZ_2e2mu.root ${INDIR}/GluGluToZZTo2L2L*.root
hadd ${OUTDIR}/ggZZ_4l.root ${INDIR}/GluGluToZZTo4L*.root
hadd ${OUTDIR}/mH_350_VBF.root ${INDIR}/VBF_ToHToZZTo4L_M-350_*root
hadd ${OUTDIR}/mH_350_ggH.root ${INDIR}/GluGluToHToZZTo4L_M-350_*root

