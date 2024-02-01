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
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers_config\sys_config" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\mss_gpio" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\uart" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\mss_nvm" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CoreSPI" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CorePWM" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CoreUARTapb" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\CMSIS" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal\CortexM3\GNU" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal\CortexM3" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

CMSIS/startup_gcc/%.o: ../CMSIS/startup_gcc/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross Assembler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -x assembler-with-cpp -I"C:\MicroSemiProj\EvalBoardSandbox\firmware\hal\CortexM3\GNU" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


