#
# A makefile used to generate our operating system image os-image.
#

#generate a list of all source *.c and *.h files
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

#use the *.c files to generate a list of object files that need to be built
OBJ = ${C_SOURCES:.c=.o}

#by default, simply build the os image
all: os-image

#build the os image by combining the bootsector and kernel
os-image: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > os-image

#build the kernel binary by linking all of our object files
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ} #note that kernel_entry.o is not found in OBJ
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

#use a generic rule to generate all *.o files (and make them depend on all *.h files)
%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -c $< -o $@ -Wall

#build kernel_entry.o using nasm
kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

#build boot_sec.bin using nasm
boot/boot_sect.bin: boot/boot_sect.asm
	nasm $< -f bin -o $@

#clear away all generated files
clear:
	rm -fr *.bin *.dis *.o *.map
	rm -fr boot/*.o boot/*.bin 
	rm -fr kernel/*.o kernel/*.bin
	rm -fr drivers/*.o

#disassemble the kernal (for debugging)
kernel/kernel.dis: kernel/kernel.bin
	ndisasm -b 32 kernel/kernel.bin > kernel/kernel.dis