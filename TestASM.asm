global main
extern printf

section .data
    msg db "SASM environment OK!", 10, 0

section .text
main:
    sub rsp, 40          ; stack alignment cho Windows
    mov rcx, msg         ; tham số đầu tiên (Windows calling convention)
    call printf
    add rsp, 40

    mov eax, 0
    ret