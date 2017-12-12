[bits 16]
global ap_length
global ap_entry
global far_jmp_offset
extern gdt_data
extern end_of_gdt
extern page_directory
extern cpu2

ap_entry:
  jmp past_header

  align 8
  ap_length: dd ap_end - ap_entry
  far_jmp_offset: dd far_jmp_end - ap_entry - 6
  dw 0
gdt_pointer:
  dw 23 ; limit (Size of GDT)
  dd gdt_data                  ; base of GDT
  
pm_entry_vec:
  dd pm_entry - ap_entry
  dw 0x8

  align 8

past_header:
  cli

  lgdt [cs:gdt_pointer - ap_entry]
  mov ax, 0x10
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; load page_directory to cr3 register
  mov eax, page_directory
  mov cr3, eax

  ; enable PSE for 4MB pages
  mov eax, cr4
  or eax, 0x00000010
  mov cr4, eax
  
  xor eax,eax
  mov ax,cx
  shl eax,4
  add pm_entry_vec,eax

  ; enable paging and protected mode in the cr0 register
  mov eax, 0x80000011
  mov cr0, eax
  jmp far [cs:pm_entry_vec]
[bits 32]
pm_entry:

  jmp 0x8:cpu2
far_jmp_end:
ap_end:
