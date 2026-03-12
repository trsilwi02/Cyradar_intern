global main
extern MessageBoxA

section .data
    msg_text db "Siuuuuuuu!", 0
    msg_title db "Note", 0

section .text
main:
    sub rsp, 40

    xor rcx, rcx
    lea rdx, [rel msg_text]
    lea r8, [rel msg_title]
    xor r9, r9

    call MessageBoxA

    add rsp, 40
    ret