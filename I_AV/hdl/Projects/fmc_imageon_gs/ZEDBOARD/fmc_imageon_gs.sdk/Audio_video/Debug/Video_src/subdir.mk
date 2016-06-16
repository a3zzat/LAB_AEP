################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Video_src/avnet_console.c \
../Video_src/avnet_console_scanput.c \
../Video_src/avnet_console_serial.c \
../Video_src/avnet_console_tokenize.c \
../Video_src/demo.c \
../Video_src/edid_fmc_imageon.c \
../Video_src/main.c \
../Video_src/sleep.c \
../Video_src/xaxivdma_ext.c 

OBJS += \
./Video_src/avnet_console.o \
./Video_src/avnet_console_scanput.o \
./Video_src/avnet_console_serial.o \
./Video_src/avnet_console_tokenize.o \
./Video_src/demo.o \
./Video_src/edid_fmc_imageon.o \
./Video_src/main.o \
./Video_src/sleep.o \
./Video_src/xaxivdma_ext.o 

C_DEPS += \
./Video_src/avnet_console.d \
./Video_src/avnet_console_scanput.d \
./Video_src/avnet_console_serial.d \
./Video_src/avnet_console_tokenize.d \
./Video_src/demo.d \
./Video_src/edid_fmc_imageon.d \
./Video_src/main.d \
./Video_src/sleep.d \
./Video_src/xaxivdma_ext.d 


# Each subdirectory must supply rules for building sources it contributes
Video_src/%.o: ../Video_src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../fmc_imageon_gs_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


