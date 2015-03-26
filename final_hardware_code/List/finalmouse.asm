
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
	.DEF _accCounter=R10
	.DEF _dirR=R13
	.DEF _dirL=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0xCC,0x66,0x33,0x99
_0x4:
	.DB  0x99,0x33,0x66,0xCC
_0x5:
	.DB  0x1E
_0x5F:
	.DB  0xE,0xD,0xC,0xB,0xA,0x9,0x8,0x7
	.DB  0x7,0x8,0x9,0xA,0xB,0xC,0xD,0xE
	.DB  0xD,0xC,0xB,0xA,0x9,0x8,0x7,0x6
	.DB  0x6,0x7,0x8,0x9,0xA,0xB,0xC,0xD
	.DB  0xC,0xB,0xA,0x9,0x8,0x7,0x6,0x5
	.DB  0x5,0x6,0x7,0x8,0x9,0xA,0xB,0xC
	.DB  0xB,0xA,0x9,0x8,0x7,0x6,0x5,0x4
	.DB  0x4,0x5,0x6,0x7,0x8,0x9,0xA,0xB
	.DB  0xA,0x9,0x8,0x7,0x6,0x5,0x4,0x3
	.DB  0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xA
	.DB  0x9,0x8,0x7,0x6,0x5,0x4,0x3,0x2
	.DB  0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9
	.DB  0x8,0x7,0x6,0x5,0x4,0x3,0x2,0x1
	.DB  0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8
	.DB  0x7,0x6,0x5,0x4,0x3,0x2,0x1,0x0
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x7,0x6,0x5,0x4,0x3,0x2,0x1,0x0
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x7,0x6,0x5,0x4,0x3,0x2,0x1
	.DB  0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8
	.DB  0x9,0x8,0x7,0x6,0x5,0x4,0x3,0x2
	.DB  0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9
	.DB  0xA,0x9,0x8,0x7,0x6,0x5,0x4,0x3
	.DB  0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xA
	.DB  0xB,0xA,0x9,0x8,0x7,0x6,0x5,0x4
	.DB  0x4,0x5,0x6,0x7,0x8,0x9,0xA,0xB
	.DB  0xC,0xB,0xA,0x9,0x8,0x7,0x6,0x5
	.DB  0x5,0x6,0x7,0x8,0x9,0xA,0xB,0xC
	.DB  0xD,0xC,0xB,0xA,0x9,0x8,0x7,0x6
	.DB  0x6,0x7,0x8,0x9,0xA,0xB,0xC,0xD
	.DB  0xE,0xD,0xC,0xB,0xA,0x9,0x8,0x7
	.DB  0x7,0x8,0x9,0xA,0xB,0xC,0xD,0xE
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _step
	.DW  _0x3*2

	.DW  0x04
	.DW  _step_rev
	.DW  _0x4*2

	.DW  0x01
	.DW  _MOTOR_DELAY
	.DW  _0x5*2

	.DW  0x100
	.DW  _wallflood
	.DW  _0x5F*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;Date    : 12/17/2008
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 16.000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
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
;#include <stdio.h>
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 001D #endasm
;#include <lcd.h>
;
;
;#define BITx (1<<x)
;#define CHECKBIT(x,b) (x&b)
;#define SETBIT(x,b) x=x|b;
;#define CLEARBIT(x,b) x=x&(~b);
;#define TOGGLEBIT(x,b) x=x^b;
;#define BIT0 0x01
;#define BIT1 0x02
;#define BIT2 0x04
;#define BIT3 0x08
;#define BIT4 0x10
;#define BIT5 0x20
;#define BIT6 0x40
;#define BIT7 0x80
;
;#define ADC_MIN_FRONT 50
;#define ADC_CENTRE 62 //105 //62
;#define ADC_MIN_LEFT 20 //5 //40
;#define ADC_MIN_RIGHT 20 //5 //20
;#define L 0
;#define F 1
;#define R 2
;
;
;#define TRUE 1
;#define FALSE 0
;#define SHOW_DISPLAY TRUE
;#define ACC_FACTOR 100
;#define SENSOR_TYPE 0
;unsigned char step[4]={0xCC,0x66,0x33,0x99};

	.DSEG
;unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
;unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z,accCounter;
;unsigned char dirR,dirL;
;unsigned rightMotorOn;
;unsigned leftMotorOn;
;unsigned int left,right,center;
;
;unsigned int volatile steps_remaining,steps_taken;
;unsigned int volatile wall_infoL,wall_infoR,wall_infoF;
;unsigned char wall_act[3];
;int error,error0;
;
;unsigned char MOTOR_DELAY=30;
;#define ADC_DELAY 60
;
;
;void read(void);
;void show(unsigned int ,unsigned char , unsigned char );
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0052 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0053    //right motor
; 0000 0054    y++;
	INC  R8
; 0000 0055    if(y>r_overflow && steps_remaining)
	CP   R4,R8
	BRSH _0x7
	LDS  R30,_steps_remaining
	LDS  R31,_steps_remaining+1
	SBIW R30,0
	BRNE _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0056    {
; 0000 0057     y=0;
	CLR  R8
; 0000 0058 
; 0000 0059     if(dirR)PORTD=step[r_step];
	TST  R13
	BREQ _0x9
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	RJMP _0xCC
; 0000 005A     else PORTD=step_rev[r_step];
_0x9:
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
_0xCC:
	LD   R30,Z
	OUT  0x12,R30
; 0000 005B 
; 0000 005C     r_step++;
	INC  R6
; 0000 005D     if(r_step>3)r_step=0;
	LDI  R30,LOW(3)
	CP   R30,R6
	BRSH _0xB
	CLR  R6
; 0000 005E     steps_taken++;
_0xB:
	CALL SUBOPT_0x0
; 0000 005F     steps_remaining--;
; 0000 0060    }
; 0000 0061 
; 0000 0062    //left motor
; 0000 0063    x++;
_0x6:
	INC  R9
; 0000 0064    if(x>l_overflow && steps_remaining)
	CP   R5,R9
	BRSH _0xD
	LDS  R30,_steps_remaining
	LDS  R31,_steps_remaining+1
	SBIW R30,0
	BRNE _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 0065    {
; 0000 0066     x=0;
	CLR  R9
; 0000 0067 
; 0000 0068     if(dirL)PORTB=step[l_step];
; 0000 0069     else  PORTB=step[l_step];
_0xCD:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	LD   R30,Z
	OUT  0x18,R30
; 0000 006A 
; 0000 006B     l_step++;
	INC  R7
; 0000 006C     if(l_step > 3)l_step = 0;
	LDI  R30,LOW(3)
	CP   R30,R7
	BRSH _0x11
	CLR  R7
; 0000 006D     steps_taken++;
_0x11:
	CALL SUBOPT_0x0
; 0000 006E     steps_remaining--;
; 0000 006F    }
; 0000 0070 
; 0000 0071    //acceleration code
; 0000 0072 //  accCounter++;
; 0000 0073 //   if(accCounter>ACC_FACTOR)
; 0000 0074 //   {
; 0000 0075 //     accCounter=0;
; 0000 0076 //      if(MOTOR_DELAY>20)
; 0000 0077 //       MOTOR_DELAY--;
; 0000 0078 //   }
; 0000 0079 
; 0000 007A 
; 0000 007B }
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;// Timer 2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0080 {
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
; 0000 0081     unsigned char rTemp,lTemp;
; 0000 0082    // Place your code here
; 0000 0083    //read sensor
; 0000 0084    z++;
	ST   -Y,R17
	ST   -Y,R16
;	rTemp -> R17
;	lTemp -> R16
	INC  R11
; 0000 0085    if(z>ADC_DELAY)
	LDI  R30,LOW(60)
	CP   R30,R11
	BRLO PC+3
	JMP _0x12
; 0000 0086    {
; 0000 0087         z=0;
	CLR  R11
; 0000 0088         read();
	RCALL _read
; 0000 0089 
; 0000 008A         //get wall information
; 0000 008B         if(left>ADC_MIN_LEFT)
	LDS  R26,_left
	LDS  R27,_left+1
	SBIW R26,21
	BRLO _0x13
; 0000 008C         {
; 0000 008D           if(steps_remaining<200&&steps_remaining>107){wall_infoL+=steps_taken;}
	CALL SUBOPT_0x1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x15
	CALL SUBOPT_0x2
	BRSH _0x16
_0x15:
	RJMP _0x14
_0x16:
	CALL SUBOPT_0x3
	LDS  R26,_wall_infoL
	LDS  R27,_wall_infoL+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _wall_infoL,R30
	STS  _wall_infoL+1,R31
; 0000 008E 	}
_0x14:
; 0000 008F 	if(center>ADC_MIN_FRONT)
_0x13:
	LDS  R26,_center
	LDS  R27,_center+1
	SBIW R26,51
	BRLO _0x17
; 0000 0090         {
; 0000 0091 	 if(steps_remaining<200&&steps_remaining>107){wall_infoF+=steps_taken;}
	CALL SUBOPT_0x1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x19
	CALL SUBOPT_0x2
	BRSH _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	CALL SUBOPT_0x3
	LDS  R26,_wall_infoF
	LDS  R27,_wall_infoF+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _wall_infoF,R30
	STS  _wall_infoF+1,R31
; 0000 0092 	}
_0x18:
; 0000 0093 	if(right>ADC_MIN_RIGHT)
_0x17:
	LDS  R26,_right
	LDS  R27,_right+1
	SBIW R26,21
	BRLO _0x1B
; 0000 0094         {
; 0000 0095 	  if(steps_remaining<200&&steps_remaining>107){wall_infoR+=steps_taken;}
	CALL SUBOPT_0x1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x1D
	CALL SUBOPT_0x2
	BRSH _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
	CALL SUBOPT_0x3
	LDS  R26,_wall_infoR
	LDS  R27,_wall_infoR+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _wall_infoR,R30
	STS  _wall_infoR+1,R31
; 0000 0096 	}
_0x1C:
; 0000 0097 	else {CLEARBIT(PORTC,BIT1);}
	RJMP _0x1F
_0x1B:
	CBI  0x15,1
_0x1F:
; 0000 0098         //error correction
; 0000 0099         rTemp=right;
	LDS  R17,_right
; 0000 009A         lTemp=left;
	LDS  R16,_left
; 0000 009B         if(rTemp<ADC_MIN_RIGHT){rTemp= ADC_CENTRE;}
	CPI  R17,20
	BRSH _0x20
	LDI  R17,LOW(62)
; 0000 009C         if(lTemp<ADC_MIN_LEFT){lTemp = ADC_CENTRE;}
_0x20:
	CPI  R16,20
	BRSH _0x21
	LDI  R16,LOW(62)
; 0000 009D         error = lTemp-rTemp;
_0x21:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STS  _error,R26
	STS  _error+1,R27
; 0000 009E 
; 0000 009F 	//if(error>0)
; 0000 00A0         l_overflow=MOTOR_DELAY-(error/8);
	CALL SUBOPT_0x4
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	MOV  R5,R30
; 0000 00A1 	//if(error<0)
; 0000 00A2         r_overflow=MOTOR_DELAY+(error/8);
	CALL SUBOPT_0x4
	MOVW R26,R22
	ADD  R30,R26
	MOV  R4,R30
; 0000 00A3 
; 0000 00A4         if(SHOW_DISPLAY)
; 0000 00A5         {
; 0000 00A6          putchar(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _putchar
; 0000 00A7          putchar(left);
	LDS  R30,_left
	ST   -Y,R30
	CALL _putchar
; 0000 00A8          putchar(center);
	LDS  R30,_center
	ST   -Y,R30
	CALL _putchar
; 0000 00A9          putchar(right);
	LDS  R30,_right
	ST   -Y,R30
	CALL _putchar
; 0000 00AA         //show(right,0,0);
; 0000 00AB         //show(left,10,0);
; 0000 00AC         //show(center,5,0);
; 0000 00AD         }
; 0000 00AE    }
; 0000 00AF }
_0x12:
	LD   R16,Y+
	LD   R17,Y+
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
;#define ADC_VREF_TYPE 0x60
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 00B8 {
_read_adc:
; 0000 00B9 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 00BA // Delay needed for the stabilization of the ADC input voltage
; 0000 00BB delay_us(10);
	__DELAY_USB 53
; 0000 00BC // Start the AD conversion
; 0000 00BD ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00BE // Wait for the AD conversion to complete
; 0000 00BF while ((ADCSRA & 0x10)==0);
_0x23:
	SBIS 0x6,4
	RJMP _0x23
; 0000 00C0 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00C1 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 00C2 }
;
; void initialize(void)
; 0000 00C5 {
_initialize:
; 0000 00C6  x=0;
	CLR  R9
; 0000 00C7  y=0;
	CLR  R8
; 0000 00C8  z=0;
	CLR  R11
; 0000 00C9  l_step=0;
	CLR  R7
; 0000 00CA  r_step=0;
	CLR  R6
; 0000 00CB  l_overflow=MOTOR_DELAY;
	LDS  R5,_MOTOR_DELAY
; 0000 00CC  r_overflow=MOTOR_DELAY;
	LDS  R4,_MOTOR_DELAY
; 0000 00CD  rightMotorOn=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rightMotorOn,R30
	STS  _rightMotorOn+1,R31
; 0000 00CE  leftMotorOn=1;
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R31
; 0000 00CF  steps_remaining=0;
	LDI  R30,LOW(0)
	STS  _steps_remaining,R30
	STS  _steps_remaining+1,R30
; 0000 00D0  steps_remaining=0;
	STS  _steps_remaining,R30
	STS  _steps_remaining+1,R30
; 0000 00D1  accCounter=0;
	CLR  R10
; 0000 00D2 wall_act[L]=TRUE;
	LDI  R30,LOW(1)
	STS  _wall_act,R30
; 0000 00D3 wall_act[R]=TRUE;
	__PUTB1MN _wall_act,2
; 0000 00D4 wall_act[F]=FALSE;
	LDI  R30,LOW(0)
	__PUTB1MN _wall_act,1
; 0000 00D5  //dirL=1;
; 0000 00D6  //dirR=1;
; 0000 00D7 }
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
; 0000 00F9 {
_read:
; 0000 00FA  unsigned char lo,co,ro;
; 0000 00FB  left=0;
	CALL __SAVELOCR4
;	lo -> R17
;	co -> R16
;	ro -> R19
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00FC  center=0;
	STS  _center,R30
	STS  _center+1,R30
; 0000 00FD  right=0;
	STS  _right,R30
	STS  _right+1,R30
; 0000 00FE 
; 0000 00FF  lo=0;
	LDI  R17,LOW(0)
; 0000 0100  co=0;
	LDI  R16,LOW(0)
; 0000 0101  ro=0;
	LDI  R19,LOW(0)
; 0000 0102  if(SENSOR_TYPE==0)
; 0000 0103  {
; 0000 0104         lo=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R17,R30
; 0000 0105         PORTA=PINA|(1<<0);
	IN   R30,0x19
	ORI  R30,1
	OUT  0x1B,R30
; 0000 0106         left=read_adc(3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x5
	STS  _left,R30
	STS  _left+1,R31
; 0000 0107         PORTA=PINA&(~(1<<0));
	IN   R30,0x19
	ANDI R30,0xFE
	OUT  0x1B,R30
; 0000 0108         left=left-lo;
	MOV  R30,R17
	LDI  R31,0
	LDS  R26,_left
	LDS  R27,_left+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _left,R26
	STS  _left+1,R27
; 0000 0109         delay_us(7);
	__DELAY_USB 37
; 0000 010A 
; 0000 010B         ro=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R19,R30
; 0000 010C         PORTA=PINA|(1<<1);
	IN   R30,0x19
	ORI  R30,2
	OUT  0x1B,R30
; 0000 010D         right=read_adc(4);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5
	STS  _right,R30
	STS  _right+1,R31
; 0000 010E         PORTA=PINA&(~(1<<1));
	IN   R30,0x19
	ANDI R30,0xFD
	OUT  0x1B,R30
; 0000 010F         right=right-ro;
	MOV  R30,R19
	LDI  R31,0
	LDS  R26,_right
	LDS  R27,_right+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _right,R26
	STS  _right+1,R27
; 0000 0110         delay_us(7);
	__DELAY_USB 37
; 0000 0111 
; 0000 0112         co=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R16,R30
; 0000 0113         PORTA=PINA|(1<<2);
	IN   R30,0x19
	ORI  R30,4
	OUT  0x1B,R30
; 0000 0114         center=read_adc(5);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
	STS  _center,R30
	STS  _center+1,R31
; 0000 0115         PORTA=PINA&(~(1<<2));
	IN   R30,0x19
	ANDI R30,0xFB
	OUT  0x1B,R30
; 0000 0116         center=center-co;
	MOV  R30,R16
	LDI  R31,0
	LDS  R26,_center
	LDS  R27,_center+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _center,R26
	STS  _center+1,R27
; 0000 0117         delay_us(7);
	__DELAY_USB 37
; 0000 0118  }
; 0000 0119   if(SENSOR_TYPE==1)
; 0000 011A   {
; 0000 011B         left=read_adc(5);
; 0000 011C         center=read_adc(6);
; 0000 011D         right=read_adc(7);
; 0000 011E   }
; 0000 011F   if(SENSOR_TYPE==2)
; 0000 0120   {
; 0000 0121       co=read_adc(2);//front right
; 0000 0122       right=read_adc(3);//right
; 0000 0123       left=read_adc(4);//left
; 0000 0124       center=(read_adc(5)+co)/2;//front left
; 0000 0125   }
; 0000 0126 }
	RJMP _0x2080003
;
;void show(unsigned int val,unsigned char xx, unsigned char yy)
; 0000 0129 {
; 0000 012A  unsigned char a,b,c;
; 0000 012B  lcd_gotoxy(xx,yy);
;	val -> Y+6
;	xx -> Y+5
;	yy -> Y+4
;	a -> R17
;	b -> R16
;	c -> R19
; 0000 012C  a=(val%10)+48;
; 0000 012D  val/=10;
; 0000 012E  b=(val%10)+48;
; 0000 012F  val/=10;
; 0000 0130  c=(val%10)+48;
; 0000 0131 // val/=10;
; 0000 0132 // d=(val%10)+48;
; 0000 0133 // lcd_putchar(d);
; 0000 0134  lcd_putchar(c);
; 0000 0135  lcd_putchar(b);
; 0000 0136  lcd_putchar(a);
; 0000 0137 
; 0000 0138 }
;
;void turnR(void)
; 0000 013B   {while(steps_remaining){}
; 0000 013C   while(steps_remaining){}
; 0000 013D   dirL=1;
; 0000 013E   dirR=0;
; 0000 013F 
; 0000 0140   steps_remaining=160;
; 0000 0141   while(steps_remaining){}
; 0000 0142   while(steps_remaining){}
; 0000 0143   }
;
;  void turnL(void)
; 0000 0146   {while(steps_remaining){}
; 0000 0147   while(steps_remaining){}
; 0000 0148 
; 0000 0149   dirR=1;
; 0000 014A   dirL=0;
; 0000 014B   steps_remaining=160;
; 0000 014C   while(steps_remaining){}
; 0000 014D   while(steps_remaining){}
; 0000 014E   }
; void turnB(void)
; 0000 0150   {while(steps_remaining){}
; 0000 0151   while(steps_remaining){}
; 0000 0152   dirL=1;
; 0000 0153   dirR=0;
; 0000 0154 
; 0000 0155   steps_remaining=305;
; 0000 0156   while(steps_remaining){}
; 0000 0157   while(steps_remaining){}
; 0000 0158   }
;
; void move_straight(void)
; 0000 015B  {
; 0000 015C   while(steps_remaining){}
; 0000 015D   while(steps_remaining){}
; 0000 015E   wall_infoL = 0;
; 0000 015F   wall_infoR = 0;
; 0000 0160   wall_infoF = 0;
; 0000 0161   dirR=1;
; 0000 0162   dirL=1;
; 0000 0163   steps_remaining=436; //424
; 0000 0164 
; 0000 0165   while(steps_remaining){}
; 0000 0166   while(steps_remaining){}
; 0000 0167 
; 0000 0168       if(wall_infoL>70)
; 0000 0169       {
; 0000 016A        //lcd_gotoxy(12,1);
; 0000 016B        //lcd_putsf("Lt");
; 0000 016C        wall_act[L]=TRUE;
; 0000 016D       }
; 0000 016E       else
; 0000 016F       {
; 0000 0170        //lcd_gotoxy(12,1);
; 0000 0171        //lcd_putsf("no");
; 0000 0172          wall_act[L]=FALSE;
; 0000 0173       }
; 0000 0174       if(wall_infoR>70)
; 0000 0175       {
; 0000 0176        //lcd_gotoxy(0,1);
; 0000 0177        //lcd_putsf("Rt");
; 0000 0178         wall_act[R]=TRUE;
; 0000 0179       }
; 0000 017A       else
; 0000 017B       {
; 0000 017C        //lcd_gotoxy(0,1);
; 0000 017D        //lcd_putsf("no");
; 0000 017E         wall_act[R]=FALSE;
; 0000 017F       }
; 0000 0180       if(wall_infoF>20)
; 0000 0181       {
; 0000 0182        //lcd_gotoxy(5,1);
; 0000 0183        //lcd_putsf("Fr");
; 0000 0184         wall_act[F]=TRUE;
; 0000 0185       }
; 0000 0186       else
; 0000 0187       {
; 0000 0188         //lcd_gotoxy(5,1);
; 0000 0189         //lcd_putsf("no");
; 0000 018A          wall_act[F]=FALSE;
; 0000 018B       }
; 0000 018C   }
;// Declare your global variables here
;unsigned char readSensors()
; 0000 018F {
_readSensors:
; 0000 0190         return((wall_act[L]*100)+(wall_act[F]*10)+(wall_act[R]));
	LDS  R30,_wall_act
	LDI  R31,0
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	MOVW R22,R30
	__GETB1MN _wall_act,1
	LDI  R31,0
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _wall_act,2
	CALL SUBOPT_0x6
	RET
; 0000 0191 }
;#include "solver.c"
;/**
; * @author Shaunak Vairagare
; *
; */
;
;        //macro Definations
;        #define N 0
;        #define E 1
;        #define S 2
;        #define W 3
;        #define B 100
;
;        //Logical Storage
;        unsigned char mouseR;
;        unsigned char mouseC;
;
;        unsigned char ori;
;        unsigned char quad;
;        unsigned char zone;
;        unsigned char pathcount;
;        unsigned char deadFlag;
;        unsigned char cameFrom;
;        unsigned char map[33][33];
;        unsigned char wall[4];
;        unsigned char wallflood[]={
;
;                        14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14,
;                        13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
;                        12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
;                        11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
;                        10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
;                         9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
;                         8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
;                         7,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
;                         7,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
;                         8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
;                         9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
;                        10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
;                        11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
;                        12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
;                        13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
;                        14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14
;
;                        };

	.DSEG
;
;        //Functions to replace in code finally
;        unsigned char m(unsigned char val)//to convert mouse coordinates in to matrix coordinate
; 0000 0192         {

	.CSEG
_m:
;                return (unsigned char)((val*2)+1);
;	val -> Y+0
	CALL SUBOPT_0x7
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x8
	JMP  _0x2080001
;        }
;        unsigned char valInArray(unsigned char r,unsigned char c)
;	{
_valInArray:
;		unsigned char val=0;
;
;		val=(unsigned char)((r*16)+c);
	ST   -Y,R17
;	r -> Y+2
;	c -> Y+1
;	val -> R17
	LDI  R17,0
	LDD  R30,Y+2
	LDI  R31,0
	CALL __LSLW4
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	MOV  R17,R30
;		return val;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,3
	RET
;	}
;        void initializeSystem()
;        {
_initializeSystem:
;                unsigned char r;
;                unsigned char c;
;                 mouseR=15;
	ST   -Y,R17
	ST   -Y,R16
;	r -> R17
;	c -> R16
	LDI  R30,LOW(15)
	STS  _mouseR,R30
;                 mouseC=0;
	LDI  R30,LOW(0)
	STS  _mouseC,R30
;
;                 ori=N;
	STS  _ori,R30
;                 quad=3;
	LDI  R30,LOW(3)
	STS  _quad,R30
;                 zone=6;
	LDI  R30,LOW(6)
	STS  _zone,R30
;                 pathcount=2;
	LDI  R30,LOW(2)
	STS  _pathcount,R30
;                 deadFlag=FALSE;
	LDI  R30,LOW(0)
	STS  _deadFlag,R30
;                 cameFrom=S;
	LDI  R30,LOW(2)
	STS  _cameFrom,R30
;                 map[32][1]=1;
	LDI  R30,LOW(1)
	__PUTB1MN _map,1057
;                 wall[N]=1;
	STS  _wall,R30
;
;                 for(r=0;r<16;r++)
	LDI  R17,LOW(0)
_0x61:
	CPI  R17,16
	BRSH _0x62
;                         for(c=0;c<16;c++)
	LDI  R16,LOW(0)
_0x64:
	CPI  R16,16
	BRSH _0x65
;                         {
;                                 map[m(r)][m(c)]=1;
	ST   -Y,R17
	CALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	ST   -Y,R16
	RCALL _m
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LDI  R30,LOW(1)
	ST   X,R30
;
;                         }
	SUBI R16,-1
	RJMP _0x64
_0x65:
	SUBI R17,-1
	RJMP _0x61
_0x62:
;
;
;
;        }
	RJMP _0x2080002
;
;
;
;
;
;        void move_north()
;        {
_move_north:
;
;                mouseR-=1;
	CALL SUBOPT_0xB
	SBIW R30,1
	STS  _mouseR,R30
;                ori=N;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
;                if(deadFlag==FALSE)pathcount++;
	BRNE _0x66
	LDS  R30,_pathcount
	SUBI R30,-LOW(1)
	RJMP _0xD1
;                else  if(deadFlag==TRUE)pathcount--;
_0x66:
	LDS  R26,_deadFlag
	CPI  R26,LOW(0x1)
	BRNE _0x68
	LDS  R30,_pathcount
	SUBI R30,LOW(1)
_0xD1:
	STS  _pathcount,R30
;
;        }
_0x68:
	RET
;
;        void move_south()
;        {
_move_south:
;
;                mouseR+=1;
	CALL SUBOPT_0xB
	ADIW R30,1
	STS  _mouseR,R30
;                ori=S;
	LDI  R30,LOW(2)
	CALL SUBOPT_0xC
;
;                if(deadFlag==FALSE)pathcount++;
	BRNE _0x69
	LDS  R30,_pathcount
	SUBI R30,-LOW(1)
	RJMP _0xD2
;                else if(deadFlag==TRUE) pathcount--;
_0x69:
	LDS  R26,_deadFlag
	CPI  R26,LOW(0x1)
	BRNE _0x6B
	LDS  R30,_pathcount
	SUBI R30,LOW(1)
_0xD2:
	STS  _pathcount,R30
;        }
_0x6B:
	RET
;
;        void move_east()
;        {
_move_east:
;
;                mouseC+=1;
	CALL SUBOPT_0xD
	ADIW R30,1
	STS  _mouseC,R30
;                ori=E;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xC
;
;                if(deadFlag==FALSE)pathcount++;
	BRNE _0x6C
	LDS  R30,_pathcount
	SUBI R30,-LOW(1)
	RJMP _0xD3
;                else if(deadFlag==TRUE) pathcount--;
_0x6C:
	LDS  R26,_deadFlag
	CPI  R26,LOW(0x1)
	BRNE _0x6E
	LDS  R30,_pathcount
	SUBI R30,LOW(1)
_0xD3:
	STS  _pathcount,R30
;        }
_0x6E:
	RET
;
;        void move_west()
;        {
_move_west:
;
;                mouseC-=1;
	CALL SUBOPT_0xD
	SBIW R30,1
	STS  _mouseC,R30
;                ori=W;
	LDI  R30,LOW(3)
	CALL SUBOPT_0xC
;
;                if(deadFlag==FALSE)pathcount++;
	BRNE _0x6F
	LDS  R30,_pathcount
	SUBI R30,-LOW(1)
	RJMP _0xD4
;                else if(deadFlag==TRUE) pathcount--;
_0x6F:
	LDS  R26,_deadFlag
	CPI  R26,LOW(0x1)
	BRNE _0x71
	LDS  R30,_pathcount
	SUBI R30,LOW(1)
_0xD4:
	STS  _pathcount,R30
;
;
;        }
_0x71:
	RET
;
;        void setdead(unsigned char r, unsigned char c)
;        {
_setdead:
;                map[r][c]=0;
;	r -> Y+1
;	c -> Y+0
	LDD  R30,Y+1
	LDI  R26,LOW(33)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_map)
	SBCI R31,HIGH(-_map)
	MOVW R26,R30
	CALL SUBOPT_0x7
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
;                deadFlag=TRUE;
	LDI  R30,LOW(1)
	STS  _deadFlag,R30
;        }
	ADIW R28,2
	RET
;
;        void backtrack()
;        {
_backtrack:
;
;
;                setdead(m(mouseR),m(mouseC));
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	RCALL _m
	ST   -Y,R30
	RCALL _setdead
;
;                   if(cameFrom==S && wall[S]==FALSE) move_south();
	LDS  R26,_cameFrom
	CPI  R26,LOW(0x2)
	BRNE _0x73
	__GETB1MN _wall,2
	CPI  R30,0
	BREQ _0x74
_0x73:
	RJMP _0x72
_0x74:
	RCALL _move_south
;         else if(cameFrom==W && wall[W]==FALSE) move_west();
	RJMP _0x75
_0x72:
	LDS  R26,_cameFrom
	CPI  R26,LOW(0x3)
	BRNE _0x77
	__GETB1MN _wall,3
	CPI  R30,0
	BREQ _0x78
_0x77:
	RJMP _0x76
_0x78:
	RCALL _move_west
;         else if(cameFrom==N && wall[N]==FALSE) move_north();
	RJMP _0x79
_0x76:
	LDS  R26,_cameFrom
	CPI  R26,LOW(0x0)
	BRNE _0x7B
	LDS  R26,_wall
	CPI  R26,LOW(0x0)
	BREQ _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
	RCALL _move_north
;         else if(cameFrom==E && wall[E]==FALSE) move_east();
	RJMP _0x7D
_0x7A:
	LDS  R26,_cameFrom
	CPI  R26,LOW(0x1)
	BRNE _0x7F
	__GETB1MN _wall,1
	CPI  R30,0
	BREQ _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	RCALL _move_east
;
;        }
_0x7E:
_0x7D:
_0x79:
_0x75:
	RET
;
;        void see_where_you_came_from()
;        {
_see_where_you_came_from:
;
;                if(mouseR>0 &&  map[m(mouseR)-2][m(mouseC)  ]==(pathcount-1)) cameFrom=N;
	LDS  R26,_mouseR
	CPI  R26,LOW(0x1)
	BRLO _0x82
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	CALL SUBOPT_0x13
	BREQ _0x83
_0x82:
	RJMP _0x81
_0x83:
	LDI  R30,LOW(0)
	RJMP _0xD5
;         else if(mouseC<15 && map[m(mouseR)  ][m(mouseC)+2]==(pathcount-1)) cameFrom=E;
_0x81:
	LDS  R26,_mouseC
	CPI  R26,LOW(0xF)
	BRSH _0x86
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x13
	BREQ _0x87
_0x86:
	RJMP _0x85
_0x87:
	LDI  R30,LOW(1)
	RJMP _0xD5
;         else if(mouseR<15 && map[m(mouseR)+2][m(mouseC)  ]==(pathcount-1)) cameFrom=S;
_0x85:
	LDS  R26,_mouseR
	CPI  R26,LOW(0xF)
	BRSH _0x8A
	CALL SUBOPT_0xE
	CALL SUBOPT_0x15
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	CALL SUBOPT_0x13
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
	LDI  R30,LOW(2)
	RJMP _0xD5
;         else if(mouseC>0 &&  map[m(mouseR)  ][m(mouseC)-2]==(pathcount-1)) cameFrom=W;
_0x89:
	LDS  R26,_mouseC
	CPI  R26,LOW(0x1)
	BRLO _0x8E
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x13
	BREQ _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
	LDI  R30,LOW(3)
_0xD5:
	STS  _cameFrom,R30
;        }
_0x8D:
	RET
;
;        void scan()
;        {
_scan:
;                char sensorOp,LL,FF,RR;
;                sensorOp=readSensors();//this function returns 1's/0's in LFR format
	CALL __SAVELOCR4
;	sensorOp -> R17
;	LL -> R16
;	FF -> R19
;	RR -> R18
	RCALL _readSensors
	MOV  R17,R30
;
;                LL=(ori-1);
	LDS  R30,_ori
	CALL SUBOPT_0x16
	MOV  R16,R30
;                if(LL<0)LL=W;
;                FF=ori;
	LDS  R19,_ori
;                RR=(char)((ori+1)%4);//to keep o/p between NESW(0,1,2,3)
	LDS  R30,_ori
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	MOV  R18,R30
;
;
;                wall[(ori+2)%4]=wall[(((ori+2)%4)+2)%4];
	LDS  R30,_ori
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
	MOVW R26,R30
	SUBI R30,LOW(-_wall)
	SBCI R31,HIGH(-_wall)
	MOVW R22,R30
	MOVW R30,R26
	ADIW R30,2
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_wall)
	SBCI R31,HIGH(-_wall)
	LD   R30,Z
	MOVW R26,R22
	ST   X,R30
;                wall[RR]=(char)(sensorOp%10);sensorOp/=10;
	MOV  R30,R18
	CALL SUBOPT_0x19
;                wall[FF]=(char)(sensorOp%10);sensorOp/=10;
	MOV  R30,R19
	CALL SUBOPT_0x19
;                wall[LL]=(char)(sensorOp%10);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_wall)
	SBCI R31,HIGH(-_wall)
	MOVW R22,R30
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	LDI  R31,0
	MOVW R26,R22
	ST   X,R30
;
;        }
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;
;        unsigned char sense()//returns 1 when center reached
;        {
_sense:
;
;                map[m(mouseR)][m(mouseC)]=pathcount;
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	LDS  R26,_pathcount
	STD  Z+0,R26
;
;                //if(deadFlag==FALSE)
;                {
;                        scan();
	RCALL _scan
;                        map[m(mouseR)-1][m(mouseC)]=wall[N];
	CALL SUBOPT_0xE
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	LDS  R26,_wall
	STD  Z+0,R26
;                        map[m(mouseR)][m(mouseC)+1]=wall[E];
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _wall,1
	ST   X,R30
;                        map[m(mouseR)+1][m(mouseC)]=wall[S];
	CALL SUBOPT_0xE
	CALL SUBOPT_0x17
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	__GETB1MN _wall,2
	ST   X,R30
;                        map[m(mouseR)][m(mouseC)-1]=wall[W];
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _wall,3
	ST   X,R30
;                }
;
;                deadFlag=FALSE;
	LDI  R30,LOW(0)
	STS  _deadFlag,R30
;                ////////////////////// Add Wall info in map matrix ////////////
;
;
;                /////////////////////  mark new paths /////////////////////////
;
;            if(mouseR >0  && wall[N]==FALSE && map[m(mouseR)-2][m(mouseC)]==1)  map[m(mouseR)-2][m(mouseC)]=255;
	LDS  R26,_mouseR
	CPI  R26,LOW(0x1)
	BRLO _0x92
	LDS  R26,_wall
	CPI  R26,LOW(0x0)
	BRNE _0x92
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x93
_0x92:
	RJMP _0x91
_0x93:
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LDI  R30,LOW(255)
	ST   X,R30
;            if(mouseR <15 && wall[S]==FALSE && map[m(mouseR)+2][m(mouseC)]==1)  map[m(mouseR)+2][m(mouseC)]=255;
_0x91:
	LDS  R26,_mouseR
	CPI  R26,LOW(0xF)
	BRSH _0x95
	__GETB1MN _wall,2
	CPI  R30,0
	BRNE _0x95
	CALL SUBOPT_0xE
	CALL SUBOPT_0x15
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x96
_0x95:
	RJMP _0x94
_0x96:
	CALL SUBOPT_0xE
	CALL SUBOPT_0x15
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LDI  R30,LOW(255)
	ST   X,R30
;            if(mouseC >0  && wall[W]==FALSE && map[m(mouseR)][m(mouseC)-2]==1)  map[m(mouseR)][m(mouseC)-2]=255;
_0x94:
	LDS  R26,_mouseC
	CPI  R26,LOW(0x1)
	BRLO _0x98
	__GETB1MN _wall,3
	CPI  R30,0
	BRNE _0x98
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(255)
	ST   X,R30
;            if(mouseC <15 && wall[E]==FALSE && map[m(mouseR)][m(mouseC)+2]==1)  map[m(mouseR)][m(mouseC)+2]=255;
_0x97:
	LDS  R26,_mouseC
	CPI  R26,LOW(0xF)
	BRSH _0x9B
	__GETB1MN _wall,1
	CPI  R30,0
	BRNE _0x9B
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x9C
_0x9B:
	RJMP _0x9A
_0x9C:
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(255)
	ST   X,R30
;
;            //////////// win condition///////////////////
;
;                   /*if((map[m(mouseR)-2][m(mouseC)-2]>1)&&(map[m(mouseR)-2][m(mouseC)-1]==0)&&(map[m(mouseR)-2][m(mouseC)]>1)&&(map[m(mouseR)-1][m(mouseC)-2]==0)&&(map[m(mouseR)-1][m(mouseC)]==0)&&(map[m(mouseR)][m(mouseC)-2]>1)&&(map[m(mouseR)][m(mouseC)-1]==0)&&(map[m(mouseR)][m(mouseC)]>1))
;                return(1);
;                else
;                if((map[m(mouseR)+2][m(mouseC)+2]>1)&&(map[m(mouseR)+2][m(mouseC)+1]==0)&&(map[m(mouseR)+2][m(mouseC)]>1)&&(map[m(mouseR)+1][m(mouseC)+2]==0)&&(map[m(mouseR)+1][m(mouseC)]==0)&&(map[m(mouseR)][m(mouseC)+2]>1)&&(map[m(mouseR)][m(mouseC)+1]==0)&&(map[m(mouseR)][m(mouseC)]>1))
;                return(1);
;                else return(0);*/
;
;           if((mouseR==7&&mouseC==7)||(mouseR==7&&mouseC==8)||(mouseR==8&&mouseC==7)||(mouseR==8&&mouseC==8))
_0x9A:
	LDS  R26,_mouseR
	CPI  R26,LOW(0x7)
	BRNE _0x9E
	LDS  R26,_mouseC
	CPI  R26,LOW(0x7)
	BREQ _0xA0
_0x9E:
	LDS  R26,_mouseR
	CPI  R26,LOW(0x7)
	BRNE _0xA1
	LDS  R26,_mouseC
	CPI  R26,LOW(0x8)
	BREQ _0xA0
_0xA1:
	LDS  R26,_mouseR
	CPI  R26,LOW(0x8)
	BRNE _0xA3
	LDS  R26,_mouseC
	CPI  R26,LOW(0x7)
	BREQ _0xA0
_0xA3:
	LDS  R26,_mouseR
	CPI  R26,LOW(0x8)
	BRNE _0xA5
	LDS  R26,_mouseC
	CPI  R26,LOW(0x8)
	BREQ _0xA0
_0xA5:
	RJMP _0x9D
_0xA0:
;                 {
;                  return(1);
	LDI  R30,LOW(1)
	RET
;                  }
;           else
_0x9D:
;           return(0);
	LDI  R30,LOW(0)
	RET
;
;        }
	RET
;
;        void moveByFloodPriority()
;        {
_moveByFloodPriority:
;
;                unsigned char min=100;//just to check if min has  first value
;                unsigned char selectDir=B;
;
;
;                 if(mouseR >0  && wall[N]==FALSE && (map[m(mouseR)-2][m(mouseC)]>map[m(mouseR)][m(mouseC)]))
	ST   -Y,R17
	ST   -Y,R16
;	min -> R17
;	selectDir -> R16
	LDI  R17,100
	LDI  R16,100
	LDS  R26,_mouseR
	CPI  R26,LOW(0x1)
	BRLO _0xAA
	LDS  R26,_wall
	CPI  R26,LOW(0x0)
	BRNE _0xAA
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	PUSH R30
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	POP  R26
	CP   R30,R26
	BRLO _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
;                 {
;
;                         if(min==100)min=wallflood[valInArray((unsigned char)(mouseR-1), mouseC)];
	CPI  R17,100
	BRNE _0xAC
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	LD   R17,Z
;                         if(wallflood[valInArray((unsigned char)(mouseR-1), mouseC)]<=min)
_0xAC:
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	LD   R30,Z
	CP   R17,R30
	BRLO _0xAD
;                         {
;                                 min=wallflood[valInArray((unsigned char)(mouseR-1), mouseC)];
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	LD   R17,Z
;                                 selectDir=N;
	LDI  R16,LOW(0)
;                         }
;
;
;
;                 }
_0xAD:
;                if(mouseC <15 && wall[E]==FALSE && (map[m(mouseR)][m(mouseC)+2]>map[m(mouseR)][m(mouseC)]))
_0xA9:
	LDS  R26,_mouseC
	CPI  R26,LOW(0xF)
	BRSH _0xAF
	__GETB1MN _wall,1
	CPI  R30,0
	BRNE _0xAF
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	PUSH R30
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	POP  R26
	CP   R30,R26
	BRLO _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
;                {
;
;                        if(min==100)min=wallflood[valInArray(mouseR,(unsigned char) (mouseC+1))];
	CPI  R17,100
	BRNE _0xB1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x8
	ST   -Y,R30
	CALL SUBOPT_0x1B
	LD   R17,Z
;                        if(wallflood[valInArray(mouseR,(unsigned char) (mouseC+1))]<=min)
_0xB1:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x8
	ST   -Y,R30
	CALL SUBOPT_0x1B
	LD   R30,Z
	CP   R17,R30
	BRLO _0xB2
;                        {
;                                 min=wallflood[valInArray(mouseR,(unsigned char) (mouseC+1))];
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x8
	ST   -Y,R30
	CALL SUBOPT_0x1B
	LD   R17,Z
;                                 selectDir=E;
	LDI  R16,LOW(1)
;                        }
;
;
;                }
_0xB2:
;                if(mouseR <15 && wall[S]==FALSE && (map[m(mouseR)+2][m(mouseC)]>map[m(mouseR)][m(mouseC)]))
_0xAE:
	LDS  R26,_mouseR
	CPI  R26,LOW(0xF)
	BRSH _0xB4
	__GETB1MN _wall,2
	CPI  R30,0
	BRNE _0xB4
	CALL SUBOPT_0xE
	CALL SUBOPT_0x15
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	PUSH R30
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	POP  R26
	CP   R30,R26
	BRLO _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
;                 {
;
;                        if(min==100)min=wallflood[valInArray((unsigned char)(mouseR+1), mouseC)];
	CPI  R17,100
	BRNE _0xB6
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	LD   R17,Z
;                        if(wallflood[valInArray((unsigned char)(mouseR+1), mouseC)]<=min)
_0xB6:
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	LD   R30,Z
	CP   R17,R30
	BRLO _0xB7
;                         {
;                                 min=wallflood[valInArray((unsigned char)(mouseR+1), mouseC)];
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1B
	LD   R17,Z
;                                 selectDir=S;
	LDI  R16,LOW(2)
;                         }
;
;
;                 }
_0xB7:
;                if(mouseC >0  && wall[W]==FALSE && (map[m(mouseR)][m(mouseC)-2]>map[m(mouseR)][m(mouseC)]))
_0xB3:
	LDS  R26,_mouseC
	CPI  R26,LOW(0x1)
	BRLO _0xB9
	__GETB1MN _wall,3
	CPI  R30,0
	BRNE _0xB9
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	PUSH R30
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	CALL SUBOPT_0xA
	LD   R30,X
	POP  R26
	CP   R30,R26
	BRLO _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
;                 {
;
;                        if(min==100)min=wallflood[valInArray(mouseR,(unsigned char) (mouseC-1))];
	CPI  R17,100
	BRNE _0xBB
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	LD   R17,Z
;                        if(wallflood[valInArray(mouseR,(unsigned char) (mouseC-1))]<=min)
_0xBB:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	LD   R30,Z
	CP   R17,R30
	BRLO _0xBC
;                         {
;                                 min=wallflood[valInArray(mouseR,(unsigned char) (mouseC-1))];
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	LD   R17,Z
;                                 selectDir=W;
	LDI  R16,LOW(3)
;                         }
;
;
;                 }
_0xBC:
;
;                if(selectDir==N)move_north();
_0xB8:
	CPI  R16,0
	BRNE _0xBD
	RCALL _move_north
;                else if(selectDir==E)move_east();
	RJMP _0xBE
_0xBD:
	CPI  R16,1
	BRNE _0xBF
	RCALL _move_east
;                else if(selectDir==S)move_south();
	RJMP _0xC0
_0xBF:
	CPI  R16,2
	BRNE _0xC1
	RCALL _move_south
;                else if(selectDir==W)move_west();
	RJMP _0xC2
_0xC1:
	CPI  R16,3
	BRNE _0xC3
	RCALL _move_west
;                else if(selectDir==B)backtrack();
	RJMP _0xC4
_0xC3:
	CPI  R16,100
	BRNE _0xC5
	RCALL _backtrack
;
;                 see_where_you_came_from();
_0xC5:
_0xC4:
_0xC2:
_0xC0:
_0xBE:
	RCALL _see_where_you_came_from
;        }
_0x2080002:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;         void solveMaze()
;        {
_solveMaze:
;                  unsigned char centerReached=FALSE;
;                initializeSystem();
	ST   -Y,R17
;	centerReached -> R17
	LDI  R17,0
	RCALL _initializeSystem
;                while(centerReached==FALSE)
_0xC6:
	CPI  R17,0
	BRNE _0xC8
;                {
;
;                        centerReached=sense();
	RCALL _sense
	MOV  R17,R30
;
;
;                        moveByFloodPriority();
	RCALL _moveByFloodPriority
;
;
;
;
;                }
	RJMP _0xC6
_0xC8:
;
;        }
	LD   R17,Y+
	RET
;void main(void)
; 0000 0194 {
_main:
; 0000 0195 // Declare your local variables here
; 0000 0196 
; 0000 0197 
; 0000 0198 // Input/Output Ports initialization
; 0000 0199 // Port A initialization
; 0000 019A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 019B // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 019C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 019D if(SENSOR_TYPE==2)DDRA=0x00;
; 0000 019E else DDRA=0x07;
	LDI  R30,LOW(7)
_0xD6:
	OUT  0x1A,R30
; 0000 019F 
; 0000 01A0 // Port B initialization
; 0000 01A1 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01A2 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 01A3 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01A4 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 01A5 
; 0000 01A6 // Port C initialization
; 0000 01A7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01A9 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01AA DDRC=0x00;
	OUT  0x14,R30
; 0000 01AB 
; 0000 01AC // Port D initialization
; 0000 01AD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 01AE // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 01AF PORTD=0x00;
	OUT  0x12,R30
; 0000 01B0 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 01B1 initialize();
	RCALL _initialize
; 0000 01B2 
; 0000 01B3 // Timer/Counter 0 initialization
; 0000 01B4 // Clock source: System Clock
; 0000 01B5 // Clock value: 2000.000 kHz
; 0000 01B6 // Mode: Normal top=FFh
; 0000 01B7 // OC0 output: Disconnected
; 0000 01B8 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 01B9 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01BA OCR0=0x00;
	OUT  0x3C,R30
; 0000 01BB 
; 0000 01BC // Timer/Counter 1 initialization
; 0000 01BD // Clock source: System Clock
; 0000 01BE // Clock value: Timer 1 Stopped
; 0000 01BF // Mode: Normal top=FFFFh
; 0000 01C0 // OC1A output: Discon.
; 0000 01C1 // OC1B output: Discon.
; 0000 01C2 // Noise Canceler: Off
; 0000 01C3 // Input Capture on Falling Edge
; 0000 01C4 // Timer 1 Overflow Interrupt: Off
; 0000 01C5 // Input Capture Interrupt: Off
; 0000 01C6 // Compare A Match Interrupt: Off
; 0000 01C7 // Compare B Match Interrupt: Off
; 0000 01C8 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01C9 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01CA TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01CB TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01CC ICR1H=0x00;
	OUT  0x27,R30
; 0000 01CD ICR1L=0x00;
	OUT  0x26,R30
; 0000 01CE OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01CF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01D0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01D1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D2 
; 0000 01D3 // Timer/Counter 2 initialization
; 0000 01D4 // Clock source: System Clock
; 0000 01D5 // Clock value: 2000.000 kHz
; 0000 01D6 // Mode: Normal top=FFh
; 0000 01D7 // OC2 output: Disconnected
; 0000 01D8 ASSR=0x00;
	OUT  0x22,R30
; 0000 01D9 TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 01DA TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01DB OCR2=0x00;
	OUT  0x23,R30
; 0000 01DC 
; 0000 01DD // External Interrupt(s) initialization
; 0000 01DE // INT0: Off
; 0000 01DF // INT1: Off
; 0000 01E0 // INT2: Off
; 0000 01E1 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01E2 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01E3 
; 0000 01E4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E5 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01E6 
; 0000 01E7 // USART initialization
; 0000 01E8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E9 // USART Receiver: Off
; 0000 01EA // USART Transmitter: On
; 0000 01EB // USART Mode: Asynchronous
; 0000 01EC // USART Baud Rate: 19200
; 0000 01ED UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01EE UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 01EF UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01F0 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01F1 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01F2 // Analog Comparator initialization
; 0000 01F3 // Analog Comparator: Off
; 0000 01F4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01F5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01F6 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01F7 
; 0000 01F8 // ADC initialization
; 0000 01F9 // ADC Clock frequency: 125.000 kHz
; 0000 01FA // ADC Voltage Reference: Int., cap. on AREF
; 0000 01FB // ADC Auto Trigger Source: None
; 0000 01FC // Only the 8 most significant bits of
; 0000 01FD // the AD conversion result are used
; 0000 01FE ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 01FF ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0200 
; 0000 0201 // LCD module initialization
; 0000 0202 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0203 
; 0000 0204 // Global enable interrupts
; 0000 0205 #asm("sei")
	sei
; 0000 0206 //for(ii=0;ii<7;ii++)
; 0000 0207 //{
; 0000 0208 //       move_straight();
; 0000 0209 //}
; 0000 020A //turnB();
; 0000 020B //for(ii=0;ii<7;ii++)
; 0000 020C //{
; 0000 020D //       move_straight();
; 0000 020E //}
; 0000 020F    //move_straight();
; 0000 0210 //        move_straight();
; 0000 0211 //        move_straight();
; 0000 0212 //        if(wall_act[R]==FALSE)
; 0000 0213 //        {
; 0000 0214 //         turnR();
; 0000 0215 //          move_straight();
; 0000 0216 //        }
; 0000 0217 //while (1)
; 0000 0218 //      {
; 0000 0219 //        if(wall_act[L]==FALSE)
; 0000 021A //        {
; 0000 021B //         turnL();
; 0000 021C //         move_straight();
; 0000 021D //        }
; 0000 021E //        else if(wall_act[R]==FALSE)
; 0000 021F //        {
; 0000 0220 //         turnR();
; 0000 0221 //         move_straight();
; 0000 0222 //        }
; 0000 0223 //        else if(wall_act[F]==FALSE)
; 0000 0224 //        {
; 0000 0225 //         move_straight();
; 0000 0226 //
; 0000 0227 //         }
; 0000 0228 //        else
; 0000 0229 //        {
; 0000 022A //         turnB();
; 0000 022B //         move_straight();
; 0000 022C //        }
; 0000 022D //
; 0000 022E //
; 0000 022F //
; 0000 0230 //
; 0000 0231 //
; 0000 0232 //
; 0000 0233 //      };
; 0000 0234 
; 0000 0235 solveMaze();
	RCALL _solveMaze
; 0000 0236 }
_0xCB:
	RJMP _0xCB
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

	.CSEG
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	JMP  _0x2080001
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
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
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x7
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0x7
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1F
	LDI  R30,LOW(4)
	CALL SUBOPT_0x1F
	LDI  R30,LOW(133)
	CALL SUBOPT_0x1F
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_step:
	.BYTE 0x4
_step_rev:
	.BYTE 0x4
_rightMotorOn:
	.BYTE 0x2
_leftMotorOn:
	.BYTE 0x2
_left:
	.BYTE 0x2
_right:
	.BYTE 0x2
_center:
	.BYTE 0x2
_steps_remaining:
	.BYTE 0x2
_steps_taken:
	.BYTE 0x2
_wall_infoL:
	.BYTE 0x2
_wall_infoR:
	.BYTE 0x2
_wall_infoF:
	.BYTE 0x2
_wall_act:
	.BYTE 0x3
_error:
	.BYTE 0x2
_MOTOR_DELAY:
	.BYTE 0x1
_mouseR:
	.BYTE 0x1
_mouseC:
	.BYTE 0x1
_ori:
	.BYTE 0x1
_quad:
	.BYTE 0x1
_zone:
	.BYTE 0x1
_pathcount:
	.BYTE 0x1
_deadFlag:
	.BYTE 0x1
_cameFrom:
	.BYTE 0x1
_map:
	.BYTE 0x441
_wall:
	.BYTE 0x4
_wallflood:
	.BYTE 0x100
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1030024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_steps_taken)
	LDI  R27,HIGH(_steps_taken)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDI  R26,LOW(_steps_remaining)
	LDI  R27,HIGH(_steps_remaining)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDS  R26,_steps_remaining
	LDS  R27,_steps_remaining+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x6C)
	LDI  R30,HIGH(0x6C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R30,_steps_taken
	LDS  R31,_steps_taken+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R22,_MOTOR_DELAY
	CLR  R23
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	CALL _read_adc
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ADIW R30,1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x9:
	CALL _m
	LDI  R26,LOW(33)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_map)
	SBCI R31,HIGH(-_map)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xA:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	LDS  R30,_mouseR
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	STS  _ori,R30
	LDS  R30,_deadFlag
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	LDS  R30,_mouseC
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xE:
	LDS  R30,_mouseR
	ST   -Y,R30
	JMP  _m

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDS  R30,_mouseC
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	LDI  R31,0
	SBIW R30,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	CALL __MULW12U
	SUBI R30,LOW(-_map)
	SBCI R31,HIGH(-_map)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x12:
	LDS  R30,_mouseC
	ST   -Y,R30
	JMP  _m

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x13:
	LD   R26,X
	LDS  R30,_pathcount
	LDI  R31,0
	SBIW R30,1
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x14:
	LDS  R30,_mouseR
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	LDI  R31,0
	ADIW R30,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R31,0
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	LDI  R31,0
	SUBI R30,LOW(-_wall)
	SBCI R31,HIGH(-_wall)
	MOVW R22,R30
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	LDI  R31,0
	MOVW R26,R22
	ST   X,R30
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	SBIW R30,1
	LDI  R31,0
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x1B:
	CALL _valInArray
	LDI  R31,0
	SUBI R30,LOW(-_wallflood)
	SBCI R31,HIGH(-_wallflood)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LDS  R30,_mouseR
	ST   -Y,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	SBIW R30,1
	LDI  R31,0
	ST   -Y,R30
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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
