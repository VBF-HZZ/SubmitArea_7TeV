#!/bin/sh

INDIR=results_HZZSamples_RMDUP
OUTDIR=rootFiles
echo ${OUTDIR}/ZZ_2e2mu.root; ls -1 ${INDIR}/ZZTo2e2mu*.root
echo ${OUTDIR}/ZZ_4e.root; ls -1 ${INDIR}/ZZTo4e*.root
echo ${OUTDIR}/ZZ_4mu.root; ls -1 ${INDIR}/ZZTo4mu*.root
echo ${OUTDIR}/ZZto2e2tau.root; ls -1 ${INDIR}/ZZTo2e2tau*.root
echo ${OUTDIR}/ZZto2mu2tau.root; ls -1 ${INDIR}/ZZTo2mu2tau*.root
echo ${OUTDIR}/ZZto4tau.root; ls -1 ${INDIR}/ZZTo4tau*.root
echo ${OUTDIR}/ggZZ_2e2mu.root; ls -1 ${INDIR}/GluGluToZZTo2L2L*.root
echo ${OUTDIR}/ggZZ_4l.root; ls -1 ${INDIR}/GluGluToZZTo4L*.root
echo ${OUTDIR}/mH_350_VBF.root; ls -1 ${INDIR}/VBF_ToHToZZTo4L_M-350_*root
echo ${OUTDIR}/mH_350_ggH.root; ls -1 ${INDIR}/GluGluToHToZZTo4L_M-350_*root
