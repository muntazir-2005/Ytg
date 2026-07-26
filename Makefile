# Makefile - Final Non-JB Build
# بناء dylib نظيف تماماً للحقن، بدون توقيعات وهمية

TARGET := iphone:clang:latest:15.0
ARCHS := arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

# جلب كافة الملفات البرمجية واستبعاد dobby_real.mm
ALL_SRC_FILES := $(wildcard *.xm *.mm *.m *.cpp) $(wildcard ESP/*.xm ESP/*.mm ESP/*.m ESP/*.cpp)
MyTweak_FILES := $(filter-out dobby_real.mm, $(ALL_SRC_FILES))

# أعلام الترجمة
MyTweak_CFLAGS := -I. -IESP \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format

# ربط المكتبات وإصلاح تحذيرات Xcode 15 (ld_classic)
MyTweak_LDFLAGS := -L. -ldobby -Wl,-segalign,4000 -Wl,-ld_classic
MyTweak_FRAMEWORKS := Foundation UIKit

# مسار التثبيت الافتراضي للـ Non-JB
MyTweak_INSTALL_PATH := @executable_path

# تم إزالة كود التوقيع الوهمي (entitlements) عمداً لكي لا يتعارض مع الشهادة المدفوعة

include $(THEOS_MAKE_PATH)/tweak.mk

# نسخ المخرجات الجاهزة
after-build::
	@echo "==> جاري تحضير ملف dylib النظيف..."
	@mkdir -p output
	@cp $(THEOS_OBJ_DIR)/MyTweak.dylib output/
	@echo "==> تم البناء بنجاح! الملف جاهز للحقن والتوقيع بالشهادة المدفوعة."
