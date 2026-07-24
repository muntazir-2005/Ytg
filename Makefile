# Makefile لبناء tweak.dylib بدون جلبريك
# يفترض وجود libdobby.a في جذر المشروع

TARGET_DYLIB  := MyTweak.dylib
ARCHS         := arm64 arm64e
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

SRC_DIR       := .
INCLUDE_DIR   := .
LIB_DIR       := .                   # <--- نفس المجلد الجذر

SOURCES       := Tweak.xm PatchNonJB.mm
OBJECTS       := $(patsubst %.xm,%.o,$(patsubst %.mm,%.o,$(SOURCES)))

CFLAGS        := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib -install_name @executable_path/Frameworks/$(TARGET_DYLIB)
CFLAGS        += -F$(SDK_PATH)/System/Library/Frameworks -framework Foundation
CFLAGS        += -I$(INCLUDE_DIR)
CFLAGS        += -Wno-incomplete-implementation -Wno-deprecated-declarations -Wno-unused-function

LDFLAGS       := -L$(LIB_DIR) -ldobby -Wl,-segalign,4000

.PHONY: all clean

all: $(TARGET_DYLIB)

$(TARGET_DYLIB): $(OBJECTS) | dobby_check
	$(CLANG) -arch arm64 -isysroot $(SDK_PATH) -dynamiclib $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "==> توقيع $@..."
	$(LDID) -S $@
	@echo "==> تم البناء بنجاح: $@"

%.o: %.xm
	$(CLANG) $(CFLAGS) -c $< -o $@

%.o: %.mm
	$(CLANG) $(CFLAGS) -c $< -o $@

dobby_check:
	@if [ ! -f libdobby.a ]; then \
		echo "خطأ: libdobby.a غير موجود في جذر المشروع"; \
		exit 1; \
	fi

clean:
	rm -f $(OBJECTS) $(TARGET_DYLIB)
