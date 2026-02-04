
#DEBIAN_FRONTEND=noninteractive apt install -y doxygen graphviz
mkdir -p doxygen

# Build FilterWheel processor docs
mkdir -p doxygen/Filterwheel/processor
ls doxygen
cd Filterwheel/processor/dox
doxygen

# Build FilterWheel fpga docs
mkdir -p doxygen/FilterwheelTq144/fpga
ls doxygen    
cd FilterwheelTq144/fpga/dox
doxygen 

# Build FineSteeringMirror processor docs
mkdir -p doxygen/FineSteeringMirrorController/processor
ls doxygen    
cd FineSteeringMirrorController/processor/dox
doxygen
    
# Build FineSteeringMirror fpga docs
mkdir -p doxygen/FineSteeringMirrorController/fpga
ls doxygen    
cd FineSteeringMirrorController/fpga/dox
doxygen
    
# Build main page
cd dox
doxygen