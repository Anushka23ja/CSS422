		AREA	|.text|, CODE, READONLY, ALIGN=2
		THUMB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; System Timer Definition
STCTRL		EQU		0xE000E010		; SysTick Control and Status Register
STRELOAD	EQU		0xE000E014		; SysTick Reload Value Register
STCURRENT	EQU		0xE000E018		; SysTick Current Value Register
	
STCTRL_STOP	EQU		0x00000004		; Bit 2 (CLK_SRC) = 1, Bit 1 (INT_EN) = 0, Bit 0 (ENABLE) = 0
STCTRL_GO	EQU		0x00000007		; Bit 2 (CLK_SRC) = 1, Bit 1 (INT_EN) = 1, Bit 0 (ENABLE) = 1
STRELOAD_MX	EQU		0x00FFFFFF		; MAX Value = 1/16MHz * 16M = 1 second
STCURR_CLR	EQU		0x00000000		; Clear STCURRENT and STCTRL.COUNT	
SIGALRM		EQU		14				; sig alarm

; System Variables
SECOND_LEFT	EQU		0x20007B80		; Secounds left for alarm( )
USR_HANDLER EQU		0x20007B84		; Address of a user-given signal handler function	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timer initialization
		EXPORT		_timer_init
_timer_init

		LDR		R1, =STCTRL
		LDR		R0, =STCTRL_STOP	
		STR		R0, [R1]	
		LDR		R1, =STRELOAD			
		LDR		R0, =STRELOAD_MX		
		STR		R0, [R1]				

		LDR		r0, =STCURRENT	
		MOV		r1, #0		
		STR		r1, [r0]
		
		MOV		pc, lr	
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timer start
		EXPORT		_timer_start
_timer_start
		LDR 	R1, =SECOND_LEFT
		LDR		R2, [R1]
		STR 	R0, [R1]
		
		LDR		R3, =STCTRL
		LDR		R4, =STCTRL_GO
		STR		R4, [R3]
		
		LDR		R5, =STCURRENT
		MOV 	R6, #0x00000000	
		STR		R6, [R5]
		
		MOV 	R0, R2
		
		MOV		pc, lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timer update

		EXPORT		_timer_update
_timer_update
		LDR		R1, =SECOND_LEFT	
		LDR		R2, [R1] 		
		SUB 	R2, R2, #1		
		STR 	R2, [R1]
		
		CMP		R2, #0
		BNE		_timer_update_done
		
		LDR		R3, =STCTRL
		LDR		R4, =STCTRL_STOP
		STR		R4, [R3]
		
		LDR 	R5, =USR_HANDLER
		LDR		R6, [R5]
		
		STMFD	sp!, {r1-r12,lr}		
		BLX 	R6
		LDMFD	sp!, {r1-r12,lr}		

_timer_update_done
		MOV		pc, lr			


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timer update

	    EXPORT	_signal_handler
_signal_handler
		PUSH 	{R2}
		CMP		R0, #SIGALRM
		BNE		handler_return	
		
handle_SIGALRM
		LDR		R2, =USR_HANDLER	
		LDR		R3, [R2]		
		STR		R1, [R2]	
		MOV 	R0, R3 			

handler_return
		POP		{R2}
		MOV		pc, lr			

		END		