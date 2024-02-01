################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../drivers_config/sys_config/sys_config.c 

OBJS += \
./drivers_config/sys_config/sys_config.o 

C_DEPS += \
./drivers_config/sys_config/sys_config.d 


# Each subdirectory must supply rules for building sources it contributes
drivers_config/sys_config/%.o: ../drivers_config/sys_config/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers_config\sys_config" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\mss_gpio" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\uart" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\mss_nvm" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CoreSPI" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CorePWM" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\drivers\CoreUARTapb" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\CMSIS" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal\CortexM3\GNU" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal\CortexM3" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole" -I"C:\Users\SKaye\repos\firmware\DMInterface\SoftConsole\hal" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


