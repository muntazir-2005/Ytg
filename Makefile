# Makefile - Theos من أجل Non‑JB
# ينتج dylib فقط للحقن في تطبيقات IPA

TARGET := iphone:clang:latest:15.0
ARCHS := arm64
# يُفضل دائماً وضعها 0 لإنتاج ملف بحجم أصغر وأكثر استقراراً
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

# ملفات المصدر
MyTweak_FILES := Tweak.xm PatchNonJB.mm

# أعلام الترجمة
MyTweak_CFLAGS := -I. \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format

# ربط المكتبات (تضمين Dobby ممتاز هنا للـ Non-JB)
MyTweak_LDFLAGS := -L. -ldobby -lc++ -Wl,-segalign,4000
MyTweak_FRAMEWORKS := Foundation

# إخبار Theos بتوقيع الأداة بالصلاحيات تلقائياً أثناء البناء
MyTweak_CODESIGN_FLAGS := -Sentitlements.plist

# مسار التثبيت (يفضل استخدام @executable_path لتطبيقات الـ Non-JB)
MyTweak_INSTALL_PATH := @executable_path

include $(THEOS_MAKE_PATH)/tweak.mk

# بعد البناء: نسخ dylib الجاهز والمُوقع إلى output/
after-build::
	@echo "==> نسخ الملف إلى output/"
	@mkdir -p output
	@cp $(THEOS_OBJ_DIR)/MyTweak.dylib output/
	@echo "==> تم بناء وتوقيع MyTweak.dylib (Non‑JB) بنجاح"
