DATA SEGMENT PARA PUBLIC 'DATA'
    NUMAR DW 0000D
    DIGITS DB 0, 0, 0, 0
    COUNTER Db 00H
    SPACE DB 32D ;SPACE FOR PRINT
    ENDL DB 13, 10 ;END OF LINE
    filename db 'date.txt', 0
    fileHandle dw ?
    promptb db 'Starting from:$'
    prompte db 'Iterations: $'
    error_message db 'Wrong input, try again:$'
    dividing_string db ' - $'
    dividing_string2 db ' = $'
    FLAG db 00H ;flag for checking the input
    MODE db 'Choose mode: 1 - Autorun, 2 - Interaction$'
    ERRMODE DB 'Wrong mode, try again:$'
    promptautorun db 'Autorun mode initiated$'
    promptinteraction db 'Interaction mode initiated$'
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

    ; Display MODE
    MOV DX, OFFSET MODE
    MOV AH, 09h ; Function to display string 
    INT 21h

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    ; Read MODE
    PICKMODE:

    MOV AH, 01h ; Function to read character with echo
    INT 21h 
    CMP AL,'1'
        JE AUTORUNLBL
    CMP AL,'2'
        JE INTERACTIONLBL
    
    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    MOV DX, OFFSET ERRMODE
    MOV AH, 09h ; Function to display string
    INT 21h
    JMP PICKMODE

    AUTORUNLBL:

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    ; Display autorun initiated
    MOV DX, OFFSET promptautorun
    MOV AH, 09h ; Function to display string
    INT 21h

    CALL AUTORUN ; initiate the autorun mode
    RET

    INTERACTIONLBL:

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    ; Display interaction initiated
    MOV DX, OFFSET promptinteraction
    MOV AH, 09h ; Function to display string
    INT 21h

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    CALL Interaction ; initiate the interaction mode
    ; your code ends here
RET
START ENDP
CODE ENDS

CODE9 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE9
AUTORUN PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    ; Create the file
    MOV DX, OFFSET filename
    MOV CX, 0 ;0 for normal file
    MOV AH, 3Ch ; Create file function
    INT 21h ; DOS interrupt
    MOV [fileHandle], AX ; Save file handle

    ; Main body (increment the nr get the nr of iterations and write them in the file and repeat)
    ITERMAIN:
    MOV AX,NUMAR 
    CALL Kaprekar ;call kaprekar to get the nr of iterations
    CALL WRITE  ;call write to write the number and the nr of iteration in the file date.txt
    CMP NUMAR,9999D ;check if we reached the last number
    JE ENDF7
    ADD NUMAR,1D   ;if not increment nr and reset counter
    MOV COUNTER,00H
    JMP ITERMAIN
    ENDF7:

    ; Close the file
    MOV BX, [fileHandle] ; File handle
    MOV AH, 3Eh ; Close file function
    INT 21h ; DOS interrupt
RET
AUTORUN ENDP

CODE9 ENDS

CODE10 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE10
INTERACTION PROC FAR
; Display prompt
    MOV DX, OFFSET promptb
    MOV AH, 09h ; Function to display string
    INT 21h

    ; Read character
    MOV SI, 0D
    MOV FLAG,00H
    getnr:
    MOV AH, 01h ; Function to read character with echo
    INT 21h 
    CMP AL,'0'
        JB FLAG1
    CMP AL,'9'
        JA FLAG1
    SUB AL,'0' ; Convert character to number
    MOV DIGITS[SI], AL 
    ADD SI,1D   
    CMP SI,4D
    JE ENDF8
    JMP getnr
    FLAG1:
    MOV FLAG,01H
    ADD SI,1D
    CMP SI,4D
    JE ENDF8
    JMP getnr
    ENDF8:
    CMP FLAG,01H
        JE ERROR ;if its not a number print error message and reask for input
    JMP FINE ;if its fine go next
    ERROR:

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    ;print error message
    MOV DX, OFFSET error_message
    MOV AH, 09h
    INT 21h
    MOV FLAG,00H
    MOV SI,0D
    JMP GETNR

    FINE:

    ;Print endl
    MOV DL, 13D
    MOV AH, 02h 
    INT 21h 
    
    MOV DL, 10D
    MOV AH, 02h 
    INT 21h 

    CALL MAKENR ;make the nr from the saved digits
    MOV NUMAR,AX
    CALL Kaprekar_INT   ;use algorithm to get the nr of iterations

    ; Display prompt end
    MOV DX, OFFSET prompte 
    MOV AH, 09h 
    INT 21h

    ADD COUNTER,'0'
    ; nr of iterations
    MOV DL, COUNTER 
    MOV AH, 02h 
    INT 21h 

RET
INTERACTION ENDP
CODE10 ENDS

CODE7 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE7
WRITE PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    MOV AX,NUMAR
    CALL MAKEDIGITS ;WE NEED TO ADD THE CHARACTER 0 TO EACH DIGIT TO MAKE IT A CHAR
    ;WE NEED TO CORRECT THE ORDER IN WHICH THE DIGITS ARE SAVED(REVEERSE IT)
    MOV BL,DIGITS[3]
    MOV BH,DIGITS[0]
    MOV digits[3],BH
    mov digits[0],BL
    MOV BL,DIGITS[2]
    MOV BH,DIGITS[1]
    mov digits[2],BH
    mov digits[1],BL
    MOV SI,0000H    
    TOCHAR:     ;we add the character 0 to each digit to make it a char
        ADD DIGITS[SI],'0'
        ADD SI,1D
        CMP SI,4D
    JE ENDF6
    JMP TOCHAR
    ENDF6:
    ; Write the number
    MOV DX, OFFSET DIGITS ;what to write
    MOV CX, 4D ;how many bytes to write
    MOV BX, [fileHandle] ;where to write
    MOV AH, 40h ; Write to file function
    INT 21h ; DOS interrupt

    ; Write the space between the number and the number of iterations
    MOV DX, OFFSET SPACE 
    MOV CX, 1D 
    MOV BX, [fileHandle] 
    MOV AH, 40h 
    INT 21h 

    ; Write the number of iterations
    ADD COUNTER,'0' 
    MOV DX, OFFSET COUNTER 
    MOV CX, 1D 
    MOV BX, [fileHandle] 
    MOV AH, 40h 
    INT 21h 

    ; Write enf of line
    MOV DX, OFFSET ENDL 
    MOV CX, 2D 
    MOV BX, [fileHandle] 
    MOV AH, 40h 
    INT 21h 
RET
WRITE ENDP

CODE7 ENDS

CODE3 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE3
Kaprekar PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    ITER:
    ADD COUNTER,1D  ; we start the counter
    CALL SORTDIGITS ; we sort the digits of the number
    CALL MAKENR ; we make a number with the digits
    CALL Inverse ; we make the inverse of the number
    SUB AX,DX ; we substract the number with the inverse
    CMP AX,0000H ;we check if the number is either 0000 or 6174
    JE ENDF5
    CMP AX,6174D
    JE ENDF5
    JMP ITER
    ENDF5:
RET
Kaprekar ENDP

CODE3 ENDS

CODE11 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE11
Kaprekar_INT PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    ITER1:
    ADD COUNTER,1D  ; we start the counter
    CALL SORTDIGITS ; we sort the digits of the number
    CALL MAKENR ; we make a number with the digits
    MOV BX,AX
    ; print the nr
    XOR SI,SI
    getnr3: 
    ADD DIGITS[SI],'0'
    MOV DL, DIGITS[SI]
    MOV AH, 02h 
    INT 21h 
    ADD SI,1D   ; inc adress
    CMP SI,4D
    JE ENDF10
    JMP getnr3
    ENDF10:

    ;print the dividing_string
    MOV DX, OFFSET dividing_string
    MOV AH, 09h
    INT 21h

    MOV SI,4D
    ;print the inverse
    getnr4: 
    SUB SI,1D 
    MOV DL, DIGITS[SI]
    MOV AH, 02h 
    INT 21h 
    CMP SI,0D
    JE ENDF9
    JMP getnr4
    ENDF9:

    ;print the dividing_string2
    MOV DX, OFFSET dividing_string2
    MOV AH, 09h
    INT 21h

    MOV AX,BX

    CALL Inverse ; we make the inverse of the number
    SUB AX,DX ; we substract the number with the inverse
    MOV CX,AX
    
    CALL MAKEDIGITS

    ;print the result
    MOV SI,4D
    getnr5:
    SUB SI,1D   
    ADD DIGITS[SI],'0'
    MOV DL, DIGITS[SI]
    MOV AH, 02h 
    INT 21h 
    CMP SI,0D
    JE ENDF11
    JMP getnr5
    ENDF11:

    ;print endl
    MOV DL, 13D
    MOV AH, 02h
    INT 21h

    MOV DL, 10D
    MOV AH, 02h
    INT 21h

    MOV AX,CX

    CMP AX,0000H ;we check if the number is either 0000 or 6174
    JE ENDF51
    CMP AX,6174D
    JE ENDF51
    JMP ITER1
    ENDF51:
RET
Kaprekar_INT ENDP

CODE11 ENDS

CODE6 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE6
MAKENR PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    MOV SI,0
    XOR AX,AX
    MKNR:
    XOR BX,BX
    MOV BL,DIGITS[SI]
    ADD AX,BX ; add the new digit to the number
    ADD SI,1D
    CMP SI,4D
    JE ENDF4
    MOV CX,AX
    SHL AX,3 ;multiply by 10 to make space for the new digit
    ADD AX,CX
    ADD AX,CX
    JMP MKNR
    ENDF4:
RET
MAKENR ENDP

CODE6 ENDS

CODE8 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE8
MAKEDIGITS PROC FAR ; FUNCTION TO MAKE A NR WITH THE DIGITS IN THE VECTOR
    ;WE ASSUME THAT THE GIVEN NR IS IN AX AND WE PUT THE DIGITS IN THE DIGITS VECTOR IN ORDER TO SORT THEM
    MOV SI,0000H ;WE USE SI AS AN INDEX
    GET:
    CALL DIV10
    MOV DIGITS[SI],AL
    ADD SI,1D
    MOV AX,BX
    CMP SI,4D
    JE ENDF2
    JMP GET
    ENDF2: ; THE DIGITS ARE SAVED IN THE VECTOR
RET
MAKEDIGITS ENDP

CODE8 ENDS

CODE5 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE5
SORTDIGITS PROC FAR
    CALL MAKEDIGITS ; NOW WE NEED TO SORT THE VECTOR
    SORTR: ; SORT + RESET
    MOV SI, 0000H ; WE RESET THE COUNTER
    XOR CX,CX ; WE PREPARE ANOTHER COUNTER IN ORDER TO CHECK IF ALL THE NR ARE IN ORDER
    SORTN: ;NORMAL SORT
    MOV AL,DIGITS[SI]
    MOV BL,DIGITS[SI+1]
    CMP AL,BL
    JAE SKIP    ;WE SWAP THE DIGITS IF THEY ARE IN THE WRONG ORDER
    MOV DIGITS[SI],BL
    MOV DIGITS[SI+1],AL
    JMP SKIPCX
    SKIP:
    ADD CX,1D
    SKIPCX:
    ADD SI,1D
    CMP CX,3    ; WE CHECK IF ALL THE DIGITS ARE IN ORDER AND IF THEY ARE WE EXIT
    JE ENDF3
    CMP SI,3D   ; WE CHECK IF WE VERIFIED ALL THE NR IN THE VECTOR
    JE SORTR
    JMP SORTN
    ENDF3:
RET
SORTDIGITS ENDP

CODE5 ENDS

CODE2 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE2
Inverse PROC FAR
XOR DX,DX
XOR BX,BX ;PREPARE THE REGISTER FOR THE FUNCTION AND SAVE THE VALUE OF AX
PUSH AX
MAKEREV:
CALL DIV10  ; WE NEED TO DIVIDE BY 10 IN ORDER TO GET THE ZECIMAL
ADD DX,AX
MOV CX,DX
MOV AX,BX
CMP AX,0    ; WE CHECK IF WE ADDED THE LAST DECIMAL
JE ENDF
SHL DX,3    ; WE MULTIBLY BY 10 BY SHIFTIN 3 TIMES ( *8 ) AND ADDING 2 * DX
ADD DX,CX
ADD DX,CX
JMP MAKEREV
ENDF:
POP AX  ; WE GET THE VALUE OF AX BACK FROM THE STACK
RET 
Inverse ENDP

CODE2 ENDS

CODE4 SEGMENT PARA PUBLIC 'CODE'
ASSUME CS:CODE4
DIV10 PROC FAR
    MOV BX,0000H; THIS FUNCTION DIVIDES BY 10 WHERE AX IS AX MOD 10 AND BX IS AX/10
    REPEAT:
    CMP AX,10D
    JB ENDF1
    CMP AX,1000D ; I ADDED THE THIS SUBTRACTION FOR FASTER EXECUTION
    JB SUBMIE
    SUB AX,1000D
    ADD BX,100D
    JMP REPEAT
    SUBMIE:
    CMP AX,100D
    JB SUBSUTA
    SUB AX,100D
    ADD BX,10D
    JMP REPEAT
    SUBSUTA:
    SUB AX,10D
    ADD BX,1D
    JMP REPEAT
    ENDF1:
RET
DIV10 ENDP

CODE4 ENDS
END START