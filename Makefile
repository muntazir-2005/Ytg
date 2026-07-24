TARGET_DYLIB  := MyTweak.dylib
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

# أعلام التجميع فقط
CXXFLAGS      := -arch arm64 -isysroot $(SDK_PATH) -I. \
                 -Wno-incomplete-implementation -Wno-deprecated-declarations -Wno-unused-function

# أعلام الربط فقط
LDFLAGS       := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib \
                 -install_name @executable_path/Frameworks/$(TARGET_DYLIB) \
                 -framework Foundation -L. -ldobby -Wl,-segalign,4000

SOURCES       := Tweak.xm PatchNonJB.mm
OBJS          := $(patsubst %.xm,%.o,$(patsubst %.mm,%.o,$(SOURCES)))

.PHONY: all clean

all: $(TARGET_DYLIB)

$(TARGET_DYLIB): $(OBJS) | dobby_check
	$(CLANG) $(OBJS) -o $@ $(LDFLAGS)
	@echo "==> توقيع $@..."
	$(LDID) -S $@
	@echo "==> تم البناء: $@"

%.o: %.xm
	$(CLANG) $(CXXFLAGS) -c $< -o $@

%.o: %.mm
	$(CLANG) $(CXXFLAGS) -c $< -o $@

dobby_check:
	@if [ ! -f libdobby.a ]; then \
		echo "خطأ: libdobby.a غير موجود في الجذر"; \
		exit 1; \
	fi

clean:
	rm -f $(OBJS) $(TARGET_DYLIB)
