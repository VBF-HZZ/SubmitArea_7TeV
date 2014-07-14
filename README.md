UF Higgs Analyzer Submit Area for 7 TeV
----

Install instruction:

This is supposed to be an accompany package for UFHZZAnalysis7TeV
It is to be instealled in the same directory as CMSSW_4_4_5, in a structure like:

[lihengne@alachua analyzer7tev]$ ll
total 12
drwxr-xr-x 16 lihengne cms 4096 Jul 13 12:44 CMSSW_4_4_5
drwxr-xr-x  4 lihengne cms 4096 Jul 14 04:47 SubmitArea_7TeV
-rwxr-xr-x  1 lihengne cms  462 Jul 13 12:42 install.sh

To install:
git clone https://github.com/VBF-HZZ/SubmitArea_7TeV.git
cd SubmitArea_7TeV 
git checkout -b testProd origin/testProd
cd bin/
gmake
cd ../

Alternatively, one can use the install.sh script at UFHZZAnalysis8TeV to install all together:
https://raw.githubusercontent.com/VBF-HZZ/UFHZZAnalysis7TeV/testProd/install.sh


To use:
Please temporarily refer to the other readme file SubmitArea_7TeV/README


