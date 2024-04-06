################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../CMSIS/startup_gcc/newlib_stubs.c 

S_UPPER_SRCS += \
../CMSIS/startup_gcc/startup_m2sxxx.S 

OBJS += \
./CMSIS/startup_gcc/newlib_stubs.o \
./CMSIS/startup_gcc/startup_m2sxxx.o 

S_UPPER_DEPS += \
./CMSIS/startup_gcc/startup_m2sxxx.d 

C_DEPS += \
./CMSIS/startup_gcc/newlib_stubs.d 


# Each subdirectory must supply rules for building sources it contributes
CMSIS/startup_gcc/%.o: ../CMSIS/startup_gcc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\CMSIS" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\drivers\mss_nvm" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\drivers\mss_gpio" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\hal\CortexM3\GNU" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\hal\CortexM3" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\hal" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\drivers\CoreUARTapb" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\drivers" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\Ux2FPGA\drivers_config\sys_config" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

CMSIS/startup_gcc/%.o: ../CMSIS/startup_gcc/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross Assembler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -x assembler-with-cpp -I"C:\MicroSemiProj\DMCI_Ux2\firmware\hal\CortexM3\GNU" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


