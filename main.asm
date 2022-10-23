
mov ax,0
mov bx,0
mov cx,0
mov dx,0
jmp read_input
checkValue db 0 ; a variable to check whether last input is a number

pushStack:
  cmp checkValue,1
  jne read_input
  push cx
  mov cx,0
read_input:
  mov ah,01   ; subfunction reading a char
  int 21h     ; interrupt to call subfunction

  cmp al,42   ;if char is "*"...
  je operMul  ;... jump to label operMul

  cmp al,47   ;if char is "/"...
  je operDiv  ;... jump to label operDiv

  cmp al,124  ;if char is "|"...
  je operOr   ;... jump to label operOr

  cmp al,38   ;if char is "&"...
  je operAnd  ;... jump to label operAnd

  cmp al,94   ;if char is "^"...
  je operXor  ;... jump to label operXor

  cmp al,43   ;if char is "+"...
  je operAdd  ;... jump to label operAdd

  cmp al,32   ;if char is " "...
  je pushStack; ... jump to label pushStack

  cmp al,13   ;if carriage return (enter)
  je output   ;... jump to output label

  jmp numberInput  ; if it is number jump numberInput


operMul:
  mov checkValue,0  ; sets check value zero which implies last input is operator
  pop ax    ; pop value from stack to register ax
  pop bx    ; pop second value from stack to bx
  mul bx    ; this line equals ax = ax * bx
  push ax   ; push value at the register ax back to stack
  mov ax,0  ; reset register ax
  mov bx,0  ; reset register bx
  jmp read_input ; jump back to read_input
operDiv:
  mov checkValue,0
  pop bx
  pop ax
  div bx    ; this line equals ax = ax / bx
  push ax
  mov ax,0
  mov bx,0
  mov dx,0 ; division remainder reset just in case
  jmp read_input
operOr:
  mov checkValue,0
  pop ax
  pop bx
  or ax,bx          ; this line equals ax = ax | bx
  push ax
  mov ax,0
  mov bx,0
  jmp read_input
operAnd:
  mov checkValue,0
  pop ax
  pop bx
  and ax,bx         ; this line equals ax = ax & bx
  push ax
  mov ax,0
  mov bx,0
  jmp read_input
operXor:
  mov checkValue,0
  pop ax
  pop bx
  xor ax,bx         ; this line equals ax = ax ^ bx
  push ax
  mov ax,0
  mov bx,0
  jmp read_input
operAdd:
  mov checkValue,0
  pop ax
  pop bx
  add ax,bx           ; this line equals ax = ax + bx
  push ax
  mov ax,0
  mov bx,0
  jmp read_input
output:
  mov ah,02h          ; subfunction to print
  mov dl,10d          ; new line
  int 21h             ; newline
  pop ax              ; calculated value
  mov bx,16
  mov cx,4 ; set cx register to loop 4 times
myLoop:
  mov dx,0
  div bx             ; shift number to take the last digit
  push dx            ; push last digit to stack
  cmp ax,0           ; if the quotient is not 0 then...
  loop myLoop        ;...there are more digit to continue on
print:
  mov cx,4           ; set cx register to loop 4 times
myLoop2:
  mov ah,02h
  pop dx
  cmp dl,9            ; if dl is greater than 9 then it is letter
  jg printLetter      ;jump to printLetter
  add dl,48 ;"0"      ; if dl is not greater than 9 then it is a number.
                      ;to print the value we need to convert dl to ascii value of corresponding symbol
  int 21h
  loop myLoop2
exit:
  mov ah, 4ch
  int 21h

printLetter:
  sub dl,10d
  add dl,"A"        ; ascii value convertion of corresponding symbol
  int 21h
  loop myLoop2
  jmp exit

numberInput:     ;reads number input and calculates its value digit by digit
  mov checkValue , 1
  cmp al,64         ;check if input is letter or number
  jg letterInput
  sub al,48      ; if it is number convert symbol to ascii
  mov bx,0
  mov bl,al
  mov ax,16
  mul cx
  add bx,ax
  mov cx,bx
  jmp read_input
letterInput:      ;reads letter input and calculates its value digit by digit
  sub al,65
  add al,10d
  mov bx,0
  mov bl,al
  mov ax,16
  mul cx
  add bx,ax
  mov cx,bx
  jmp read_input
