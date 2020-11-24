	AREA     factorial, CODE, READONLY
     IMPORT printMsg
	 IMPORT printComma
	 IMPORT printNextl
     IMPORT printMessage
	 EXPORT __main
	 EXPORT __COSINE
	 EXPORT __SINE
	 EXPORT __CIRCLEDRAW
	 EXPORT __CIRCLEDRAW2
		ENTRY 


__SINE FUNCTION			;(choosing S9 = X which is input....... The output of sine is in S5))
     				;x=0-360

        VLDR.F32 S1,=90.0

        VMOV.F32 S0,S9

        VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

		BLT BEGIN

        VLDR.F32 S1,=180.0		

		VSUB.F32 S0,S1,S9

        VLDR.F32 S1,=270.0

		VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

        BLT BEGIN

		VLDR.F32 S1,=360.0

        VSUB.F32 S0,S9,S1

						;S0 stores angle in range -pi/2 --- pi/2


BEGIN   VLDR.F32 S7,=3.141592654

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20  ; total terms

		

		VMUL.F32 S1,S0,S7

		VDIV.F32 S1,S1,S8					;x=PI*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2

		VNEG.F32 S2,S2						;-x^2

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=2.0

		VMOV.F32 S5,S1		                ;FOR 1ST TERM

		

LOOPLABEL	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n+1)

		VADD.F32 S4,S4,S6
		
		VADD.F32 S5,S5,S3					;S5 stores SIN(X)

		SUB R1,R1,#1						;R1 decrement

		CMP R1,#0

		BNE LOOPLABEL							;Loop for all series terms

		                   ;S5 = final terms of sinx 
		VMOV.F32 R0,S5

		BX lr

		
	ENDFUNC
;
__COSINE FUNCTION		;final value of cosx
		
BEGIN2	VLDR.F32 S7,=3.141592654

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20         ;to get total terms

		

		VMUL.F32 S1,S9,S7

		VDIV.F32 S1,S1,S8		;x=PI*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2
		VNEG.F32 S2,S2						;-x^2
		
		VLDR.F32 S1,=1.0

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=1.0

		VMOV.F32 S5,S1		                ;COSX=1

		

LOOPLABEL2	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n-1)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VADD.F32 S5,S5,S3					;S5 stores cos(X)

		
		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE LOOPLABEL2							;loop to other terms

		                                    ;cosx final value
	
		
		BX lr

		
	ENDFUNC	
;	
__CIRCLEDRAW FUNCTION				;(to draw final CIRCLE take S22=radius S26=x value center  ,S27 = y value center )
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=300.0     ; we suppose that after 300 degree we make a new inner circle of less radius which becomes spiral
		VLDR.F32 S28,=360.0
		VLDR.F32 S25,=20
		VLDR.F32 S9,=0.0 	;initial value of angle as zero
LABELL	VMOV.F32 R0,S9
		BL printMsg		
		BL printComma
		BL __SINE		;Call sine function
		VMUL.F32 S5,S5,S22		;S5=RADIUS*SIN (ANGLE)
		VADD.F32 S5,S5,S27		;S5= centerofY(S27) + RADIUS*SIN (ANGLE)
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSINE		;call cos function
		VMUL.F32 S5,S5,S22		;S5=  RADIUS* COS(ANGLE)
		VADD.F32 S5,S5,S26		;S5= CENTER_Y(S27) + RADIUS* COS(ANGLE)
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20    ;adding degree by one to inc angle
		VCMP.F32 S9,S21		;if the angle is 300 then decrease the circle radius
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VSUBEQ.F32 S22,S22,S25 ; substract the radius by 20 in each iteratiom
		VCMP.F32 S9,S28;   
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VLDREQ.F32 S9,=0.0
		VCMP.F32 S22,#0
		VMRS APSR_nzcv, FPSCR
		IT EQ
		BEQ stop
		
		
		B LABELL
		
		BX lr
		
		ENDFUNC
		
		
__CIRCLEDRAW2 FUNCTION			;(to draw final CIRCLE take S22=radius S26=x value center,S27 = y value center for SPIRAL2
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=300.0
		VLDR.F32 S28,=360.0
		VLDR.F32 S25,=20
		VLDR.F32 S9,=0.0 			
LABELL1	VMOV.F32 R0,S9
		BL printMsg		
		BL printComma
		BL __SINE			
		VMUL.F32 S5,S5,S22					
		VADD.F32 S5,S5,S18			
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSINE				
		VMUL.F32 S5,S5,S22				
		VADD.F32 S5,S5,S30					
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20
		VCMP.F32 S9,S21		;COMPARE AND REPEAT THE OPERATION TILL ANGLE REACHES 360 DEGREES
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VSUBEQ.F32 S22,S22,S25
		VCMP.F32 S9,S28
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VLDREQ.F32 S9,=0.0
		VCMP.F32 S22,#0
		VMRS APSR_nzcv, FPSCR
		IT EQ
		BEQ stop
		
		
		B LABELL1
		
		BX lr
		
		ENDFUNC
		
__main  FUNCTION
		
		VLDR.F32 s22,=80.0				;radius
		VLDR.F32 s18,=700.0 ; X for 2ed spiral
		VLDR.F32 s30,=800.0 ; Y for 2ed spiral
		VMOV.F32 R0,S22
		VLDR.F32 S26,=200.0		;X
		VMOV.F32 R1,S26
		VLDR.F32 S27,=400.0		;Y
		VMOV.F32 R2,S27
		BL printMessage
		
		;BL printMessage1
		
		BL __CIRCLEDRAW					;DRAWING CIRCLE OF RADIUS 80 AND CENTERED AR (200,400)
		BL __CIRCLEDRAW2; DRAWING CIRCLE OF RADIUS 80 AND CENTERED AR (700,800)
		
stop    B stop                              ; stop program

     ENDFUNC
	 END