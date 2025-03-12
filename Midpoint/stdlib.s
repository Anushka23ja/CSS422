; Author: Anushka Chougule
; Date: Feb 28, 2025

                AREA    |.text|, CODE, READONLY, ALIGN=2
                THUMB

;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void _bzero( void *s, int n )
; Parameters
;       s       - pointer to the memory location to zero-initialize
;       n       - number of bytes to zero-initialize
; Return value
;   none

                EXPORT    _bzero
_bzero
                ; r0 = s
                ; r1 = n

                PUSH    {r1-r12,lr}
                MOV      R4, R1
                MOV      R2, #0

loopb
                SUBS     R4, R4, #1
                BMI      endB
                STRB     R2, [R0], #1
                B        loopb
endB
                POP     {r1-r12,lr}
                BX       lr


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char* _strncpy( char* dest, char* src, int size )
; Parameters
;       dest - pointer to the buffer to copy to
;       src  - pointer to the zero-terminated string to copy from
;       size - total number of bytes to copy
; Return value
;   dest

                EXPORT    _strncpy
_strncpy
                ; r0 = dest
                ; r1 = src
                ; r2 = size
                ; r3 = a copy of original dest
                ; r4 = src[i]

                PUSH    {R1-R12, LR}
                MOV     R3, R0

loops
                SUBS    R2, R2, #1
                BMI     endloops
                LDRB    R4, [R1], #1
                STRB    R4, [R0], #1
                CMP     R4, #0
                BNE     loops
endloops
                POP     {R1-R12, LR}
                BX      LR

                END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void* _malloc( int size )
; Parameters
;       size - number of bytes to allocate
; Return value
;       void* - pointer to the allocated space
                EXPORT    _malloc

_malloc
               ; Save registers
               ; r7 = size (number of bytes)
    SVC        #0x0
    MOV        pc, lr            ; resume registers and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void _free( void* addr )
; Parameters
;       addr - the address of a space to deallocate
; Return value
;       none
    EXPORT    _free
_free
                  ; Save registers
                  ; r7 = addr (address to free)
       

;;;;;;;;;;;;;;;;;;;;;;;;;EXTRA CREDIT (WORKING AHEAD)- WORK STILL IN TESTING PHASE;;;;;;;;;;;;;;;;;;;
    ; PUSH {lr}
    ; MOV R1, R0
    ; LDR   R2 = HEAP_TOP
    ; LDR   R3 = HEAP_BOT

    ; CMP   R1, R2
    ; BLT   invalid_add
    ; CMP   R1, R3
    ; BGT   invalid_add

    ;LDR    R4, =MCB_TOP
    ;SUB    R5, R5, #4

    SVC        #0x0                 ; Make system call for free
    POP        pc, lr              ; Restore registers and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unsigned int _alarm( unsigned int seconds )
; Parameters
;       seconds - seconds when a SIGALRM signal should be delivered
; Return value
;       unsigned int - the number of seconds remaining for any previously scheduled alarm
;                  or zero if there was no scheduled alarm
    EXPORT    _alarm
_alarm
                  ; Save registers
                  ; r7 = seconds (alarm time)
    SVC        #0x0                 ; Make system call for alarm
    MOV        pc, lr             ; Restore registers and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void* _signal( int signum, void *handler )
; Parameters
;       signum - signal number (14 = SIGALRM)
;       handler - pointer to a user-level signal handling function
; Return value
;       void* - pointer to the user-level signal handling function previously handled
    EXPORT    _signal
_signal
                                  ; Save registers
    
    SVC        #0x0                 ; Make system call for signal handling
    MOV        pc, lr             ; Restore registers and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    END
