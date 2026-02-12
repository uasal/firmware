
#!/bin/bash

#DEBIAN_FRONTEND=noninteractive apt install -y doxygen graphviz
mkdir -p doxygen

# TODO: This can be done better / automatically but keeping as is for now
# (Exisiting code / quicker)

# Build FilterWheel processor docs
mkdir -p doxygen/Filterwheel/processor
ls doxygen
cd Filterwheel/processor/dox
doxygen

cd $OLDPWD

# Build FilterWheel fpga docs
mkdir -p doxygen/FilterwheelTq144/fpga
ls doxygen
cd FilterwheelTq144/fpga/dox
doxygen

cd $OLDPWD

# Build FineSteeringMirror processor docs
mkdir -p doxygen/FineSteeringMirrorController/processor
ls doxygen
cd FineSteeringMirrorController/processor/dox
doxygen

cd $OLDPWD

# Build FineSteeringMirror fpga docs
mkdir -p doxygen/FineSteeringMirrorController/fpga
ls doxygen
cd FineSteeringMirrorController/fpga/dox
doxygen

cd $OLDPWD

# Build main page
cd dox
doxygen

cd $OLDPWD
