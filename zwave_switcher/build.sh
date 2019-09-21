#!/bin/bash
arm-linux-gnueabihf-g++ -Wall -I ./openzwave-1.3/cpp/src -o switch_todo -pthread ./openzwave-1.3/libopenzwave.so Main.cpp
