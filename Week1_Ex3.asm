global main
extern printf
extern scanf

section .data
    msg_in db "Nhap vao mot xau (khong co dau cach): ", 0
    msg_out db "Xau dao nguoc la: %s", 10, 0
    fmt_str db "%s", 0

section .bss
    str_buf resb 256        ; Cấp phát 256 byte để chứa xâu

section .text
main:
    sub rsp, 40

    ; --- In thông báo và nhập xâu ---
    lea rcx, [rel msg_in]
    xor rax, rax
    call printf

    lea rcx, [rel fmt_str]
    lea rdx, [rel str_buf]
    xor rax, rax
    call scanf

    ; --- Tìm độ dài xâu để xác định điểm cuối ---
    lea rsi, [rel str_buf]  ; RSI trỏ vào đầu xâu
    mov rdi, rsi            ; RDI cũng trỏ vào đầu xâu (tạm thời)

.find_end:
    cmp byte [rdi], 0       ; Kiểm tra xem RDI đã trỏ tới ký tự NULL (kết thúc) chưa?
    je .found_end
    inc rdi                 ; Nhích RDI sang phải 1 byte
    jmp .find_end

.found_end:
    dec rdi                 ; Lùi RDI lại 1 bước để trỏ vào ký tự chữ cái cuối cùng (bỏ qua NULL)

    ; --- Vòng lặp đảo ngược xâu ---
.reverse_loop:
    cmp rsi, rdi            ; Nếu con trỏ đầu >= con trỏ cuối (đã chạm nhau ở giữa)
    jge .print_result       ; Thì thoát vòng lặp

    ; Đổi chỗ 2 ký tự bằng cách mượn thanh ghi tạm (al và cl)
    mov al, byte [rsi]
    mov cl, byte [rdi]
    mov byte [rsi], cl
    mov byte [rdi], al

    inc rsi                 ; Đầu nhích lên
    dec rdi                 ; Cuối lùi lại
    jmp .reverse_loop

    ; --- In kết quả ---
.print_result:
    lea rcx, [rel msg_out]
    lea rdx, [rel str_buf]
    xor rax, rax
    call printf

    add rsp, 40
    ret