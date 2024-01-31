################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../CmdHandlersBinary.cpp \
../CmdTableBinary.cpp \
../DelayLinux.cpp \
../main.cpp 

OBJS += \
./CmdHandlersBinary.o \
./CmdTableBinary.o \
./DelayLinux.o \
./main.o 

CPP_DEPS += \
./CmdHandlersBinary.d \
./CmdTableBinary.d \
./DelayLinux.d \
./main.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C++ Compiler'
	arm-none-eabi-g++ -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers_config\sys_config" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_gpio" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\uart" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\mss_nvm" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreSPI" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CorePWM" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\drivers\CoreUARTapb" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\CMSIS" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3\GNU" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal\CortexM3" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox" -I"C:\Projects\Coronagraph\MicrosemiSmartFusion\Microchip_University_SF2_class\SC_WS\EvalBoardSandbox\hal" -std=gnu++11 -fabi-version=0 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


