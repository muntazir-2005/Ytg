#import "PatchNonJB.h"

%ctor {
    // المسار الصحيح للثنائي داخل الإطار
    const char *binary = "Frameworks/anogs.framework/anogs";

    // === تحضير الأوفستات (مرة واحدة) ===
    // نستخدم العناوين الكاملة = الإزاحة + 0x100000000
    InitOffsetForPatchHook(binary, 0x1000177C4, "1F2003D5");
    InitOffsetForPatchHook(binary, 0x10001F568, "1F2003D5");
    InitOffsetForPatchHook(binary, 0x100032C94, "1F2003D5");
    InitOffsetForPatchHook(binary, 0x1000376A4, "1F2003D5");
    InitOffsetForPatchHook(binary, 0x10004C9AC, "1F2003D5");
    InitOffsetForPatchHook(binary, 0x10004A130, "1F2003D5");

    // === تفعيل التعديلات ===
    PatchOffset(binary, 0x1000177C4, "1F2003D5", true);
    PatchOffset(binary, 0x10001F568, "1F2003D5", true);
    PatchOffset(binary, 0x100032C94, "1F2003D5", true);
    PatchOffset(binary, 0x1000376A4, "1F2003D5", true);
    PatchOffset(binary, 0x10004C9AC, "1F2003D5", true);
    PatchOffset(binary, 0x10004A130, "1F2003D5", true);
}
