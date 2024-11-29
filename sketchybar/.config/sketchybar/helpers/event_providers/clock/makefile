# bin/clock: clock.c ../sketchybar.h | bin
# 	clang -std=c99 -O3 $< -o $@
# bin:
# 	mkdir bin



# Get architecture
ARCH := $(shell uname -m)

# Get suffix
ifeq ($(ARCH),arm64)
SUFFIX := arm
else
SUFFIX := x86
endif

# Target and Source
TARGET := bin/clock_$(SUFFIX)
SRC := clock.c
HEADER := ../sketchybar.h

# Compile
all: $(TARGET)

$(TARGET): $(SRC) $(HEADER) | bin
	clang -std=c99 -O3 $< -o $@

bin:
	mkdir -p bin

clean:
	rm -rf bin
