# Makefile النهائي لمشروع Non-JB Tweak
# يعتمد على Theos، يبني arm64 فقط، ويربط مع libdobby.a المعدلة

TARGET := iphone:clang:latest:15.0
ARCHS := arm64
TARGET_CODESIGN := ldid
THEOS_PACKAGE_SCHEME := rootless

# لا ننتج حزمة deb، فقط dylib (سيتم نسخها يدويًا في after-build)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

# ملفات المصدر (أضف أي ملفات إضافية هنا)
MyTweak_FILES := Tweak.xm PatchNonJB.mm

# أعلام المترجم
MyTweak_CFLAGS := -I. \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format

# ربط المكتبات: libdobby.a (الموجودة في الجذر) + libc++
MyTweak_LDFLAGS := -L. -ldobby -lc++ -Wl,-segalign,4000

# الأطر المطلوبة
MyTweak_FRAMEWORKS := Foundation

# مسار التثبيت (لن يُستخدم فعليًا في non-jb، لكن Theos يحتاجه)
MyTweak_INSTALL_PATH := /var/jb/Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk

# نسخ الملف الناتج إلى مجلد output/ بعد البناء
after-build::
	@echo "==> تم بناء التعديل بنجاح (Non-JB)."
	@echo "==> الملف الجاهز للحقن: .theos/obj/MyTweak.dylib"
	@mkdir -p output
	cp .theos/obj/MyTweak.dylib output/
	@echo "==> تم نسخ dylib إلى مجلد output/"
