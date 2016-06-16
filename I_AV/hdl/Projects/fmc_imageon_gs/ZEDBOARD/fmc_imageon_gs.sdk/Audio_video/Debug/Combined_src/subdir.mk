################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../Combined_src/lscript.ld 

C_SRCS += \
../Combined_src/Combined_app.c \
../Combined_src/platform.c 

OBJS += \
./Combined_src/Combined_app.o \
./Combined_src/platform.o 

C_DEPS += \
./Combined_src/Combined_app.d \
./Combined_src/platform.d 


# Each subdirectory must supply rules for building sources it contributes
Combined_src/%.o: ../Combined_src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../fmc_imageon_gs_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


