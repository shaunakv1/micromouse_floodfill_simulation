
;CodeVisionAVR C Compiler V2.03.8a Evaluation
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _l_overflow=R5
	.DEF _r_overflow=R4
	.DEF _l_step=R7
	.DEF _r_step=R6
	.DEF _x=R9
	.DEF _y=R8
	.DEF _z=R11
	.DEF _rightMotorOn=R12
	.DEF _MOTOR_DELAY=R10

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0xCC,0x66,0x33,0x99
_0x4:
	.DB  0x99,0x33,0x66,0xCC
_0x33:
	.DB  0x1E

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _step
	.DW  _0x3*2

	.DW  0x04
	.DW  _step_rev
	.DW  _0x4*2

	.DW  0x01
	.DW  0x0A
	.DW  _0x33*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.8a Evaluation
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : NewBoardWithMiniStepper
;Version :
;Date    : 1/7/2009
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 16.000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#define ADC_DELAY 40
;#define TRUE 1
;#define FALSE 0
;#define SHOW_DISPLAY FALSE
;#define ACC_FACTOR 100
;#define SENSOR_TYPE 0
;#define CORRECT_ERROR TRUE
;unsigned char step[4]={0xCC,0x66,0x33,0x99};

	.DSEG
;unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
;unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z;
;unsigned rightMotorOn;
;unsigned leftMotorOn;
;unsigned int left,right,center;
;int error,error0;
;
;unsigned char MOTOR_DELAY=30;
;unsigned char ADC_CENTER;
;
;
;void read(void);
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0031 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0032    //right motor
; 0000 0033    y++;
	INC  R8
; 0000 0034    if(y>r_overflow && rightMotorOn)
	CP   R4,R8
	BRSH _0x6
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x7
_0x6:
	RJMP _0x5
_0x7:
; 0000 0035    {
; 0000 0036     y=0;
	CLR  R8
; 0000 0037     PORTB=step_rev[r_step];
	RCALL SUBOPT_0x0
; 0000 0038     r_step++;
; 0000 0039     if(r_step>3)r_step=0;
	BRSH _0x8
	CLR  R6
; 0000 003A    }
_0x8:
; 0000 003B 
; 0000 003C    //left motor
; 0000 003D    x++;
_0x5:
	INC  R9
; 0000 003E    if(x>l_overflow && leftMotorOn)
	CP   R5,R9
	BRSH _0xA
	LDS  R30,_leftMotorOn
	LDS  R31,_leftMotorOn+1
	SBIW R30,0
	BRNE _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 003F    {
; 0000 0040     x=0;
	CLR  R9
; 0000 0041     PORTD=step_rev[l_step];
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
	RCALL SUBOPT_0x2
; 0000 0042     l_step++;
; 0000 0043     if(l_step > 3)l_step = 0;
	BRSH _0xC
	CLR  R7
; 0000 0044    }
_0xC:
; 0000 0045 
; 0000 0046    //acceleration code
; 0000 0047 //  accCounter++;
; 0000 0048 //   if(accCounter>ACC_FACTOR)
; 0000 0049 //   {
; 0000 004A //     accCounter=0;
; 0000 004B //       if(MOTOR_DELAY>20)
; 0000 004C //       MOTOR_DELAY--;
; 0000 004D //   }
; 0000 004E 
; 0000 004F 
; 0000 0050 }
_0x9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
;
;// Timer 2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0054 {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0055 // Place your code here
; 0000 0056    //read sensor
; 0000 0057    z++;
	INC  R11
; 0000 0058    if(z>ADC_DELAY)
	LDI  R30,LOW(40)
	CP   R30,R11
	BRLO PC+2
	RJMP _0xD
; 0000 0059    {
; 0000 005A    z=0;
	CLR  R11
; 0000 005B    read();
	RCALL _read
; 0000 005C    //error correction
; 0000 005D    error0=error;
	LDS  R30,_error
	LDS  R31,_error+1
	STS  _error0,R30
	STS  _error0+1,R31
; 0000 005E    if(left < 15 )
	RCALL SUBOPT_0x3
	SBIW R26,15
	BRSH _0xE
; 0000 005F         {
; 0000 0060          error = ADC_CENTER-right;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0061          ADC_CENTER=(ADC_CENTER+right)/2;
	RCALL SUBOPT_0x4
	RJMP _0x31
; 0000 0062         }
; 0000 0063    else if(right < 15)
_0xE:
	RCALL SUBOPT_0x6
	SBIW R26,15
	BRSH _0x10
; 0000 0064         {
; 0000 0065          error = left-ADC_CENTER;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x8
	STS  _error,R26
	STS  _error+1,R27
; 0000 0066          ADC_CENTER=(left+ADC_CENTER)/2;
	RCALL SUBOPT_0x7
	RJMP _0x32
; 0000 0067         }
; 0000 0068    else
_0x10:
; 0000 0069         {
; 0000 006A          error = left-right;
	RCALL SUBOPT_0x6
	LDS  R30,_left
	LDS  R31,_left+1
	RCALL SUBOPT_0x5
; 0000 006B          ADC_CENTER=(left+right)/2;
	LDS  R30,_right
	LDS  R31,_right+1
_0x32:
	LDS  R26,_left
	LDS  R27,_left+1
_0x31:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	STS  _ADC_CENTER,R30
; 0000 006C         }
; 0000 006D 
; 0000 006E    if(CORRECT_ERROR)
; 0000 006F    {
; 0000 0070         if(error>0)r_overflow=MOTOR_DELAY+(error/8);//+(error-error0)/8;
	RCALL SUBOPT_0x9
	RCALL __CPW02
	BRGE _0x13
	RCALL SUBOPT_0xA
	MOVW R26,R22
	ADD  R30,R26
	MOV  R4,R30
; 0000 0071         else if(error<0)l_overflow=MOTOR_DELAY-(error/8);//+(error-error0)/8;
	RJMP _0x14
_0x13:
	LDS  R26,_error+1
	TST  R26
	BRPL _0x15
	RCALL SUBOPT_0xA
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	MOV  R5,R30
; 0000 0072    }
_0x15:
_0x14:
; 0000 0073 //
; 0000 0074 //    if(error>0)r_overflow=MOTOR_DELAY+((error*r_overflow)/40);
; 0000 0075 //   else if(error<0)l_overflow=MOTOR_DELAY-((error*l_overflow)/40);
; 0000 0076         if(SHOW_DISPLAY)
; 0000 0077         {
; 0000 0078         //show(right,0,0);
; 0000 0079         //show(left,10,0);
; 0000 007A         //show(center,5,0);
; 0000 007B         }
; 0000 007C    }
; 0000 007D }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0xE0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0086 {
_read_adc:
; 0000 0087 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 0088 // Delay needed for the stabilization of the ADC input voltage
; 0000 0089 delay_us(10);
	__DELAY_USB 53
; 0000 008A // Start the AD conversion
; 0000 008B ADCSRA|=0x40;
	SBI  0x6,6
; 0000 008C // Wait for the AD conversion to complete
; 0000 008D while ((ADCSRA & 0x10)==0);
_0x17:
	SBIS 0x6,4
	RJMP _0x17
; 0000 008E ADCSRA|=0x10;
	SBI  0x6,4
; 0000 008F return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0090 }
;
; void initialize(void)
; 0000 0093 {
_initialize:
; 0000 0094  x=0;
	CLR  R9
; 0000 0095  y=0;
	CLR  R8
; 0000 0096  z=0;
	CLR  R11
; 0000 0097  l_step=0;
	CLR  R7
; 0000 0098  r_step=0;
	CLR  R6
; 0000 0099  l_overflow=MOTOR_DELAY;
	MOV  R5,R10
; 0000 009A  r_overflow=MOTOR_DELAY;
	MOV  R4,R10
; 0000 009B  rightMotorOn=1;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 009C  leftMotorOn=1;
; 0000 009D }
	RET
;//void read(void)
;//{
;// unsigned char i;
;// left=0;
;// center=0;
;// right=0;
;// for(i=0;i<2;i++)
;// {
;// PORTA=PINA|(1<<0);
;// left+=read_adc(3);
;// PORTA=PINA&(~(1<<0));
;// delay_us(7);
;// }
;//for(i=0;i<2;i++)
;// {
;// PORTA=PINA|(1<<1);
;// right+=read_adc(4);
;// PORTA=PINA&(~(1<<1));
;// delay_us(7);
;// }
;//for(i=0;i<2;i++)
;// {
;// PORTA=PINA|(1<<2);
;// center+=read_adc(5);
;// PORTA=PINA&(~(1<<2));
;// delay_us(7);
;// }
;//left/=2;
;//right/=2;
;//center/=2;
;//}
;
;void read(void)
; 0000 00BF {
_read:
; 0000 00C0  unsigned char i,lo,co,ro;
; 0000 00C1  left=0;
	RCALL __SAVELOCR4
;	i -> R17
;	lo -> R16
;	co -> R19
;	ro -> R18
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00C2  center=0;
	STS  _center,R30
	STS  _center+1,R30
; 0000 00C3  right=0;
	STS  _right,R30
	STS  _right+1,R30
; 0000 00C4 
; 0000 00C5  lo=0;
	LDI  R16,LOW(0)
; 0000 00C6  co=0;
	LDI  R19,LOW(0)
; 0000 00C7  ro=0;
	LDI  R18,LOW(0)
; 0000 00C8  if(SENSOR_TYPE==0)
; 0000 00C9  {
; 0000 00CA         lo=read_adc(3);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xD
	MOV  R16,R30
; 0000 00CB         PORTC=PINC|(1<<0);
	IN   R30,0x13
	ORI  R30,1
	OUT  0x15,R30
; 0000 00CC         left=read_adc(3);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	STS  _left,R30
	STS  _left+1,R31
; 0000 00CD         PORTC=PINC&(~(1<<0));
	IN   R30,0x13
	ANDI R30,0xFE
	OUT  0x15,R30
; 0000 00CE         left=left-lo;
	MOV  R30,R16
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x8
	STS  _left,R26
	STS  _left+1,R27
; 0000 00CF         delay_us(7);
	RCALL SUBOPT_0xF
; 0000 00D0 
; 0000 00D1         ro=read_adc(4);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xD
	MOV  R18,R30
; 0000 00D2         PORTC=PINC|(1<<1);
	IN   R30,0x13
	ORI  R30,2
	OUT  0x15,R30
; 0000 00D3         right=read_adc(4);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	STS  _right,R30
	STS  _right+1,R31
; 0000 00D4         PORTC=PINC&(~(1<<1));
	IN   R30,0x13
	ANDI R30,0xFD
	OUT  0x15,R30
; 0000 00D5         right=right-ro;
	MOV  R30,R18
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x8
	STS  _right,R26
	STS  _right+1,R27
; 0000 00D6         delay_us(7);
	RCALL SUBOPT_0xF
; 0000 00D7 
; 0000 00D8         co=read_adc(5);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xD
	MOV  R19,R30
; 0000 00D9         PORTC=PINC|(1<<2);
	IN   R30,0x13
	ORI  R30,4
	OUT  0x15,R30
; 0000 00DA         center=read_adc(5);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	STS  _center,R30
	STS  _center+1,R31
; 0000 00DB         PORTC=PINC&(~(1<<2));
	IN   R30,0x13
	ANDI R30,0xFB
	OUT  0x15,R30
; 0000 00DC         center=center-co;
	MOV  R30,R19
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x8
	STS  _center,R26
	STS  _center+1,R27
; 0000 00DD         delay_us(7);
	RCALL SUBOPT_0xF
; 0000 00DE  }
; 0000 00DF   if(SENSOR_TYPE==1)
; 0000 00E0   {
; 0000 00E1         left=read_adc(3);
; 0000 00E2         center=read_adc(4);
; 0000 00E3         right=read_adc(5);
; 0000 00E4   }
; 0000 00E5   if(SENSOR_TYPE==2)
; 0000 00E6   {
; 0000 00E7       co=read_adc(2);//front right
; 0000 00E8       right=read_adc(3);//right
; 0000 00E9       left=read_adc(4);//left
; 0000 00EA       center=(read_adc(5)+co)/2;//front left
; 0000 00EB   }
; 0000 00EC }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;
;void turnBack(void)
; 0000 00F1 {
; 0000 00F2     unsigned char i;
; 0000 00F3     rightMotorOn=0;
;	i -> R17
; 0000 00F4           leftMotorOn=0;
; 0000 00F5 
; 0000 00F6     for(i=0;i<150;i++)
; 0000 00F7     {
; 0000 00F8 
; 0000 00F9     PORTB=step[r_step];
; 0000 00FA     r_step++;
; 0000 00FB     if(r_step>3)r_step=0;
; 0000 00FC 
; 0000 00FD     PORTD=step_rev[l_step];
; 0000 00FE     l_step++;
; 0000 00FF     if(l_step > 3)l_step = 0;
; 0000 0100 
; 0000 0101         delay_ms(4);
; 0000 0102     }
; 0000 0103     rightMotorOn=1;
; 0000 0104     leftMotorOn=1;
; 0000 0105 }
;void turnRight(void)
; 0000 0107 {
_turnRight:
; 0000 0108         unsigned char i;
; 0000 0109 
; 0000 010A     rightMotorOn=0;
	ST   -Y,R17
;	i -> R17
	CLR  R12
	CLR  R13
; 0000 010B           leftMotorOn=0;
	LDI  R30,LOW(0)
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R30
; 0000 010C 
; 0000 010D     for(i=0;i<75;i++)
	LDI  R17,LOW(0)
_0x23:
	CPI  R17,75
	BRSH _0x24
; 0000 010E     {
; 0000 010F 
; 0000 0110     PORTB=step_rev[r_step];
	RCALL SUBOPT_0x0
; 0000 0111     r_step++;
; 0000 0112     if(r_step>3)r_step=0;
	BRSH _0x25
	CLR  R6
; 0000 0113 
; 0000 0114     PORTD=step[l_step];
_0x25:
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	RCALL SUBOPT_0x2
; 0000 0115     l_step++;
; 0000 0116     if(l_step > 3)l_step = 0;
	BRSH _0x26
	CLR  R7
; 0000 0117 
; 0000 0118         delay_ms(2);
_0x26:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0119     }
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 011A     rightMotorOn=1;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 011B     leftMotorOn=1;
; 0000 011C }
	LD   R17,Y+
	RET
;
;void turnLeft(void)
; 0000 011F {
; 0000 0120     unsigned char i;
; 0000 0121     rightMotorOn=0;
;	i -> R17
; 0000 0122           leftMotorOn=0;
; 0000 0123 
; 0000 0124 
; 0000 0125     for(i=0;i<75;i++)
; 0000 0126     {
; 0000 0127 
; 0000 0128     PORTB=step[r_step];
; 0000 0129     r_step++;
; 0000 012A     if(r_step>3)r_step=0;
; 0000 012B 
; 0000 012C     PORTD=step_rev[l_step];
; 0000 012D     l_step++;
; 0000 012E     if(l_step > 3)l_step = 0;
; 0000 012F 
; 0000 0130         delay_ms(4);
; 0000 0131     }
; 0000 0132 
; 0000 0133     rightMotorOn=1;
; 0000 0134     leftMotorOn=1;
; 0000 0135 
; 0000 0136 }
;// Declare your global variables here
;
;void main(void)
; 0000 013A {
_main:
; 0000 013B // Declare your local variables here
; 0000 013C 
; 0000 013D // Input/Output Ports initialization
; 0000 013E // Port B initialization
; 0000 013F // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0140 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0141 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0142 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0143 
; 0000 0144 // Port C initialization
; 0000 0145 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0146 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0147 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0148 DDRC=0x00;
	OUT  0x14,R30
; 0000 0149 
; 0000 014A // Port D initialization
; 0000 014B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 014C // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 014D PORTD=0x00;
	OUT  0x12,R30
; 0000 014E DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 014F   initialize();
	RCALL _initialize
; 0000 0150 // Timer/Counter 0 initialization
; 0000 0151 // Clock source: System Clock
; 0000 0152 // Clock value: 2000.000 kHz
; 0000 0153 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0154 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0155 
; 0000 0156 // Timer/Counter 1 initialization
; 0000 0157 // Clock source: System Clock
; 0000 0158 // Clock value: Timer 1 Stopped
; 0000 0159 // Mode: Normal top=FFFFh
; 0000 015A // OC1A output: Discon.
; 0000 015B // OC1B output: Discon.
; 0000 015C // Noise Canceler: Off
; 0000 015D // Input Capture on Falling Edge
; 0000 015E // Timer 1 Overflow Interrupt: Off
; 0000 015F // Input Capture Interrupt: Off
; 0000 0160 // Compare A Match Interrupt: Off
; 0000 0161 // Compare B Match Interrupt: Off
; 0000 0162 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0163 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0164 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0165 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0166 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0167 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0168 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0169 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 016A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 016B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 016C 
; 0000 016D // Timer/Counter 2 initialization
; 0000 016E // Clock source: System Clock
; 0000 016F // Clock value: 2000.000 kHz
; 0000 0170 // Mode: Normal top=FFh
; 0000 0171 // OC2 output: Disconnected
; 0000 0172 ASSR=0x00;
	OUT  0x22,R30
; 0000 0173 TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 0174 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0175 OCR2=0x00;
	OUT  0x23,R30
; 0000 0176 
; 0000 0177 // External Interrupt(s) initialization
; 0000 0178 // INT0: Off
; 0000 0179 // INT1: Off
; 0000 017A MCUCR=0x00;
	OUT  0x35,R30
; 0000 017B 
; 0000 017C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 017D TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 017E 
; 0000 017F // Analog Comparator initialization
; 0000 0180 // Analog Comparator: Off
; 0000 0181 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0182 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0183 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0184 
; 0000 0185 // ADC initialization
; 0000 0186 // ADC Clock frequency: 125.000 kHz
; 0000 0187 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0188 // Only the 8 most significant bits of
; 0000 0189 // the AD conversion result are used
; 0000 018A ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 018B ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 018C 
; 0000 018D // Global enable interrupts
; 0000 018E #asm("sei")
	sei
; 0000 018F 
; 0000 0190 while (1)
_0x2C:
; 0000 0191       {
; 0000 0192       // Place your code here
; 0000 0193           if(center>90)
	RCALL SUBOPT_0x10
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLO _0x2F
; 0000 0194         turnRight();
	RCALL _turnRight
; 0000 0195       };
_0x2F:
	RJMP _0x2C
; 0000 0196 }
_0x30:
	RJMP _0x30

	.DSEG
_step:
	.BYTE 0x4
_step_rev:
	.BYTE 0x4
_leftMotorOn:
	.BYTE 0x2
_left:
	.BYTE 0x2
_right:
	.BYTE 0x2
_center:
	.BYTE 0x2
_error:
	.BYTE 0x2
_error0:
	.BYTE 0x2
_ADC_CENTER:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
	LD   R30,Z
	OUT  0x18,R30
	INC  R6
	LDI  R30,LOW(3)
	CP   R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LD   R30,Z
	OUT  0x12,R30
	INC  R7
	LDI  R30,LOW(3)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDS  R26,_left
	LDS  R27,_left+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	LDS  R26,_right
	LDS  R27,_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDS  R26,_right
	LDS  R27,_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDS  R26,_error
	LDS  R27,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	MOV  R22,R10
	CLR  R23
	RCALL SUBOPT_0x9
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOVW R12,R30
	RCALL SUBOPT_0xB
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	RJMP _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	__DELAY_USB 37
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDS  R26,_center
	LDS  R27,_center+1
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
