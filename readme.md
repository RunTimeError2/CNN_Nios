# CNN_Nios

- This project provides an example of building an small-scale CNN on FPGA SOPC (Nios applied here).

> Build at summer of 2018

## Projects

### First_Nios

This directory contains the project for FPGA (DE2-115) using Quartus II 15.0, 
and an additional 4.3 inch 800*480 LCD Touch Panel is supported in this project.

### MNIST_withTF

This directory contains the Python project to train the target CNN with MNIST dataset.

The scale of this CNN is adaped so that it can run on Nios, where RAM space is limited.

This program is a rather simple example of CNN, which can be found in tutorials of TensorFlow.

### CNN_MNIST

This directory contains a Cpp project (built with Visual Studio 2017) 
which builds the same CNN as the one provided in the Python project.

It adapts the existing parameters created by the Python project, so it lacks the function to train the CNN.
