section .data
    newline db 0xA

section .text
    global solve
    extern printf
    extern sscanf

solve:
    ; Input: rdi = input string, rsi = buffer for part1, rdx = buffer for part2

    ; Initialize registers
    xor rax, rax
    xor rsi, rsi
    xor rdx, rdx

    ; Parse cards and calculate parts
    mov rcx, rdi            ; rcx points to input string
    call parse_cards

    ; Print results
    mov rdi, part1_format   ; Format string for part 1
    mov rax, 0              ; Clear RAX register
    call printf             ; Call printf for part 1

    mov rdi, newline        ; Print newline
    mov rax, 0
    call printf

    mov rdi, part2_format   ; Format string for part 2
    mov rax, 0              ; Clear RAX register
    call printf             ; Call printf for part 2

    ; Exit
    mov rax, 0              ; Return 0
    ret

parse_cards:
    ; Input: rcx = input string

    ; Initialize stack frame
    push rbx
    push rbp
    mov rbp, rsp

    ; Process each line
    parse_loop:
        ; Parse card line
        lea rdi, [rcx]      ; rdi points to the current line
        lea rsi, [rax]      ; rsi points to the card structure
        call parse_card

        ; Calculate part 1
        lea rdi, [rsi]      ; rdi points to the card structure
        call solve1

        ; Calculate part 2
        lea rdi, [rsi]      ; rdi points to the card structure
        call solve2

        ; Move to the next line
        lea rdi, [rcx]
        call next_line

        ; Check for the end of the input
        cmp byte [rcx], 0
        je  parse_done

        ; Move to the next card
        lea rcx, [rcx + 1]
        jmp parse_loop

    parse_done:
    ; Restore stack frame
    mov rsp, rbp
    pop rbp
    pop rbx
    ret

parse_card:
    ; Input: rdi = pointer to the current line, rsi = pointer to the card structure

    ; Parse integers from the line
    lea rdx, [integers]
    lea rdi, [rdi]
    mov eax, 0
    call sscanf

    ; Extract winning and have from integers
    mov rsi, rdx
    lea rdi, [winning]
    mov ecx, 10
    rep movsd

    ; Create a Card structure
    mov rsi, rsi           ; Skip the first integer
    mov rax, [rsi]
    mov [rsi], rax         ; Set the winning value
    lea rdi, [rsi + 8]
    lea rsi, [rsi + 16]
    rep movsd              ; Set the have values

    ; Return
    ret

solve1:
    ; Input: rdi = pointer to the card structure

    ; Calculate points
    lea rsi, [rdi]
    call points

    ; Add points to the total
    add [rdx], rax

    ; Return
    ret

points:
    ; Input: rsi = pointer to the card structure

    ; Get nWinning
    mov rax, [rsi]
    mov rsi, [rsi + 8]
    lea rdx, [winning]
    rep movsd

    ; Calculate points
    mov rax, 0
    mov rcx, 0
    calculate_loop:
        ; Check if n == 0
        cmp rcx, rax
        je  calculate_done

        ; Calculate 2 ^ (n - 1)
        shl rdx, 1
        inc rcx
        jmp calculate_loop

    calculate_done:
    ; Return
    ret

solve2:
    ; Input: rdi = pointer to the card structure

    ; Find generating and add to the result list
    lea rsi, [rdi]
    lea rdx, [results]
    call find_generating

    ; Return
    ret

find_generating:
    ; Input: rsi = pointer to the card structure, rdx = pointer to the results list

    ; Get nWinning
    mov rax, [rsi]
    mov rsi, [rsi + 8]
    lea rdi, [winning]
    rep movsd

    ; Get results
    mov rsi, rdx
    lea rdi, [results]
    rep movsd

    ; Calculate nGenerating
    mov rax, 1
    mov rcx, 0
    calculate_loop:
        ; Check if n == 0
        cmp rcx, rax
        je  calculate_done

        ; Calculate 1 + sum(take nCopies results)
        mov rsi, rdx
        mov rdi, rcx
        call take_n_copies

        add rax, rdi
        inc rcx
        jmp calculate_loop

    calculate_done:
    ; Update results
    mov rsi, rdx
    mov rdi, [results]
    mov [rsi], rdi

    ; Return
    ret

take_n_copies:
    ; Input: rsi = pointer to the results list, rdi = nCopies

    ; Calculate sum(take nCopies results)
    mov rax, 0
    mov rcx, 0
    take_n_copies_loop:
        ; Check if n == 0
        cmp rcx, rdi
        je  take_n_copies_done

        ; Add result to sum
        add rax, [rsi]
        add rsi, 8

        ; Move to the next result
        inc rcx
        jmp take_n_copies_loop

    take_n_copies_done:
    ; Return
    ret

next_line:
    ; Input: rdi = pointer to the current line

    ; Move to the next line (search for newline character)
    find_newline:
        cmp byte [rdi], 0
        je  next_line_done
        cmp byte [rdi], 0xA
        je  next_line_done

        ; Move to the next character
        inc rdi
        jmp find_newline

    next_line_done:
    ; Return
    ret

section .bss
    integers resq 10
    winning  resq 10
    have     resq 10
    results  resq 10

section .data
    part1_format db "Part 1: %d", 0
    part2_format db "Part 2: %ld", 0