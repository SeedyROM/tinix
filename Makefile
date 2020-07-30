BUILD_OUTPUT=build

bootloader: boot/bootloader.asm boot/utils.asm
	mkdir -p $(BUILD_OUTPUT)/boot
	nasm -fbin boot/bootloader.asm -o $(BUILD_OUTPUT)/boot/bootloader.bin

emulate: $(BUILD_OUTPUT)/boot/bootloader.bin
	qemu-system-x86_64 $(BUILD_OUTPUT)/boot/bootloader.bin