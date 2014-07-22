#include <iostream>
#include <cmath>
#include <vector>
#include <fstream>
#include <string>

int main(int argc, char* argv[])
{

  if( argc<3 )
  {
    std::cout << argv[0] << " <dataset name> <variable> <cross-section list file>" << std::endl;
    std::cout << "    <variables> can be: crossSection, higgsMass, filterEff, nEvents" << std::endl;
    std::cout << "    <cross-section list file> is optional, default will be the CrossSectionList.txt in the working area" << std::endl;
    return 0;
  }

  std::string datasetname(argv[1]);
  std::string variablename(argv[2]);
  std::string xsecfilename("CrossSectionList.txt");

  if (argc>3) 
  {
    xsecfilename = std::string(argv[3]);
  }
  std::ifstream in;

  in.open(xsecfilename.c_str());
  
  std::vector<std::string> dataset;
  std::vector<double> crossSection;
  std::vector<double> filterEff;
  std::vector<double> higgsMass;
  std::vector<double> nEv;

  std::string tmpDataset;
  double tmpCrossSection;
  double tmpFilterEff;
  double mH;
  double nEvents;

  while( !in.eof() )
  {
    in >> tmpDataset >> tmpCrossSection >> tmpFilterEff >> mH >> nEvents;

    // debug
    //std::cout << tmpDataset << " " << tmpCrossSection << " " << tmpFilterEff << " " << mH << " " << nEvents << std::endl;

    dataset.push_back(tmpDataset);
    crossSection.push_back(tmpCrossSection);
    filterEff.push_back(tmpFilterEff);
    higgsMass.push_back(mH);
    nEv.push_back(nEvents);
  }

  int iset=-100;

  for(int i=0; i<(int)dataset.size(); i++)
  {
    if( dataset.at(i) == datasetname )
    {
      iset=i;
      break;
    }
  }

  if(iset==-100)
  {
    std::cout << "No such a datasetname." << std::endl;
    return 1;
  }

  if(iset>=0)
  {
    if (variablename == "crossSection") std::cout << crossSection.at(iset);
    else if (variablename=="higgsMass") std::cout << higgsMass.at(iset);
    else if (variablename=="filterEff") std::cout << filterEff.at(iset);
    else if (variablename=="nEvents") std::cout << nEv.at(iset);
    else
    {
      std::cout << "No such a variable." << std::endl;
      return 1;
    }

  }

  return 0;

}
