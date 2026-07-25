# Makefile for Non-Jailbreak Tweak (dylib only)
# يعتمد على Theos لكن لا يثبت أي شيء في النظام

TARGET := iphone:clang:latest:15.0
ARCHS := arm64 
TARGET_CODESIGN := -
THEOS_PACKAGE_SCHEME := rootless

# لا نريد إنتاج حزمة .deb، فقط dylib
_NO_DEB = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

# ملفات المصدر
MyTweak_FILES := Tweak.xm PatchNonJB.mm

# أعلام المترجم
MyTweak_CFLAGS := -I. \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format

# ربط المكتبات: libdobby.a (الموجودة في الجذر) و libc++
MyTweak_LDFLAGS := -L. -ldobby -lc++ -Wl,-segalign,4000

# الأطر المطلوبة
MyTweak_FRAMEWORKS := Foundation

# مسار التثبيت الافتراضي (لن يُستخدم لأننا لن ننتج deb)
MyTweak_INSTALL_PATH := /var/jb/Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk

# هدف إضافي: استخراج dylib فقط (اختياري)
after-build::
	@echo "==> تم بناء التعديل بنجاح (Non-JB)."
	@echo "==> الملف الجاهز للحقن: .theos/obj/MyTweak.dylib"
	@mkdir -p output
	cp .theos/obj/MyTweak.dylib output/
	@echo "==> تم نسخ dylib إلى مجلد output/"
