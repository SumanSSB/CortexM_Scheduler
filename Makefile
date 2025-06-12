PROJECT = boot
CPU ?= cortex-m3
BOARD ?= stm32vldiscovery

qemu:
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -ggdb -c boot.S -o boot.o
	arm-none-eabi-ld -Tmap.ld boot.o -o boot.elf
	arm-none-eabi-objdump -D -S boot.elf > boot.elf.lst
	arm-none-eabi-readelf -a boot.elf > boot.elf.debug
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234

gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234"

clean:
	rm -rf *.out *.elf *.gdb_history *.lst *.debug *.o