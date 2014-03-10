#include <iostream>
#include <cmath>
#include <vector>
#include <fstream>
#include <string>

int main(int argc, char* argv[])
{

  using namespace std;

  string filename = "/cms/data/store/user/snowball/CrossSectionList.txt";

  if( argc != 2 ){ return 1; }

  ifstream in;

  in.open(filename.c_str());
  
  string givenDataset = argv[1];

  vector<string> dataset;
  vector<double> crossSection;
  vector<double> filterEff;
  vector<double> higgsMass;

  string tmpDataset;
  double tmpCrossSection;
  double tmpFilterEff;
  double mH;
  double nEvents;

  while( !in.eof() )
    {
      in >> tmpDataset >> tmpCrossSection >> tmpFilterEff >> mH >> nEvents;
      
      dataset.push_back(tmpDataset);
      crossSection.push_back(tmpCrossSection);
      filterEff.push_back(tmpFilterEff);
      higgsMass.push_back(mH);
    }


  for(unsigned int i = 0; i < dataset.size(); i++)
    {

      if( dataset[i] == givenDataset )
	{
	  cout << higgsMass[i];
	  return 0;
	}
    }

  return 0;

}
