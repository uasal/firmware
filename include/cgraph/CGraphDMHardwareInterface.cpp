//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//


#include "CGraphDMHardwareInterface.hpp"
CGraphDMHardwareInterface* DM = (CGraphDMHardwareInterface*)0x50000000UL; // Address of first Amba bus
CGraphDMRamInterface* dRAM = (CGraphDMRamInterface*)0x50001000UL; // Address of second Amba bus

//EOF
