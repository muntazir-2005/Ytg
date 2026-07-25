#import "PatchNonJB.h"

%ctor {
    const char *binary = "Frameworks/anogs.framework/anogs";

    // الإزاحات الجديدة (مؤكدة 100%)
    uint64_t offsets[] = {
        0x00185A9C,
        0x0001F568,
        0x0004A130,
        0x00180B1C,
        0x000177C4,
        0x00182908
    };

    // ARM64 RET: C0 03 5F D6 (little-endian)
    const char *retPatch = "C0035FD6";

    for (int i = 0; i < sizeof(offsets) / sizeof(offsets[0]); i++) {
        // حساب العنوان الافتراضي الكامل (الأساس الافتراضي = 0x100000000)
        uint64_t fullAddr = 0x100000000 + offsets[i];
        
        // تجهيز الملف المعدّل وحفظه (مرة واحدة)
        InitOffsetForPatchHook(binary, fullAddr, retPatch);
        
        // تفعيل التعديل في الذاكرة
        PatchOffset(binary, fullAddr, retPatch, true);
    }
}
