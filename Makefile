# Makefile لبناء tweak.dylib بدون جلبريك (Non-Jailbreak)
# يستخدم clang مباشرة مع ربط dobby

# ---------- الإعدادات ----------
TARGET_DYLIB  := MyTweak.dylib
ARCHS         := arm64 arm64e   # يمكنك حذف arm64e إذا لم تكن تريده
SDK_PATH      := $(shell xcrun --sdk iphoneos --show-sdk-path)
CLANG         := $(shell xcrun --sdk iphoneos --find clang)
LDID          := ldid

# مجلدات المصادر والمكتبات
SRC_DIR       := .
INCLUDE_DIR   := include
LIB_DIR       := libs

# ملفات المصدر (Logos .xm يُمرر مباشرة لـ clang)
SOURCES       := Tweak.xm PatchNonJB.mm
OBJECTS       := $(patsubst %.xm,%.o,$(patsubst %.mm,%.o,$(SOURCES)))

# أعلام التجميع
CFLAGS        := -arch arm64 -isysroot $(SDK_PATH) -dynamiclib -install_name @executable_path/Frameworks/$(TARGET_DYLIB)
CFLAGS        += -F$(SDK_PATH)/System/Library/Frameworks -framework Foundation
CFLAGS        += -I$(INCLUDE_DIR) -I.
CFLAGS        += -Wno-incomplete-implementation -Wno-deprecated-declarations -Wno-unused-function

# أعلام الربط
LDFLAGS       := -L$(LIB_DIR) -ldobby -Wl,-segalign,4000

# ---------- الأهداف ----------
.PHONY: all clean

all: $(TARGET_DYLIB)

$(TARGET_DYLIB): $(OBJECTS) | libdobby_check
	$(CLANG) -arch arm64 -isysroot $(SDK_PATH) -dynamiclib $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "==> توقيع $@ باستخدام ldid..."
	$(LDID) -S $@
	@echo "==> تم البناء بنجاح: $@"

# تحويل Logos .xm إلى .o عن طريق تمريره مباشرة (يدعم clang صيغة Logos)
%.o: %.xm
	$(CLANG) $(CFLAGS) -c $< -o $@

%.o: %.mm
	$(CLANG) $(CFLAGS) -c $< -o $@

# التحقق من وجود libdobby.a (اختياري)
libdobby_check:
	@if [ ! -f $(LIB_DIR)/libdobby.a ]; then \
		echo "خطأ: لم يتم العثور على libdobby.a في مجلد $(LIB_DIR)"; \
		echo "يرجى وضع مكتبة dobby الثابتة في $(LIB_DIR)/libdobby.a"; \
		exit 1; \
	fi

clean:
	rm -f $(OBJECTS) $(TARGET_DYLIB)
