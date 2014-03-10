CXX=g++
CC=gcc
CFLAGS=-O2 -Wall
LDFLAGS=-Llib
PRFFLAGS=-lProof
THRDFLAGS=-lThread

OBJ1=getHiggsMass.o
OBJ2=getFilterEff.o
OBJ3=getCrossSection.o
OBJ4=getNEvents.o

.PHONY: clean all main test

all: HiggsMass FilterEff CrossSect nEv

HiggsMass: getHiggsMass.o
	$(CXX) -o getHiggsMass.exe $(OBJ1) 

FilterEff: getFilterEff.o
	$(CXX) -o getFilterEff.exe $(OBJ2)

CrossSect: getCrossSection.o
	$(CXX) -o getCrossSection.exe $(OBJ3) 

nEv: getNEvents.o
	$(CXX) -o getNEvents.exe $(OBJ4)

clean:
	@rm *.o *.exe *~

##############RULES##############                                                                                                                                                                           
.cc.o:
	$(CXX) $(CFLAGS) -c $<
.cpp.o:
	$(CXX) $(CFLAGS) -c $<
