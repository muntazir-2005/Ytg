#ifndef PATCHNONJB_H
#define PATCHNONJB_H

#import <Foundation/Foundation.h>
#include "dobby.h"   // يوفر StaticInlineHookBlock والدوال الأساسية

// =============================================
// دوال الواجهة العامة التي يستخدمها Tweak.mm
// =============================================

// يُجهز ملف Mach-O للمرة الأولى ويحفظ نسخة معدلة (مرة واحدة لكل أوفست)
NSString* InitOffsetForPatchHook(const char* machoPath, uint64_t vaddr, const char* patch);

// يُفعّل/يُعطّل تعديل البايتات في الذاكرة (isOn = true للتفعيل)
BOOL PatchOffset(const char* machoPath, uint64_t vaddr, const char* patch, bool isOn);

// يستبدل الدالة الأصلية بـ replace (للهوك الكامل)
// يُرجع عنوان الدالة الأصلية للحفظ
void* HookOffset(const char* machoPath, uint64_t vaddr, void* replace);

#endif // PATCHNONJB_H
