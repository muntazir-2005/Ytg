# Makefile - Theos (Non‑JB)
# بناء dylib ديناميكي مع التقاط كافة الملفات واستبعاد ما لا يلزم

TARGET := iphone:clang:latest:15.0
ARCHS := arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

# 1. التقاط كافة الملفات البرمجية في المجلد الرئيسي ومجلد ESP
ALL_SRC_FILES := $(wildcard *.xm *.mm *.m *.cpp) $(wildcard ESP/*.xm ESP/*.mm ESP/*.m ESP/*.cpp)

# 2. تصفية القائمة واستبعاد ملف dobby_real.mm منها
MyTweak_FILES := $(filter-out dobby_real.mm, $(ALL_SRC_FILES))

# 3. أعلام الترجمة (تتضمن المجلد الرئيسي ومجلد ESP لقراءة ملفات الـ Headers)
MyTweak_CFLAGS := -I. -IESP \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format

# 4. ربط مكتبة Dobby الثابتة (libdobby.a) وإعدادات التوافق
MyTweak_LDFLAGS := -L. -ldobby -lc++ -Wl,-segalign,4000
MyTweak_FRAMEWORKS := Foundation UIKit

# 5. التوقيع التلقائي بملف الصلاحيات
MyTweak_CODESIGN_FLAGS := -Sentitlements.plist
MyTweak_INSTALL_PATH := @executable_path

include $(THEOS_MAKE_PATH)/tweak.mk

# 6. بعد البناء: نسخ dylib الجاهز إلى مجلد output/
after-build::
	@echo "==> جاري نسخ الملف النهائي إلى output/"
	@mkdir -p output
	@cp $(THEOS_OBJ_DIR)/MyTweak.dylib output/
	@echo "==> تم البناء والتوقيع بنجاح!"
