DATA SEGMENT PARA PUBLIC 'DATA'
    filename db 'date.txt', 0
    fileHandle dw ?
    message db 'Hello, World!', 0
    LEN     DW      $-message
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE, DS:DATA
START PROC FAR
    PUSH DS
    XOR AX, AX
    MOV DS, AX
    PUSH AX 
    MOV AX, DATA
    MOV DS, AX
    ; your code starts here

    ; Open the file
    MOV DX, OFFSET filename ; Filename
    MOV AX, 3D02h ; Open file function (3Dh) with Read/Write access (02h)
    INT 21h ; DOS interrupt
    MOV [fileHandle], AX ; Save file handle

    ; Write to the file
    MOV DX, OFFSET message ; Message to write
    MOV CX, LEN ; Number of bytes to write
    MOV BX, [fileHandle] ; File handle
    MOV AH, 40h ; Write to file function
    INT 21h ; DOS interrupt

    ; Close the file
    MOV BX, [fileHandle] ; File handle
    MOV AH, 3Eh ; Close file function
    INT 21h ; DOS interrupt

    ; your code ends here
RET
START ENDP

CODE ENDS
END START