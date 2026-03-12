#!/bin/bash

ARCH="-gencode arch=compute_75,code=sm_75"
STD="-std=c++14"
CXXFLAGS="-O3 $STD"
NVFLAGS="-O3 $STD $ARCH --allow-unsupported-compiler -ccbin g++-10"

mkdir -p Release

# host compilation
g++ $CXXFLAGS -c src/main.cpp -o src/main.o
g++ $CXXFLAGS -c src/Interface/KDevice.cpp -o src/Interface/KDevice.o
g++ $CXXFLAGS -c src/Interface/KHost.cpp -o src/Interface/KHost.o
g++ $CXXFLAGS -c src/Input/KSimulationData.cpp -o src/Input/KSimulationData.o

# device compilation (with older GCC)
nvcc $NVFLAGS -c src/Device/DeviceInterface.cu -o src/Device/DeviceInterface.o

# linking
nvcc --cudart static -o Release/V_02_2015 \
    src/main.o \
    src/Interface/KDevice.o \
    src/Interface/KHost.o \
    src/Input/KSimulationData.o \
    src/Device/DeviceInterface.o \
    -lGL -lGLU -lglut
