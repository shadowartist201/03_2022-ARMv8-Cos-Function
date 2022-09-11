# 03_2022-ARMv8-Cos-Function
Class project - cosine calculator in ARMv8 assembly


Things to pay attention to:

- x[0] = input data for x

- a[0] = input data for a

- z[0] = return value for cos(x)

- X6, address of x

- X5, address of a (overwritten during the cosine function)

- X14, address of z


Registers:


- X0, address of v

- X1, power exponent

- X2, int i = 0

- X3, int for() loop, power

- X4, return value for factor

- X5, a (and a+1)

- X6, address of x

- X7, n

- X8, int for() loop, cosine

- X9, 2n

- X10, address of w

- X11, address of y

- X12, address of b

- X13, int 2

- X14, address of z


- D0, power float

- D1, return value for power

- D2, double 1.0

- D3, x

- D4, return value for cosine

- D5, copy of pow return (used for (-1)^n))

- D6, temp for cosine calcs

- D7, double -1.0

- D8, return value for factorial, but float


.data:

- x[0] = input data for x

- a[0] = input data for a

- z[0] = return value for cos(x)


- y[0][1][2] = float fac return, temp, uhh

- b[0] = int fac return


- v[0][1][2][3] = power float, 0.0, 1.0, -1.0

- w[0][1] = power exponent, fac num
