#ifndef PATCHNONJB_H
#define PATCHNONJB_H

#import <Foundation/Foundation.h>
#include <stdint.h>
#include <stdbool.h>

// =============================================
// تعريف الهيكل والدوال الخاصة بـ PatchNonJB
// (موجودة في libdobby.a)
// =============================================

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  uint64_t hook_vaddr;
  uint64_t hook_size;
  uint64_t code_vaddr;
  uint64_t code_size;
  uint64_t patched_vaddr;
  uint64_t original_vaddr;
  uint64_t instrument_vaddr;
  uint64_t patch_size;
  uint64_t patch_hash;
  void *target_replace;
  void *instrument_handler;
} StaticInlineHookBlock;

int dobby_create_instrument_bridge(void *targetData);

bool dobby_static_inline_hook(StaticInlineHookBlock *hookBlock,
                              StaticInlineHookBlock *hookBlockRVA,
                              uint64_t funcRVA,
                              void *funcData,
                              uint64_t targetRVA,
                              void *targetData,
                              uint64_t InstrumentBridgeRVA,
                              void *patchBytes,
                              int patchSize);

#ifdef __cplusplus
}
#endif

// =============================================
// دوال الواجهة العامة التي يستخدمها Tweak.mm
// =============================================

NSString* InitOffsetForPatchHook(const char* machoPath, uint64_t vaddr, const char* patch);
BOOL PatchOffset(const char* machoPath, uint64_t vaddr, const char* patch, bool isOn);
void* HookOffset(const char* machoPath, uint64_t vaddr, void* replace);

#endif // PATCHNONJB_H
