//
///           University of Arizona
///           Steward Observatory
///           UASAL - UA Space Astrophysics Labratory
///           CAAO - Center for Astronomical Adaptive Optics
///           MagAOX
//

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif
  
//This technically is a "BZIP2CRC32", not an "ANSICRC32"; seealso: https://crccalc.com/
//Also it should be moved to a CRC32BZIP2.cpp file or somesuch instead of cluttering up main...
uint32_t CRC32BZIP2(const uint8_t* data, const size_t length);

#ifdef __cplusplus
};
#endif

//EOF
