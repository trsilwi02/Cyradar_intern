global main
extern printf
extern scanf
extern system

section .data
msg1 db "Nhap so nhi phan thu nhat: ", 0
msg2 db "Nhap so nhi phan thu hai: ", 0
msg3 db "Tong cua hai so la: %lld", 10, 0

errormsg db "Input khong hop le!", 10, 0

str_format db "%s", 0
pause_cmd db "pause", 0

buf1 times 64 db 0 ; vì là string nên cần buf để chứa đầu vào
buf2 times 64 db 0

num1 dq 0
num2 dq 0

section .text

bin_to_int:
    xor rax, rax ; reset thanh ghi rax
    mov rsi, rcx 

.loop:
    movzx r8, byte [rsi]    ; FIX: Đọc từ RSI (địa chỉ chuỗi) và dùng movzx
    test r8, r8
    je .done

    sub r8, '0'
    shl rax, 1
    add rax, r8

    inc rsi
    jmp .loop

.done:
    ret


; =========================
; hàm check input nhị phân
; RCX = dia chi chuoi
; tra ket qua: RAX = 1 (hợp lệ), 0 (lỗi)
; =========================
check_bin_input:
    mov rsi, rcx
.loop_check:
    mov r8b, byte [rsi]
    test r8b, r8b
    jz .valid

    cmp r8b, '0'
    jl .invalid
    cmp r8b, '1'
    jg .invalid
    
    inc rsi
    jmp .loop_check
.valid:
    mov rax, 1
    ret
.invalid:
    xor rax, rax
    ret

; =========================
; CHƯƠNG TRÌNH CHÍNH
; =========================
main:
    sub rsp, 40             ; Cấp phát shadow space và căn lề stack (16-byte)

; --- NHẬP VÀ XỬ LÝ SỐ 1 ---
    lea rcx, [rel msg1]
    xor rax, rax
    call printf

    lea rcx, [rel str_format]
    lea rdx, [rel buf1]
    xor rax, rax
    call scanf

    ; check chuoi 1
    lea rcx, [rel buf1]
    call check_bin_input
    test rax, rax
    jz .input_error         ; Nếu lỗi -> nhảy tới xử lý lỗi

    ; convert num1
    lea rcx, [rel buf1]
    call bin_to_int
    mov [rel num1], rax

; --- NHẬP VÀ XỬ LÝ SỐ 2 ---
    lea rcx, [rel msg2]
    xor rax, rax
    call printf

    lea rcx, [rel str_format]
    lea rdx, [rel buf2]
    xor rax, rax
    call scanf

    ; check chuoi 2
    lea rcx, [rel buf2]
    call check_bin_input
    test rax, rax 
    jz .input_error 

    ; convert num2
    lea rcx, [rel buf2]
    call bin_to_int
    mov [rel num2], rax

; --- TÍNH TOÁN VÀ IN KẾT QUẢ ---
    mov rax, [rel num1]
    add rax, [rel num2]

    lea rcx, [rel msg3]
    mov rdx, rax            ; Tham số thứ 2 (kết quả tổng) vào RDX
    xor rax, rax
    call printf
    
    jp .exit_program ; nhảy tới exit để tránh in lỗi nếu có

; --- XỬ LÝ LỖI INPUT ---
.input_error:
    lea rcx, [rel errormsg]  
    xor rax, rax
    call printf

; --- Thoát chương trình ---
.exit_program:
    lea rcx, [rel pause_cmd]
    xor rax, rax
    call system

    add rsp, 40
    ret