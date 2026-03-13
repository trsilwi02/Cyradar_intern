global main
extern printf
extern scanf
extern system

section .data
    msg1 db "Nhap so thu nhat (-32768 to 32767): ", 0
    msg2 db "Nhap so thu hai (-32768 to 32767): ", 0
    errormsg db "Input khong hop le!", 0
    msg_out db "Tong cua hai so la: %d", 10, 0
    
    fmt_in db "%lld", 0       ; %hd dùng để đọc số nguyên 16-bit (short)

    pause_cmd db "pause", 0

section .bss
    temp_num resq 1          ; 8byte
    num1 resw 1              ;  Cấp phát 1 vùng nhớ 16-bit (2 byte)
    num2 resw 1

section .text
; --- Check input ---
check_input:
    cmp rcx, -32768
    jl .invalid

    cmp rcx, 32767
    jg .invalid

    mov rax, 1  ; hợp lệ thì trả về 1
    ret
.invalid:
    xor rax, rax ; reset ->0
    ret

main:
    sub rsp, 40              ; Cấp phát Shadow Space

    ; --- Nhập số thứ 1 ---
    lea rcx, [rel msg1]
    xor rax, rax
    call printf

    lea rcx, [rel fmt_in]
    lea rdx, [rel temp_num]
    xor rax, rax
    call scanf

    mov rcx, [rel temp_num] ; để chuyển địa chỉ 
    call check_input
    test rax, rax
    jz .input_error

    mov ax, word [rel temp_num]
    mov word [rel num1], ax

    ; --- Nhập số thứ 2 ---
    lea rcx, [rel msg2]
    xor rax, rax
    call printf

    lea rcx, [rel fmt_in]
    lea rdx, [rel temp_num]
    xor rax, rax
    call scanf

    mov rcx, [rel temp_num]
    call check_input
    test rax, rax
    jz .input_error

    ; Hợp lệ: Lưu vào num2
    mov ax, word [rel temp_num]
    mov word [rel num2], ax

    ; --- Tính tổng ---
    ; Dùng lệnh movsx để đưa số 16-bit (word) vào thanh ghi 32-bit (eax, ecx) và giữ nguyên dấu
    movsx eax, word [rel num1]  
    movsx ecx, word [rel num2]  
    add eax, ecx                ; eax = eax + ecx

    ; --- In kết quả ---
    lea rcx, [rel msg_out]
    mov edx, eax                ; Truyền tổng (đang ở eax) vào tham số thứ 2 (edx)
    xor rax, rax
    call printf
    
    jp .exit_program

.input_error:
    lea rcx, [rel errormsg]
    xor rax, rax
    call printf

.exit_program:
    ; --- Tạm dừng trước khi thoát (chỉ cần thiết nếu chạy trong môi trường console) ---
    lea rcx, [rel pause_cmd]
    xor rax, rax
    call system

    add rsp, 40
    ret