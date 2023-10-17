.386
.model flat,stdcall
.stack 4096

EXTRN ExitProcess@4 : PROC
EXTRN GetStdHandle@4 : PROC
EXTRN WriteConsoleA@20 : PROC
EXTRN ReadConsoleA@20 : PROC

.data
msg BYTE "Hello World!", 0
inputPrompt BYTE "Enter the number of times to print 'Hello World': ", 0
inputBuffer BYTE 10 DUP(0)
bytesWritten DWORD ?
bytesRead DWORD ?

.code

PRINT PROC
    push -11
    call GetStdHandle@4
    push 0
    push OFFSET bytesWritten
    push LENGTHOF msg - 1
    push OFFSET msg
    push eax
    call WriteConsoleA@20
    ret
PRINT ENDP

main PROC
    push -11
    call GetStdHandle@4
    push 0
    push OFFSET bytesWritten
    push LENGTHOF inputPrompt - 1
    push OFFSET inputPrompt
    push eax
    call WriteConsoleA@20
    push -10
    call GetStdHandle@4
    push 0
    push OFFSET bytesRead
    push SIZEOF inputBuffer
    push OFFSET inputBuffer
    push eax
    call ReadConsoleA@20
    xor edx, edx
    mov esi, OFFSET inputBuffer
convertLoop:
    movzx eax, BYTE PTR [esi]
    test eax, eax
    jz doneConversion
    sub eax, '0'
    imul edx, edx, 10
    add edx, eax
    inc esi
    jmp convertLoop
doneConversion:
printLoop:
    test edx, edx
    jz endLoop
    call PRINT
    dec edx
    jmp printLoop
endLoop:
    push 0
    call ExitProcess@4
main ENDP
END main
