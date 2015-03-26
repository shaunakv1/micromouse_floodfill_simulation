
;CodeVisionAVR C Compiler V2.03.8a Evaluation
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0xCC,0x66,0x33,0x99
_0x4:
	.DB  0x99,0x33,0x66,0xCC
_0x5:
	.DB  0x69
_0x2D:
	.DB  0x96
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _step
	.DW  _0x3*2

	.DW  0x04
	.DW  _step_rev
	.DW  _0x4*2

	.DW  0x01
	.DW  _ADC_CENTER
	.DW  _0x5*2

	.DW  0x01
	.DW  0x0A
	.DW  _0x2D*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
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
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.8a Evaluation
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/17/2009
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 16.000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 512
;*****************************************************/
;
;#include <mega32.h>
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
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 001D #endasm
;#include <lcd.h>
;#define ADC_DELAY 40
;#define TRUE 1
;#define FALSE 0
;#define SHOW_DISPLAY TRUE
;#define ACC_FACTOR 5
;#define SENSOR_TYPE 1
;unsigned char step[4]={0xCC,0x66,0x33,0x99};

	.DSEG
;unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
;unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z;
;unsigned rightMotorOn;
;unsigned leftMotorOn;
;unsigned int left,right,center;
;int error,error0;
;
;unsigned char MOTOR_DELAY=150;
;unsigned char ADC_CENTER=105;
;
;
;void read(void);
;void show(unsigned int ,unsigned char , unsigned char );
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 0035 {

	.CSEG
_timer0_comp_isr:
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 // Place your code here
; 0000 0037 if(rightMotorOn)
	MOV  R0,R12
	OR   R0,R13
	BREQ _0x6
; 0000 0038 {
; 0000 0039 PORTB=step[r_step];
	CALL SUBOPT_0x0
; 0000 003A r_step++;
; 0000 003B if(r_step>3)r_step=0;
	BRSH _0x7
	CLR  R6
; 0000 003C }
_0x7:
; 0000 003D }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
; // Timer 2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 0040 {
_timer2_comp_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 //Place your code here
; 0000 0042 if(leftMotorOn)
	LDS  R30,_leftMotorOn
	LDS  R31,_leftMotorOn+1
	SBIW R30,0
	BREQ _0x8
; 0000 0043 {
; 0000 0044 PORTD=step[l_step];
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	LD   R30,Z
	OUT  0x12,R30
; 0000 0045 PORTC.0=~PINC.0;
	SBIS 0x13,0
	RJMP _0x9
	CBI  0x15,0
	RJMP _0xA
_0x9:
	SBI  0x15,0
_0xA:
; 0000 0046 l_step++;
	INC  R7
; 0000 0047 if(l_step>3)l_step=0;
	LDI  R30,LOW(3)
	CP   R30,R7
	BRSH _0xB
	CLR  R7
; 0000 0048 }
_0xB:
; 0000 0049 }
_0x8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 004C {
_timer1_compa_isr:
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
; 0000 004D  // Place your code here
; 0000 004E    //read sensor
; 0000 004F    z++;
	INC  R11
; 0000 0050    if(z>ADC_DELAY)
	LDI  R30,LOW(40)
	CP   R30,R11
	BRLO PC+3
	JMP _0xC
; 0000 0051    {
; 0000 0052    z=0;
	CLR  R11
; 0000 0053    read();
	RCALL _read
; 0000 0054    //error correction
; 0000 0055    error0=error;
	CALL SUBOPT_0x1
	STS  _error0,R30
	STS  _error0+1,R31
; 0000 0056    if(left < 5 )
	LDS  R26,_left
	LDS  R27,_left+1
	SBIW R26,5
	BRSH _0xD
; 0000 0057         {
; 0000 0058          error = ADC_CENTER-right;
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	CALL SUBOPT_0x2
	RJMP _0x2C
; 0000 0059         // ADC_CENTER=(ADC_CENTER+right)/2;
; 0000 005A         }
; 0000 005B    else if(right < 5)
_0xD:
	CALL SUBOPT_0x2
	SBIW R26,5
	BRSH _0xF
; 0000 005C         {
; 0000 005D          error = left-ADC_CENTER;
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	LDS  R26,_left
	LDS  R27,_left+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _error,R26
	STS  _error+1,R27
; 0000 005E          //ADC_CENTER=(left+ADC_CENTER)/2;
; 0000 005F         }
; 0000 0060    else
	RJMP _0x10
_0xF:
; 0000 0061         {
; 0000 0062          error = left-right;
	CALL SUBOPT_0x2
	LDS  R30,_left
	LDS  R31,_left+1
_0x2C:
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
; 0000 0063          //ADC_CENTER=(left+right)/2;
; 0000 0064         }
_0x10:
; 0000 0065 
; 0000 0066 
; 0000 0067 
; 0000 0068    //if(error>0)
; 0000 0069    OCR2=MOTOR_DELAY-((error/16)+(error-error0)*2);
	CALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	OUT  0x23,R30
; 0000 006A    //else if(error<0)
; 0000 006B 
; 0000 006C    OCR0=MOTOR_DELAY+((error/16)+(error-error0)*2);
	CALL SUBOPT_0x3
	ADD  R30,R22
	ADC  R31,R23
	OUT  0x3C,R30
; 0000 006D //
; 0000 006E //    if(error>0)r_overflow=MOTOR_DELAY+((error*r_overflow)/40);
; 0000 006F //   else if(error<0)l_overflow=MOTOR_DELAY-((error*l_overflow)/40);
; 0000 0070         if(SHOW_DISPLAY)
; 0000 0071         {
; 0000 0072 
; 0000 0073          //putchar(left);
; 0000 0074          //putchar(center);
; 0000 0075          //putchar(right);
; 0000 0076          //show(right,0,0);
; 0000 0077          //show(left,10,0);
; 0000 0078          //show(center,5,0);
; 0000 0079         }
; 0000 007A    }
; 0000 007B // Place your code here
; 0000 007C 
; 0000 007D }
_0xC:
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
;
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0xE0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0088 {
_read_adc:
; 0000 0089 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 008A // Delay needed for the stabilization of the ADC input voltage
; 0000 008B delay_us(10);
	__DELAY_USB 53
; 0000 008C // Start the AD conversion
; 0000 008D ADCSRA|=0x40;
	SBI  0x6,6
; 0000 008E // Wait for the AD conversion to complete
; 0000 008F while ((ADCSRA & 0x10)==0);
_0x12:
	SBIS 0x6,4
	RJMP _0x12
; 0000 0090 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0091 return ADCH;
	IN   R30,0x5
	JMP  _0x2020001
; 0000 0092 }
;
;void initialize(void)
; 0000 0095 {
_initialize:
; 0000 0096  x=0;
	CLR  R9
; 0000 0097  y=0;
	CLR  R8
; 0000 0098  z=0;
	CLR  R11
; 0000 0099  l_step=0;
	CLR  R7
; 0000 009A  r_step=0;
	CLR  R6
; 0000 009B  l_overflow=MOTOR_DELAY;
	MOV  R5,R10
; 0000 009C  r_overflow=MOTOR_DELAY;
	MOV  R4,R10
; 0000 009D  rightMotorOn=1;
	CALL SUBOPT_0x4
; 0000 009E  leftMotorOn=1;
; 0000 009F }
	RET
;
;void read(void)
; 0000 00A2 {
_read:
; 0000 00A3  unsigned char i,lo,co,ro;
; 0000 00A4  left=0;
	CALL __SAVELOCR4
;	i -> R17
;	lo -> R16
;	co -> R19
;	ro -> R18
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00A5  center=0;
	STS  _center,R30
	STS  _center+1,R30
; 0000 00A6  right=0;
	STS  _right,R30
	STS  _right+1,R30
; 0000 00A7 
; 0000 00A8  lo=0;
	LDI  R16,LOW(0)
; 0000 00A9  co=0;
	LDI  R19,LOW(0)
; 0000 00AA  ro=0;
	LDI  R18,LOW(0)
; 0000 00AB  //putchar(0xFF);
; 0000 00AC  if(SENSOR_TYPE==0)
; 0000 00AD  {
; 0000 00AE         lo=read_adc(3);
; 0000 00AF         PORTA=PINA|(1<<0);
; 0000 00B0         left=read_adc(3);
; 0000 00B1         PORTA=PINA&(~(1<<0));
; 0000 00B2         left=left-lo;
; 0000 00B3         delay_us(7);
; 0000 00B4 
; 0000 00B5         ro=read_adc(4);
; 0000 00B6         PORTA=PINA|(1<<1);
; 0000 00B7         right=read_adc(4);
; 0000 00B8         PORTA=PINA&(~(1<<1));
; 0000 00B9         right=right-ro;
; 0000 00BA         delay_us(7);
; 0000 00BB 
; 0000 00BC         co=read_adc(5);
; 0000 00BD         PORTA=PINA|(1<<2);
; 0000 00BE         center=read_adc(5);
; 0000 00BF         PORTA=PINA&(~(1<<2));
; 0000 00C0         center=center-co;
; 0000 00C1         delay_us(7);
; 0000 00C2  }
; 0000 00C3   if(SENSOR_TYPE==1)
; 0000 00C4   {
; 0000 00C5         left=read_adc(5);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
	STS  _left,R30
	STS  _left+1,R31
; 0000 00C6         center=read_adc(6);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
	STS  _center,R30
	STS  _center+1,R31
; 0000 00C7         right=read_adc(7);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5
	STS  _right,R30
	STS  _right+1,R31
; 0000 00C8   }
; 0000 00C9   if(SENSOR_TYPE==2)
; 0000 00CA   {
; 0000 00CB       co=read_adc(2);//front right
; 0000 00CC       right=read_adc(3);//right
; 0000 00CD       left=read_adc(4);//left
; 0000 00CE       center=(read_adc(5)+co)/2;//front left
; 0000 00CF   }
; 0000 00D0 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void show(unsigned int val,unsigned char xx, unsigned char yy)
; 0000 00D3 {
; 0000 00D4  unsigned char a,b,c;
; 0000 00D5  lcd_gotoxy(xx,yy);
;	val -> Y+6
;	xx -> Y+5
;	yy -> Y+4
;	a -> R17
;	b -> R16
;	c -> R19
; 0000 00D6  a=(val%10)+48;
; 0000 00D7  val/=10;
; 0000 00D8  b=(val%10)+48;
; 0000 00D9  val/=10;
; 0000 00DA  c=(val%10)+48;
; 0000 00DB // val/=10;
; 0000 00DC // d=(val%10)+48;
; 0000 00DD // lcd_putchar(d);
; 0000 00DE  lcd_putchar(c);
; 0000 00DF  lcd_putchar(b);
; 0000 00E0  lcd_putchar(a);
; 0000 00E1 
; 0000 00E2 }
;
;void turnBack(void)
; 0000 00E5 {
_turnBack:
; 0000 00E6     unsigned char i;
; 0000 00E7     rightMotorOn=0;
	ST   -Y,R17
;	i -> R17
	CLR  R12
	CLR  R13
; 0000 00E8           leftMotorOn=0;
	LDI  R30,LOW(0)
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R30
; 0000 00E9     delay_ms(10);
	CALL SUBOPT_0x6
; 0000 00EA     for(i=0;i<45;i++)//45 for fast    150 for slow
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,45
	BRSH _0x1A
; 0000 00EB     {
; 0000 00EC 
; 0000 00ED     PORTB=step[r_step];
	CALL SUBOPT_0x0
; 0000 00EE     r_step++;
; 0000 00EF     if(r_step>3)r_step=0;
	BRSH _0x1B
	CLR  R6
; 0000 00F0 
; 0000 00F1     PORTD=step_rev[l_step];
_0x1B:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
	LD   R30,Z
	OUT  0x12,R30
; 0000 00F2     l_step++;
	INC  R7
; 0000 00F3     if(l_step > 3)l_step = 0;
	LDI  R30,LOW(3)
	CP   R30,R7
	BRSH _0x1C
	CLR  R7
; 0000 00F4 
; 0000 00F5         delay_ms(8);
_0x1C:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00F6     }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00F7     delay_ms(10);
	CALL SUBOPT_0x6
; 0000 00F8     rightMotorOn=1;
	CALL SUBOPT_0x4
; 0000 00F9     leftMotorOn=1;
; 0000 00FA }
	LD   R17,Y+
	RET
;void turnRight(void)
; 0000 00FC {
; 0000 00FD         unsigned char i;
; 0000 00FE 
; 0000 00FF     rightMotorOn=0;
;	i -> R17
; 0000 0100           leftMotorOn=0;
; 0000 0101 
; 0000 0102     for(i=0;i<75;i++)
; 0000 0103     {
; 0000 0104 
; 0000 0105     PORTB=step_rev[r_step];
; 0000 0106     r_step++;
; 0000 0107     if(r_step>3)r_step=0;
; 0000 0108 
; 0000 0109     PORTD=step[l_step];
; 0000 010A     l_step++;
; 0000 010B     if(l_step > 3)l_step = 0;
; 0000 010C 
; 0000 010D         delay_ms(4);
; 0000 010E     }
; 0000 010F     rightMotorOn=1;
; 0000 0110     leftMotorOn=1;
; 0000 0111 }
;
;void turnLeft(void)
; 0000 0114 {
; 0000 0115 
; 0000 0116     unsigned char i;
; 0000 0117     rightMotorOn=0;
;	i -> R17
; 0000 0118           leftMotorOn=0;
; 0000 0119 
; 0000 011A 
; 0000 011B     for(i=0;i<75;i++)
; 0000 011C     {
; 0000 011D 
; 0000 011E     PORTB=step[r_step];
; 0000 011F     r_step++;
; 0000 0120     if(r_step>3)r_step=0;
; 0000 0121 
; 0000 0122     PORTD=step_rev[l_step];
; 0000 0123     l_step++;
; 0000 0124     if(l_step > 3)l_step = 0;
; 0000 0125 
; 0000 0126         delay_ms(4);
; 0000 0127     }
; 0000 0128 
; 0000 0129     rightMotorOn=1;
; 0000 012A     leftMotorOn=1;
; 0000 012B 
; 0000 012C }
;
;// Declare your global variables here
;// Declare your global variables here
;
;void main(void)
; 0000 0132 {
_main:
; 0000 0133 // Declare your local variables here
; 0000 0134 
; 0000 0135 initialize();
	RCALL _initialize
; 0000 0136 
; 0000 0137 // Input/Output Ports initialization
; 0000 0138 // Port A initialization
; 0000 0139 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 013A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 013B PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 013C DDRA=0x00;
	OUT  0x1A,R30
; 0000 013D 
; 0000 013E // Port B initialization
; 0000 013F // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0140 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0141 PORTB=0x00;
	OUT  0x18,R30
; 0000 0142 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0143 
; 0000 0144 // Port C initialization
; 0000 0145 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0146 // State7=T State6=T State5=T State4=T State3=T State2=1 State1=1 State0=1
; 0000 0147 PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0148 DDRC=0xFF;
	OUT  0x14,R30
; 0000 0149 
; 0000 014A // Port D initialization
; 0000 014B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 014C // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 014D PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 014E DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 014F 
; 0000 0150 // Timer/Counter 0 initialization
; 0000 0151 // Clock source: System Clock
; 0000 0152 // Clock value: 15.625 kHz
; 0000 0153 // Mode: CTC top=OCR0
; 0000 0154 // OC0 output: Disconnected
; 0000 0155 TCCR0=0x0D;
	LDI  R30,LOW(13)
	OUT  0x33,R30
; 0000 0156 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0157 OCR0=150;
	LDI  R30,LOW(150)
	OUT  0x3C,R30
; 0000 0158 
; 0000 0159 
; 0000 015A // Timer/Counter 1 initialization
; 0000 015B // Clock source: System Clock
; 0000 015C // Clock value: 15.625 kHz
; 0000 015D // Mode: CTC top=OCR1A
; 0000 015E // OC1A output: Discon.
; 0000 015F // OC1B output: Discon.
; 0000 0160 // Noise Canceler: Off
; 0000 0161 // Input Capture on Falling Edge
; 0000 0162 // Timer 1 Overflow Interrupt: Off
; 0000 0163 // Input Capture Interrupt: Off
; 0000 0164 // Compare A Match Interrupt: On
; 0000 0165 // Compare B Match Interrupt: Off
; 0000 0166 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0167 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0168 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0169 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 016A ICR1H=0x00;
	OUT  0x27,R30
; 0000 016B ICR1L=0x00;
	OUT  0x26,R30
; 0000 016C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 016D OCR1AL=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2A,R30
; 0000 016E OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 016F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0170 
; 0000 0171 // Timer/Counter 2 initialization
; 0000 0172 // Clock source: System Clock
; 0000 0173 // Clock value: Timer 2 Stopped
; 0000 0174 // Mode: CTC top=OCR2
; 0000 0175 // OC2 output: Disconnected
; 0000 0176 ASSR=0x00;
	OUT  0x22,R30
; 0000 0177 TCCR2=0x0F;
	LDI  R30,LOW(15)
	OUT  0x25,R30
; 0000 0178 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0179 OCR2=150;
	LDI  R30,LOW(150)
	OUT  0x23,R30
; 0000 017A 
; 0000 017B // External Interrupt(s) initialization
; 0000 017C // INT0: Off
; 0000 017D // INT1: Off
; 0000 017E // INT2: Off
; 0000 017F MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0180 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0181 
; 0000 0182 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0183 TIMSK=0x92;
	LDI  R30,LOW(146)
	OUT  0x39,R30
; 0000 0184 
; 0000 0185 // Analog Comparator initialization
; 0000 0186 // Analog Comparator: Off
; 0000 0187 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0188 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0189 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 018A 
; 0000 018B // ADC initialization
; 0000 018C // ADC Clock frequency: 125.000 kHz
; 0000 018D // ADC Voltage Reference: Int., cap. on AREF
; 0000 018E // Only the 8 most significant bits of
; 0000 018F // the AD conversion result are used
; 0000 0190 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 0191 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0192 
; 0000 0193 // LCD module initialization
; 0000 0194 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0195 
; 0000 0196 // Global enable interrupts
; 0000 0197 #asm("sei")
	sei
; 0000 0198 PORTC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0199 while (1)
_0x27:
; 0000 019A       {
; 0000 019B       // Place your code here
; 0000 019C         if(center>30)
	LDS  R26,_center
	LDS  R27,_center+1
	SBIW R26,31
	BRLO _0x2A
; 0000 019D          {
; 0000 019E           //turnRight();
; 0000 019F           //turnRight();
; 0000 01A0           turnBack();
	RCALL _turnBack
; 0000 01A1            //rightMotorOn=0;
; 0000 01A2            //leftMotorOn=0;
; 0000 01A3          }
; 0000 01A4       };
_0x2A:
	RJMP _0x27
; 0000 01A5 }
_0x2B:
	RJMP _0x2B
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G100:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2020001
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
__long_delay_G100:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G100:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	LDI  R31,0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x8
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

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
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	LD   R30,Z
	OUT  0x18,R30
	INC  R6
	LDI  R30,LOW(3)
	CP   R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_right
	LDS  R27,_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3:
	MOV  R22,R10
	CLR  R23
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __DIVW21
	MOVW R0,R30
	LDS  R26,_error0
	LDS  R27,_error0+1
	RCALL SUBOPT_0x1
	SUB  R30,R26
	SBC  R31,R27
	LSL  R30
	ROL  R31
	ADD  R30,R0
	ADC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	CALL _read_adc
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100


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
