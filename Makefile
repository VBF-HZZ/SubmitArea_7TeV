CXX=g++
CC=gcc
CFLAGS=-O2 -Wall
LDFLAGS=-Llib
PRFFLAGS=-lProof
THRDFLAGS=-lThread

OBJ1=getXSec.o

.PHONY: clean all main test

all: getXSec.exe

getXSec.exe: getXSec.o
	$(CXX) -o getXSec.exe $(OBJ1) 

clean:
	@rm *.o *.exe 

##############RULES##############                                                                                                                                                                           
.cc.o:
	$(CXX) $(CFLAGS) -c $<
.cpp.o:
	$(CXX) $(CFLAGS) -c $<
