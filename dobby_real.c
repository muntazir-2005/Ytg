// dobby_real.c
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <mach/mach.h>
#include <mach/vm_map.h>
#include <mach/vm_page_size.h>

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

// ARM64 NOP
static const uint32_t NOP = 0xD503201F;

// ذاكرة احتياطية لنسخ التعليمات الأصلية
static uint8_t trampoline_page[4096] __attribute__((aligned(4096)));

int dobby_create_instrument_bridge(void *targetData) {
    // لا نحتاج جسراً معقداً، فقط نجهز الصفحة
    memset(trampoline_page, 0, sizeof(trampoline_page));
    return 0;
}

bool dobby_static_inline_hook(StaticInlineHookBlock *hookBlock, StaticInlineHookBlock *hookBlockRVA,
                              uint64_t funcRVA, void *funcData, uint64_t targetRVA, void *targetData,
                              uint64_t InstrumentBridgeRVA, void *patchBytes, int patchSize) {
    if (!hookBlock || !hookBlockRVA || !funcData || !targetData) return false;

    mach_port_t task = mach_task_self();
    vm_address_t addr = (vm_address_t)funcData;
    vm_size_t size = patchSize ? patchSize : 4; // أقل حجم للتعديل

    // 1. حفظ التعليمات الأصلية في trampoline_page
    memcpy(trampoline_page, funcData, size);

    // 2. جعل الذاكرة قابلة للكتابة
    vm_protect(task, addr, size, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE);

    // 3. كتابة NOP أو البايتات الجديدة
    if (patchBytes) {
        memcpy((void*)addr, patchBytes, patchSize);
    } else {
        // مجرد NOP أول 4 بايت
        *(uint32_t*)addr = NOP;
    }

    // 4. إعادة الحماية الأصلية (قراءة/تنفيذ)
    vm_protect(task, addr, size, 0, VM_PROT_READ | VM_PROT_EXECUTE);

    // 5. تحديث معلومات الكتلة
    hookBlock->hook_vaddr = funcRVA;
    hookBlock->hook_size = size;
    hookBlock->code_vaddr = targetRVA;
    hookBlock->code_size = size;
    hookBlock->patched_vaddr = (uint64_t)funcData;
    hookBlock->original_vaddr = (uint64_t)trampoline_page;
    hookBlock->target_replace = NULL;
    hookBlock->instrument_vaddr = 0;
    hookBlock->patch_size = patchSize;
    hookBlock->patch_hash = 0;

    if (hookBlockRVA) memcpy(hookBlockRVA, hookBlock, sizeof(StaticInlineHookBlock));

    return true;
}
