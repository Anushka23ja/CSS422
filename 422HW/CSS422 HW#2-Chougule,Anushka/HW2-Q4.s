src		DCB		'a','b','c','d','e','f','g','h','i','j','k','l',0
dst		DCB		0,0,0,0,0,0,0,0,0,0,0,0,0
		
begin
		LDR		R0, =src
		LDR		R1, =dst
		
loop		LDRB		R2, [R0], #1
		CMP		R2, #0
		BEQ		done
		SUB		R2, R2, #0x20
		STRB		R2, [R1], #1
		B		loop
		
done		B		done
		END
