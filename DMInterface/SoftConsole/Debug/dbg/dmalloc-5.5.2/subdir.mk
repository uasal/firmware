################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CC_SRCS += \
../dbg/dmalloc-5.5.2/dmallocc.cc 

C_SRCS += \
../dbg/dmalloc-5.5.2/arg_check.c \
../dbg/dmalloc-5.5.2/chunk.c \
../dbg/dmalloc-5.5.2/compat.c \
../dbg/dmalloc-5.5.2/dmalloc.c \
../dbg/dmalloc-5.5.2/dmalloc_argv.c \
../dbg/dmalloc-5.5.2/dmalloc_fc_t.c \
../dbg/dmalloc-5.5.2/dmalloc_rand.c \
../dbg/dmalloc-5.5.2/dmalloc_t.c \
../dbg/dmalloc-5.5.2/dmalloc_tab.c \
../dbg/dmalloc-5.5.2/env.c \
../dbg/dmalloc-5.5.2/error.c \
../dbg/dmalloc-5.5.2/heap.c \
../dbg/dmalloc-5.5.2/malloc.c 

CC_DEPS += \
./dbg/dmalloc-5.5.2/dmallocc.d 

OBJS += \
./dbg/dmalloc-5.5.2/arg_check.o \
./dbg/dmalloc-5.5.2/chunk.o \
./dbg/dmalloc-5.5.2/compat.o \
./dbg/dmalloc-5.5.2/dmalloc.o \
./dbg/dmalloc-5.5.2/dmalloc_argv.o \
./dbg/dmalloc-5.5.2/dmalloc_fc_t.o \
./dbg/dmalloc-5.5.2/dmalloc_rand.o \
./dbg/dmalloc-5.5.2/dmalloc_t.o \
./dbg/dmalloc-5.5.2/dmalloc_tab.o \
./dbg/dmalloc-5.5.2/dmallocc.o \
./dbg/dmalloc-5.5.2/env.o \
./dbg/dmalloc-5.5.2/error.o \
./dbg/dmalloc-5.5.2/heap.o \
./dbg/dmalloc-5.5.2/malloc.o 

C_DEPS += \
./dbg/dmalloc-5.5.2/arg_check.d \
./dbg/dmalloc-5.5.2/chunk.d \
./dbg/dmalloc-5.5.2/compat.d \
./dbg/dmalloc-5.5.2/dmalloc.d \
./dbg/dmalloc-5.5.2/dmalloc_argv.d \
./dbg/dmalloc-5.5.2/dmalloc_fc_t.d \
./dbg/dmalloc-5.5.2/dmalloc_rand.d \
./dbg/dmalloc-5.5.2/dmalloc_t.d \
./dbg/dmalloc-5.5.2/dmalloc_tab.d \
./dbg/dmalloc-5.5.2/env.d \
./dbg/dmalloc-5.5.2/error.d \
./dbg/dmalloc-5.5.2/heap.d \
./dbg/dmalloc-5.5.2/malloc.d 


# Each subdirectory must supply rules for building sources it contributes
dbg/dmalloc-5.5.2/%.o: ../dbg/dmalloc-5.5.2/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers_config\sys_config" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\uart" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_nvm" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreSPI" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CorePWM" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreUARTapb" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\CMSIS" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3\GNU" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\format" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

dbg/dmalloc-5.5.2/%.o: ../dbg/dmalloc-5.5.2/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C++ Compiler'
	arm-none-eabi-g++ -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\format" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\uart" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers_config\sys_config" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_nvm" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreSPI" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CorePWM" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreUARTapb" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\CMSIS" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3\GNU" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal" -std=gnu++11 -fabi-version=0 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


