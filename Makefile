# Makefile لبناء MyTweak.dylib (Non-Jailbreak) باستخدام libdobby.a الحقيقية
# المتطلبات: Tweak.mm, PatchNonJB.mm, libdobby.a, dobby.h, ESP/mahoa.h

TARGET_DYLIB  := MyTweak.dylib
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

# أعلام التجميع فقط (C++ / Objective-C++)
CXXFLAGS      := -arch arm64 -isysroot $(SDK_PATH) -I. \
                 -Wno-incomplete-implementation -Wno-deprecated-declarations \
                 -Wno-unused-function -Wno-unused-variable -Wno-format

# أعلام الرابط للمكتبة الديناميكية
LDFLAGS       := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib \
                 -install_name @executable_path/Frameworks/$(TARGET_DYLIB) \
                 -framework Foundation -L. -ldobby -lc++ -Wl,-segalign,4000

# ملفات المصدر
SOURCES       := Tweak.mm PatchNonJB.mm
OBJECTS       := $(SOURCES:.mm=.o)

# الأهداف
.PHONY: all clean

all: $(TARGET_DYLIB)

$(TARGET_DYLIB): $(OBJECTS)
	$(CLANG) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "==> توقيع $@..."
	$(LDID) -S $@
	@echo "==> تم البناء بنجاح: $@"

%.o: %.mm
	$(CLANG) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET_DYLIB)
