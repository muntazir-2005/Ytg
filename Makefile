TARGET_DYLIB  := MyTweak.dylib
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

CXXFLAGS      := -arch arm64 -isysroot $(SDK_PATH) -I. \
                 -Wno-incomplete-implementation -Wno-deprecated-declarations \
                 -Wno-unused-function -Wno-unused-variable -Wno-format

LDFLAGS       := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib \
                 -install_name @executable_path/Frameworks/$(TARGET_DYLIB) \
                 -framework Foundation -lc++ -Wl,-segalign,4000

# أضف dobby_real.c هنا
SOURCES       := Tweak.mm PatchNonJB.mm dobby_real.c
OBJECTS       := $(patsubst %.mm,%.o,$(patsubst %.c,%.o,$(SOURCES)))

.PHONY: all clean

all: $(TARGET_DYLIB)

$(TARGET_DYLIB): $(OBJECTS)
	$(CLANG) $(OBJECTS) -o $@ $(LDFLAGS)
	$(LDID) -S $@

%.o: %.mm
	$(CLANG) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CLANG) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET_DYLIB)
