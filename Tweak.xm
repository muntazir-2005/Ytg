#import "PatchNonJB.h"

%ctor {
    const char *binary = "Frameworks/anogs.framework/anogs";

    uint64_t offsets[] = {
        0x1000177C4, 0x10001F568, 0x100032C94,
        0x1000376A4, 0x10004C9AC, 0x10004A130
    };

    for (int i = 0; i < sizeof(offsets) / sizeof(offsets[0]); i++) {
        InitOffsetForPatchHook(binary, offsets[i], "1F2003D5");
        PatchOffset(binary, offsets[i], "1F2003D5", true);
    }
}
