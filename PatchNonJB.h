#import <Foundation/Foundation.h>

// ... باقي محتوى PatchNonJB.h ...
#include "dobby.h"
//#import "../Utils/MethodObfuscation.h"

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

bool dobby_static_inline_hook(StaticInlineHookBlock *hookBlock, StaticInlineHookBlock *hookBlockRVA, uint64_t funcRVA,
                              void *funcData, uint64_t targetRVA, void *targetData, uint64_t InstrumentBridgeRVA,
                              void *patchBytes, int patchSize);

NSString* InitOffsetForPatchHook(const char* machoPath, uint64_t vaddr, const char* patch);

BOOL PatchOffset(const char* machoPath, uint64_t vaddr, const char* patch, bool isOn);

void* HookOffset(const char* machoPath, uint64_t vaddr, void* replace);


