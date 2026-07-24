# Makefile لبناء Tweak.dylib بدون جلبريك (Non-Jailbreak)
# يفترض وجود: Tweak.mm, PatchNonJB.mm, PatchNonJB.h, ESP/mahoa.h, libdobby.a

TARGET_DYLIB  := MyTweak.dylib
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

# أعلام المترجم (تستخدم عند تحويل .mm إلى .o)
CXXFLAGS      := -arch arm64 -isysroot $(SDK_PATH) -I. \
                 -Wno-incomplete-implementation -Wno-deprecated-declarations \
                 -Wno-unused-function -Wno-unused-variable -Wno-format

# أعلام الرابط (تستخدم عند إنتاج الملف النهائي)
LDFLAGS       := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib \
                 -install_name @executable_path/Frameworks/$(TARGET_DYLIB) \
                 -framework Foundation -L. -ldobby -lc++ -Wl,-segalign,4000

# الملفات المصدرية (Objective-C++)
SOURCES       := Tweak.mm PatchNonJB.mm
OBJECTS       := $(SOURCES:.mm=.o)

# الهدف الأساسي
.PHONY: all clean

all: $(TARGET_DYLIB)

# ربط الملفات لإنتاج dylib
$(TARGET_DYLIB): $(OBJECTS) | dobby_check
	$(CLANG) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "==> توقيع $@ باستخدام ldid..."
	$(LDID) -S $@
	@echo "==> تم البناء بنجاح: $@"

# تحويل أي ملف .mm إلى .o
%.o: %.mm
	$(CLANG) $(CXXFLAGS) -c $< -o $@

# التحقق من وجود libdobby.a
dobby_check:
	@if [ ! -f libdobby.a ]; then \
		echo "خطأ: ملف libdobby.a غير موجود في جذر المشروع"; \
		exit 1; \
	fi

# تنظيف المخرجات
clean:
	rm -f $(OBJECTS) $(TARGET_DYLIB)
