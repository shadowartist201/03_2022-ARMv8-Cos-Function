	.data

x: //input data double
	.double 3.14
a: //input data int
	.xword 8
z: //the answer
	.double 0.0

y: //fac storage doubles and temp
	.double 0.0,0.0,0.0
b: //fac storage int
	.xword 0

v: //double to load for pow and math nums
	.double 0.0,0.0,1.0,-1.0
w: //ints to load for pow and fac
	.xword 0,0

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

	//******** * * * * ********
	//fair warning, cosine is probably a mess
	//******** * * * * ********

pow: //returns float
	LDUR D0, [X0, #0] //num to be multiplied
	LDR X1, [X10, #0] //exponent
	ADD X1, X1, #1
	LDUR D1, [X0, #8] //sum = 0.0
	ADD X2, XZR, XZR //i = 0
	pow_for:
		SUB X3, X2, X1 //X3 = i - exp
		CBZ X3, pow_Exit //exit when X5 = 0

		CMP X2, #0 //if i == 0
		B.NE else
			LDUR D2, [X0, #16] //1.0
			FADD D1, D1, D2 //sum = sum + 1.0
			B end
		else:
			FMUL D1, D1, D0 //sum = sum * num
		end:
	ADD X2, X2, #1 //i++
	B pow_for
pow_Exit:
	BR X30


factor: //returns int
	LDR X1, [X10, #8] //num to be factorial-ed
	MOV X4, #1 //sum = 1
	MOV X2, #1 //i = 1
	fac_for:
		SUB X3, X2, X1 //X3 = i - num
		SUB X3, X3, #1
		CBZ X3, fac_Exit //exit when X5 = 0

		CMP X1, #0 //if num == 0
		B.NE elsef
			B fac_Exit
		elsef:
			MUL X4, X4, X2 //sum = sum * i
		endf:
	ADD X2, X2, #1 //i++
	B fac_for
fac_Exit:
	BR X30


cosine:
	//for (int n = 0; n <= a; n++)
	//	find 2n
	//	find (-1)^n
	//	find x^(2n)
	//	find (2n)!
	//	find (-1)^n * x^(2n)
	// 	find (-1)^n * x^(2n) / (2n)!
	ADRP X0, v //address of v
	ADD X0, X0, :lo12:v
	ADRP X6, x //address of x
	ADD X6, X6, :lo12:x
	ADRP X15, a //address of a
	ADD X15, X15, :lo12:a
	ADRP X10, w //address of w
	ADD X10, X10, :lo12:w
	LDUR X5, [X15, #0]
	ADD X5, X5, #1 //make it just one bigger, a+1
	LDUR D3, [X6, #0] //load double x

	ADRP X11, y
	ADD X11, X11, :lo12:y //get y address
	ADRP X12, b
	ADD X12, X12, :lo12:b //get b address

	LDUR D4, [X0, #8] //sum = 0.0
	LDUR D8, [X0, #8]
	ADD X7, XZR, XZR //n = 0
	ADD X4, XZR, XZR
	cosine_for:
		SUB X8, X7, X5 //X8 = n - (n+1)
		CBZ X8, resume //exit when X8 = 0

		FMOV D6, XZR //set temp to 0
		MOV X13, #2 //it's the number 2
		MUL X9, X7, X13 //2n

		LDUR D7, [X0, #24] //it's the number -1.0
		STUR D7, [X0, #0] //store -1.0 as pow float
		STUR X7, [X10, #0] //store n as pow exp
		BL pow
		CBNZ X7, v1
		LDUR D1, [X0, #16]
		v1:
		STUR D1, [X11, #0] //store return in y[0]
		LDUR D7, [X0, #8] //be 0.0 for a sec
		ADD D5, D1, D7 //make copy of return to use later

		STUR D3, [X0, #0] //store x as pow float
		STUR X9, [X10, #0] //store 2n as pow exp
		BL pow
		CBNZ X7, v2
		LDUR D1, [X0, #16]
		v2:
		STUR D1, [X11, #8] //store return in y[1]

		STUR X9, [X10, #8] //store 2n as fac num
		BL factor
		STUR X4, [X12, #0] //store return in b[0]

		FMUL D6, D5, D1 //(-1)^n * x^(2n)
		SCVTF D8, X4 //convert fac return to float
		FDIV D6, D6, D8 //divide by (2n)!

		FADD D4, D4, D6 //add temp to sum

	ADD X7, X7, #1 //n++
	B cosine_for


main:
	ADRP X14, z //address of z
	ADD X14, X14, :lo12:z

	B cosine

	resume:
	STUR D4, [X14, #0] //store result in z

Exit:
