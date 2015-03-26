
;CodeVisionAVR C Compiler V2.03.8a Evaluation
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
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

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
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
	JMP  _timer2_ovf_isr
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
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0xCC,0x66,0x33,0x99
_0x4:
	.DB  0x99,0x33,0x66,0xCC
_0x36:
	.DB  0xF
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
	.DW  0x0A
	.DW  _0x36*2

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

	JMP  _main

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
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 001D #endasm
;#include <lcd.h>
;#include <delay.h>
;
;#define ADC_DELAY 40
;#define TRUE 1
;#define FALSE 0
;#define SHOW_DISPLAY FALSE
;#define ACC_FACTOR 5
;#define SENSOR_TYPE 0
;unsigned char step[4]={0xCC,0x66,0x33,0x99};

	.DSEG
;unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
;unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z;
;unsigned rightMotorOn;
;unsigned leftMotorOn;
;unsigned int left,right,center;
;int error,error0;
;
;unsigned char MOTOR_DELAY=15;
;unsigned char ADC_CENTER;
;
;
;void read(void);
;void show(unsigned int ,unsigned char , unsigned char );
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0037 {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0038    //right motor
; 0000 0039    y++;
	INC  R8
; 0000 003A    if(y>r_overflow && rightMotorOn)
	CP   R4,R8
	BRSH _0x6
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x7
_0x6:
	RJMP _0x5
_0x7:
; 0000 003B    {
; 0000 003C     y=0;
	CLR  R8
; 0000 003D     PORTB=0x00;//step[r_step];
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 003E     r_step++;
	INC  R6
; 0000 003F     if(r_step>3)r_step=0;
	LDI  R30,LOW(3)
	CP   R30,R6
	BRSH _0x8
	CLR  R6
; 0000 0040     delay_ms(5);
_0x8:
	CALL SUBOPT_0x1
; 0000 0041     PORTB=0xAA;
	LDI  R30,LOW(170)
	OUT  0x18,R30
; 0000 0042    }
; 0000 0043 
; 0000 0044    //left motor
; 0000 0045    x++;
_0x5:
	INC  R9
; 0000 0046    if(x>l_overflow && leftMotorOn)
	CP   R5,R9
	BRSH _0xA
	LDS  R30,_leftMotorOn
	LDS  R31,_leftMotorOn+1
	SBIW R30,0
	BRNE _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 0047    {
; 0000 0048     x=0;
	CLR  R9
; 0000 0049     //PORTD=step[l_step];
; 0000 004A     PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 004B     l_step++;
	INC  R7
; 0000 004C     if(l_step > 3)l_step = 0;
	LDI  R30,LOW(3)
	CP   R30,R7
	BRSH _0xC
	CLR  R7
; 0000 004D     delay_ms(5);
_0xC:
	CALL SUBOPT_0x1
; 0000 004E     //PORTD=0xAA;
; 0000 004F    }
; 0000 0050 
; 0000 0051    //acceleration code
; 0000 0052 //  accCounter++;
; 0000 0053 //   if(accCounter>ACC_FACTOR)
; 0000 0054 //   {
; 0000 0055 //     accCounter=0;
; 0000 0056 //       if(MOTOR_DELAY>20)
; 0000 0057 //       MOTOR_DELAY--;
; 0000 0058 //   }
; 0000 0059 
; 0000 005A 
; 0000 005B }
_0x9:
	RJMP _0x35
;
;
;// Timer 2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0060 {
_timer2_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0061 
; 0000 0062    // Place your code here
; 0000 0063    //read sensor
; 0000 0064    z++;
	INC  R11
; 0000 0065    if(z>ADC_DELAY)
	LDI  R30,LOW(40)
	CP   R30,R11
	BRLO PC+3
	JMP _0xD
; 0000 0066    {
; 0000 0067    z=0;
	CLR  R11
; 0000 0068    read();
	RCALL _read
; 0000 0069    //error correction
; 0000 006A    error0=error;
	LDS  R30,_error
	LDS  R31,_error+1
	STS  _error0,R30
	STS  _error0+1,R31
; 0000 006B    if(left < 15 )
	CALL SUBOPT_0x2
	SBIW R26,15
	BRSH _0xE
; 0000 006C         {
; 0000 006D          error = ADC_CENTER-right;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 006E          ADC_CENTER=(ADC_CENTER+right)/2;
	CALL SUBOPT_0x3
	RJMP _0x32
; 0000 006F         }
; 0000 0070    else if(right < 15)
_0xE:
	CALL SUBOPT_0x5
	SBIW R26,15
	BRSH _0x10
; 0000 0071         {
; 0000 0072          error = left-ADC_CENTER;
	LDS  R30,_ADC_CENTER
	CALL SUBOPT_0x6
	STS  _error,R26
	STS  _error+1,R27
; 0000 0073          ADC_CENTER=(left+ADC_CENTER)/2;
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	RJMP _0x33
; 0000 0074         }
; 0000 0075    else
_0x10:
; 0000 0076         {
; 0000 0077          error = left-right;
	CALL SUBOPT_0x5
	LDS  R30,_left
	LDS  R31,_left+1
	CALL SUBOPT_0x4
; 0000 0078          ADC_CENTER=(left+right)/2;
	LDS  R30,_right
	LDS  R31,_right+1
_0x33:
	LDS  R26,_left
	LDS  R27,_left+1
_0x32:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	STS  _ADC_CENTER,R30
; 0000 0079         }
; 0000 007A 
; 0000 007B 
; 0000 007C    if(error>0)r_overflow=MOTOR_DELAY+(error/4);//+(error-error0)/8;
	CALL SUBOPT_0x7
	CALL __CPW02
	BRGE _0x12
	CALL SUBOPT_0x8
	MOVW R26,R22
	ADD  R30,R26
	MOV  R4,R30
; 0000 007D    else if(error<0)l_overflow=MOTOR_DELAY-(error/4);//+(error-error0)/8;
	RJMP _0x13
_0x12:
	LDS  R26,_error+1
	TST  R26
	BRPL _0x14
	CALL SUBOPT_0x8
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	MOV  R5,R30
; 0000 007E //
; 0000 007F //    if(error>0)r_overflow=MOTOR_DELAY+((error*r_overflow)/40);
; 0000 0080 //   else if(error<0)l_overflow=MOTOR_DELAY-((error*l_overflow)/40);
; 0000 0081         if(SHOW_DISPLAY)
_0x14:
_0x13:
; 0000 0082         {
; 0000 0083         show(right,0,0);
; 0000 0084         show(left,10,0);
; 0000 0085         show(center,5,0);
; 0000 0086         }
; 0000 0087    }
; 0000 0088 }
_0xD:
_0x35:
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
;#define ADC_VREF_TYPE 0xE0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0091 {
_read_adc:
; 0000 0092 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 0093 // Delay needed for the stabilization of the ADC input voltage
; 0000 0094 delay_us(10);
	__DELAY_USB 53
; 0000 0095 // Start the AD conversion
; 0000 0096 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0097 // Wait for the AD conversion to complete
; 0000 0098 while ((ADCSRA & 0x10)==0);
_0x16:
	SBIS 0x6,4
	RJMP _0x16
; 0000 0099 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 009A return ADCH;
	IN   R30,0x5
	JMP  _0x2020001
; 0000 009B }
;
; void initialize(void)
; 0000 009E {
_initialize:
; 0000 009F  x=0;
	CLR  R9
; 0000 00A0  y=0;
	CLR  R8
; 0000 00A1  z=0;
	CLR  R11
; 0000 00A2  l_step=0;
	CLR  R7
; 0000 00A3  r_step=0;
	CLR  R6
; 0000 00A4  l_overflow=MOTOR_DELAY;
	MOV  R5,R10
; 0000 00A5  r_overflow=MOTOR_DELAY;
	MOV  R4,R10
; 0000 00A6  rightMotorOn=1;
	CALL SUBOPT_0x9
; 0000 00A7  leftMotorOn=1;
; 0000 00A8 }
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
; 0000 00CA {
_read:
; 0000 00CB  unsigned char i,lo,co,ro;
; 0000 00CC  left=0;
	CALL __SAVELOCR4
;	i -> R17
;	lo -> R16
;	co -> R19
;	ro -> R18
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00CD  center=0;
	STS  _center,R30
	STS  _center+1,R30
; 0000 00CE  right=0;
	STS  _right,R30
	STS  _right+1,R30
; 0000 00CF 
; 0000 00D0  lo=0;
	LDI  R16,LOW(0)
; 0000 00D1  co=0;
	LDI  R19,LOW(0)
; 0000 00D2  ro=0;
	LDI  R18,LOW(0)
; 0000 00D3  if(SENSOR_TYPE==0)
; 0000 00D4  {
; 0000 00D5         lo=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R16,R30
; 0000 00D6         PORTA=PINA|(1<<0);
	IN   R30,0x19
	ORI  R30,1
	OUT  0x1B,R30
; 0000 00D7         left=read_adc(3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0xA
	STS  _left,R30
	STS  _left+1,R31
; 0000 00D8         PORTA=PINA&(~(1<<0));
	IN   R30,0x19
	ANDI R30,0xFE
	OUT  0x1B,R30
; 0000 00D9         left=left-lo;
	MOV  R30,R16
	CALL SUBOPT_0x6
	STS  _left,R26
	STS  _left+1,R27
; 0000 00DA         delay_us(7);
	__DELAY_USB 37
; 0000 00DB 
; 0000 00DC         ro=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R18,R30
; 0000 00DD         PORTA=PINA|(1<<1);
	IN   R30,0x19
	ORI  R30,2
	OUT  0x1B,R30
; 0000 00DE         right=read_adc(4);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xA
	STS  _right,R30
	STS  _right+1,R31
; 0000 00DF         PORTA=PINA&(~(1<<1));
	IN   R30,0x19
	ANDI R30,0xFD
	OUT  0x1B,R30
; 0000 00E0         right=right-ro;
	MOV  R30,R18
	LDI  R31,0
	CALL SUBOPT_0x5
	SUB  R26,R30
	SBC  R27,R31
	STS  _right,R26
	STS  _right+1,R27
; 0000 00E1         delay_us(7);
	__DELAY_USB 37
; 0000 00E2 
; 0000 00E3         co=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R19,R30
; 0000 00E4         PORTA=PINA|(1<<2);
	IN   R30,0x19
	ORI  R30,4
	OUT  0x1B,R30
; 0000 00E5         center=read_adc(5);
	LDI  R30,LOW(5)
	CALL SUBOPT_0xA
	STS  _center,R30
	STS  _center+1,R31
; 0000 00E6         PORTA=PINA&(~(1<<2));
	IN   R30,0x19
	ANDI R30,0xFB
	OUT  0x1B,R30
; 0000 00E7         center=center-co;
	MOV  R30,R19
	LDI  R31,0
	LDS  R26,_center
	LDS  R27,_center+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _center,R26
	STS  _center+1,R27
; 0000 00E8         delay_us(7);
	__DELAY_USB 37
; 0000 00E9  }
; 0000 00EA   if(SENSOR_TYPE==1)
; 0000 00EB   {
; 0000 00EC         left=read_adc(3);
; 0000 00ED         center=read_adc(4);
; 0000 00EE         right=read_adc(5);
; 0000 00EF   }
; 0000 00F0   if(SENSOR_TYPE==2)
; 0000 00F1   {
; 0000 00F2       co=read_adc(2);//front right
; 0000 00F3       right=read_adc(3);//right
; 0000 00F4       left=read_adc(4);//left
; 0000 00F5       center=(read_adc(5)+co)/2;//front left
; 0000 00F6   }
; 0000 00F7 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void show(unsigned int val,unsigned char xx, unsigned char yy)
; 0000 00FA {
_show:
; 0000 00FB  unsigned char a,b,c;
; 0000 00FC  lcd_gotoxy(xx,yy);
	CALL __SAVELOCR4
;	val -> Y+6
;	xx -> Y+5
;	yy -> Y+4
;	a -> R17
;	b -> R16
;	c -> R19
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00FD  a=(val%10)+48;
	CALL SUBOPT_0xB
	CALL __MODW21U
	ADIW R30,48
	MOV  R17,R30
; 0000 00FE  val/=10;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 00FF  b=(val%10)+48;
	CALL __MODW21U
	ADIW R30,48
	MOV  R16,R30
; 0000 0100  val/=10;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0101  c=(val%10)+48;
	CALL __MODW21U
	ADIW R30,48
	MOV  R19,R30
; 0000 0102 // val/=10;
; 0000 0103 // d=(val%10)+48;
; 0000 0104 // lcd_putchar(d);
; 0000 0105  lcd_putchar(c);
	ST   -Y,R19
	CALL _lcd_putchar
; 0000 0106  lcd_putchar(b);
	ST   -Y,R16
	CALL _lcd_putchar
; 0000 0107  lcd_putchar(a);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 0108 
; 0000 0109 }
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;
;void turnBack(void)
; 0000 010C {
; 0000 010D     unsigned char i;
; 0000 010E     rightMotorOn=0;
;	i -> R17
; 0000 010F           leftMotorOn=0;
; 0000 0110 
; 0000 0111     for(i=0;i<150;i++)
; 0000 0112     {
; 0000 0113 
; 0000 0114     PORTB=step[r_step];
; 0000 0115     r_step++;
; 0000 0116     if(r_step>3)r_step=0;
; 0000 0117 
; 0000 0118     PORTD=step_rev[l_step];
; 0000 0119     l_step++;
; 0000 011A     if(l_step > 3)l_step = 0;
; 0000 011B 
; 0000 011C         delay_ms(4);
; 0000 011D     }
; 0000 011E     rightMotorOn=1;
; 0000 011F     leftMotorOn=1;
; 0000 0120 }
;void turnRight(void)
; 0000 0122 {
_turnRight:
; 0000 0123         unsigned char i;
; 0000 0124 
; 0000 0125     rightMotorOn=0;
	ST   -Y,R17
;	i -> R17
	CLR  R12
	CLR  R13
; 0000 0126           leftMotorOn=0;
	LDI  R30,LOW(0)
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R30
; 0000 0127 
; 0000 0128     for(i=0;i<75;i++)
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,75
	BRSH _0x23
; 0000 0129     {
; 0000 012A 
; 0000 012B     PORTB=step_rev[r_step];
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
	LD   R30,Z
	OUT  0x18,R30
; 0000 012C     r_step++;
	INC  R6
; 0000 012D     if(r_step>3)r_step=0;
	LDI  R30,LOW(3)
	CP   R30,R6
	BRSH _0x24
	CLR  R6
; 0000 012E 
; 0000 012F     PORTD=step[l_step];
_0x24:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	LD   R30,Z
	OUT  0x12,R30
; 0000 0130     l_step++;
	INC  R7
; 0000 0131     if(l_step > 3)l_step = 0;
	LDI  R30,LOW(3)
	CP   R30,R7
	BRSH _0x25
	CLR  R7
; 0000 0132 
; 0000 0133         delay_ms(2);
_0x25:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0134     }
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 0135     rightMotorOn=1;
	CALL SUBOPT_0x9
; 0000 0136     leftMotorOn=1;
; 0000 0137 }
	LD   R17,Y+
	RET
;
;void turnLeft(void)
; 0000 013A {
; 0000 013B     unsigned char i;
; 0000 013C     rightMotorOn=0;
;	i -> R17
; 0000 013D           leftMotorOn=0;
; 0000 013E 
; 0000 013F 
; 0000 0140     for(i=0;i<75;i++)
; 0000 0141     {
; 0000 0142 
; 0000 0143     PORTB=step[r_step];
; 0000 0144     r_step++;
; 0000 0145     if(r_step>3)r_step=0;
; 0000 0146 
; 0000 0147     PORTD=step_rev[l_step];
; 0000 0148     l_step++;
; 0000 0149     if(l_step > 3)l_step = 0;
; 0000 014A 
; 0000 014B         delay_ms(4);
; 0000 014C     }
; 0000 014D 
; 0000 014E     rightMotorOn=1;
; 0000 014F     leftMotorOn=1;
; 0000 0150 
; 0000 0151 }
;
;// Declare your global variables here
;
;void main(void)
; 0000 0156 {
_main:
; 0000 0157 // Declare your local variables here
; 0000 0158 
; 0000 0159 // Input/Output Ports initialization
; 0000 015A // Port A initialization
; 0000 015B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 015C // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 015D PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 015E if(SENSOR_TYPE==2)DDRA=0x00;
; 0000 015F else DDRA=0x07;
	LDI  R30,LOW(7)
_0x34:
	OUT  0x1A,R30
; 0000 0160 
; 0000 0161 // Port B initialization
; 0000 0162 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0163 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0164 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0165 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0166 
; 0000 0167 // Port C initialization
; 0000 0168 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0169 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 016A PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 016B DDRC=0x00;
	OUT  0x14,R30
; 0000 016C 
; 0000 016D // Port D initialization
; 0000 016E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 016F // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0170 PORTD=0x00;
	OUT  0x12,R30
; 0000 0171 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0172 initialize();
	RCALL _initialize
; 0000 0173 
; 0000 0174 // Timer/Counter 0 initialization
; 0000 0175 // Clock source: System Clock
; 0000 0176 // Clock value: 2000.000 kHz
; 0000 0177 // Mode: Normal top=FFh
; 0000 0178 // OC0 output: Disconnected
; 0000 0179 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 017A TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 017B OCR0=0x00;
	OUT  0x3C,R30
; 0000 017C 
; 0000 017D // Timer/Counter 1 initialization
; 0000 017E // Clock source: System Clock
; 0000 017F // Clock value: Timer 1 Stopped
; 0000 0180 // Mode: Normal top=FFFFh
; 0000 0181 // OC1A output: Discon.
; 0000 0182 // OC1B output: Discon.
; 0000 0183 // Noise Canceler: Off
; 0000 0184 // Input Capture on Falling Edge
; 0000 0185 // Timer 1 Overflow Interrupt: Off
; 0000 0186 // Input Capture Interrupt: Off
; 0000 0187 // Compare A Match Interrupt: Off
; 0000 0188 // Compare B Match Interrupt: Off
; 0000 0189 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 018A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 018B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 018C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 018D ICR1H=0x00;
	OUT  0x27,R30
; 0000 018E ICR1L=0x00;
	OUT  0x26,R30
; 0000 018F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0190 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0191 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0192 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0193 
; 0000 0194 // Timer/Counter 2 initialization
; 0000 0195 // Clock source: System Clock
; 0000 0196 // Clock value: 2000.000 kHz
; 0000 0197 // Mode: Normal top=FFh
; 0000 0198 // OC2 output: Disconnected
; 0000 0199 ASSR=0x00;
	OUT  0x22,R30
; 0000 019A TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 019B TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 019C OCR2=0x00;
	OUT  0x23,R30
; 0000 019D 
; 0000 019E // External Interrupt(s) initialization
; 0000 019F // INT0: Off
; 0000 01A0 // INT1: Off
; 0000 01A1 // INT2: Off
; 0000 01A2 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01A3 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01A4 
; 0000 01A5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01A6 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01A7 
; 0000 01A8 // Analog Comparator initialization
; 0000 01A9 // Analog Comparator: Off
; 0000 01AA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01AB ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AC SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01AD 
; 0000 01AE // ADC initialization
; 0000 01AF // ADC Clock frequency: 125.000 kHz
; 0000 01B0 // ADC Voltage Reference: Int., cap. on AREF
; 0000 01B1 // ADC Auto Trigger Source: None
; 0000 01B2 // Only the 8 most significant bits of
; 0000 01B3 // the AD conversion result are used
; 0000 01B4 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 01B5 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01B6 
; 0000 01B7 // LCD module initialization
; 0000 01B8 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01B9 
; 0000 01BA // Global enable interrupts
; 0000 01BB #asm("sei")
	sei
; 0000 01BC   //PORTB=0xAA;
; 0000 01BD   //PORTD=0x55;
; 0000 01BE while (1)
_0x2D:
; 0000 01BF       {
; 0000 01C0        //Place your code here
; 0000 01C1 //      if(center>90 && left <15)
; 0000 01C2 //        turnLeft();
; 0000 01C3 //       else
; 0000 01C4 //      if(center>90 && right <15)
; 0000 01C5 //        turnRight();
; 0000 01C6 //        else
; 0000 01C7       if(center>90)
	LDS  R26,_center
	LDS  R27,_center+1
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLO _0x30
; 0000 01C8         turnRight();
	RCALL _turnRight
; 0000 01C9 
; 0000 01CA 
; 0000 01CB       };
_0x30:
	RJMP _0x2D
; 0000 01CC }
_0x31:
	RJMP _0x31
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
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0xD
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
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
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
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
	RCALL SUBOPT_0xD
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G100,2
	RCALL SUBOPT_0xD
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xE
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0xF
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xF
	LDI  R30,LOW(133)
	RCALL SUBOPT_0xF
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_left
	LDS  R27,_left+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDS  R30,_ADC_CENTER
	LDI  R31,0
	LDS  R26,_right
	LDS  R27,_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R26,_right
	LDS  R27,_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R31,0
	RCALL SUBOPT_0x2
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDS  R26,_error
	LDS  R27,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOV  R22,R10
	CLR  R23
	RCALL SUBOPT_0x7
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	STS  _leftMotorOn,R30
	STS  _leftMotorOn+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	CALL _read_adc
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
