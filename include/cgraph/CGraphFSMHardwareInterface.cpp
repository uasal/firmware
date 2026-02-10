//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include "CGraphFSMHardwareInterface.hpp"

CGraphFSMHardwareInterface* volatile FSM = (CGraphFSMHardwareInterface*)0x50000000UL;
//CGraphFSMHardwareInterface* FSM = (CGraphFSMHardwareInterface*)0x30000000UL;

//While we're struggling with gcc trying to read 32b values as 3 unaligned bytes (and one aligned one) and crash the processor, this is our workaround:
void CGraphFSMHardwareInterface::InititateLatchAdcs() { *((uint8_t*)&(FSM->LatchAdcs)) = 1;	}

//EOF
