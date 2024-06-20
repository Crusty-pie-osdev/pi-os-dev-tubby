CPPFILES = $(wildcard *.cpp io/*.cpp)
OBJS = $(CPPFILES:.cpp=.o)
GPPFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles
GCCPATH =  C:/msys64/mingw64/bin

all: clean kernel8.img

boot.o: boot.S
	$(GCCPATH)/arm-none-eabi-gcc.exe $(GCCFLAGS) -c boot.S -o=boot.o

%.o: %.cpp
	$(GCCPATH)/arm-none-eabi-g++.exe $(GCCFLAGS) -c $< -o $@

kernel8.img: boot.o $(OBJS)
	$(GCCPATH)/arm-none-eabi-g++.exe  -nostdlib boot.o $(OBJS) -T link.ld -o kernel8.elf
	$(GCCPATH)/arm-none-eabi-objcopy.exe -O binary kernel8.elf kernel8.img

clean:
	/bin/rm kernel8.elf *.o *.img > /dev/null 2> /dev/null || true




