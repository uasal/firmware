################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../format/test/performance.c \
../format/test/testharness.c 

OBJS += \
./format/test/performance.o \
./format/test/testharness.o 

C_DEPS += \
./format/test/performance.d \
./format/test/testharness.d 


# Each subdirectory must supply rules for building sources it contributes
format/test/%.o: ../format/test/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers_config\sys_config" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_gpio" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\uart" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_nvm" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreSPI" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CorePWM" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreUARTapb" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\CMSIS" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3\GNU" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\format\src" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\format" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


