TARGET := iphone:clang:latest:15.0
ARCHS := arm64
TARGET_CODESIGN := ldid
THEOS_PACKAGE_SCHEME := rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := MyTweak

MyTweak_FILES := Tweak.xm PatchNonJB.mm
MyTweak_CFLAGS := -I. \
	-Wno-incomplete-implementation -Wno-deprecated-declarations \
	-Wno-unused-function -Wno-unused-variable -Wno-format
MyTweak_LDFLAGS := -L. -ldobby -lc++ -Wl,-segalign,4000
MyTweak_FRAMEWORKS := Foundation
MyTweak_INSTALL_PATH := /var/jb/Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk

after-build::
	@echo "==> تم بناء التعديل بنجاح (Non-JB)."
	@echo "==> الملف الجاهز للحقن: .theos/obj/MyTweak.dylib"
	@mkdir -p output
	cp .theos/obj/MyTweak.dylib output/
	@echo "==> تم نسخ dylib إلى مجلد output/"
