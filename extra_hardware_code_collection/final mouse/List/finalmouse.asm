
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
_0x0:
	.DB  0x4C,0x74,0x0,0x6E,0x6F,0x0,0x52,0x74
	.DB  0x0,0x46,0x72,0x0
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
;#define ADC_CENTRE 105 //62
;#define ADC_MIN_LEFT 5 //40
;#define ADC_MIN_RIGHT 5 //20
;#define L 0
;#define F 1
;#define R 2
;
;
;#define TRUE 1
;#define FALSE 0
;#define SHOW_DISPLAY TRUE
;#define ACC_FACTOR 100
;#define SENSOR_TYPE 1
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
;unsigned char wall[3];
;int error,error0;
;
;unsigned char MOTOR_DELAY=30;
;#define ADC_DELAY 40
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
	CALL SUBOPT_0x0
	BRNE _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0056    {
; 0000 0057     y=0;
	CLR  R8
; 0000 0058 
; 0000 0059     if(dirR)PORTB=step[r_step];
	TST  R13
	BREQ _0x9
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	RJMP _0x65
; 0000 005A     else PORTB=step_rev[r_step];
_0x9:
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_step_rev)
	SBCI R31,HIGH(-_step_rev)
_0x65:
	LD   R30,Z
	OUT  0x18,R30
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
	CALL SUBOPT_0x1
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
	CALL SUBOPT_0x0
	BRNE _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 0065    {
; 0000 0066     x=0;
	CLR  R9
; 0000 0067 
; 0000 0068     if(dirL)PORTD=step[l_step];
; 0000 0069     else  PORTD=step[l_step];
_0x66:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_step)
	SBCI R31,HIGH(-_step)
	LD   R30,Z
	OUT  0x12,R30
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
	CALL SUBOPT_0x1
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
	LDI  R30,LOW(40)
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
	SBIW R26,6
	BRLO _0x13
; 0000 008C         {
; 0000 008D           if(steps_remaining<200&&steps_remaining>107){wall_infoL+=steps_taken;}
	CALL SUBOPT_0x2
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x15
	CALL SUBOPT_0x3
	BRSH _0x16
_0x15:
	RJMP _0x14
_0x16:
	CALL SUBOPT_0x4
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
	CALL SUBOPT_0x2
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x19
	CALL SUBOPT_0x3
	BRSH _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	CALL SUBOPT_0x4
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
	SBIW R26,6
	BRLO _0x1B
; 0000 0094         {
; 0000 0095 	  if(steps_remaining<200&&steps_remaining>107){wall_infoR+=steps_taken;}
	CALL SUBOPT_0x2
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRSH _0x1D
	CALL SUBOPT_0x3
	BRSH _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
	CALL SUBOPT_0x4
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
	CPI  R17,5
	BRSH _0x20
	LDI  R17,LOW(105)
; 0000 009C         if(lTemp<ADC_MIN_LEFT){lTemp = ADC_CENTRE;}
_0x20:
	CPI  R16,5
	BRSH _0x21
	LDI  R16,LOW(105)
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
	CALL SUBOPT_0x5
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	MOV  R5,R30
; 0000 00A1 	//if(error<0)
; 0000 00A2         r_overflow=MOTOR_DELAY+(error/8);
	CALL SUBOPT_0x5
	MOVW R26,R22
	ADD  R30,R26
	MOV  R4,R30
; 0000 00A3 
; 0000 00A4         if(SHOW_DISPLAY)
; 0000 00A5         {
; 0000 00A6          //putchar(0xFF);
; 0000 00A7          //putchar(left);
; 0000 00A8          //putchar(center);
; 0000 00A9          //putchar(right);
; 0000 00AA         show(right,0,0);
	LDS  R30,_right
	LDS  R31,_right+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6
; 0000 00AB         show(left,10,0);
	LDS  R30,_left
	LDS  R31,_left+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	CALL SUBOPT_0x6
; 0000 00AC         show(center,5,0);
	LDS  R30,_center
	LDS  R31,_center+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	CALL SUBOPT_0x6
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
	JMP  _0x2080001
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
; 0000 00D2  //dirL=1;
; 0000 00D3  //dirR=1;
; 0000 00D4 }
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
; 0000 00F6 {
_read:
; 0000 00F7  unsigned char i,lo,co,ro;
; 0000 00F8  left=0;
	CALL __SAVELOCR4
;	i -> R17
;	lo -> R16
;	co -> R19
;	ro -> R18
	LDI  R30,LOW(0)
	STS  _left,R30
	STS  _left+1,R30
; 0000 00F9  center=0;
	STS  _center,R30
	STS  _center+1,R30
; 0000 00FA  right=0;
	STS  _right,R30
	STS  _right+1,R30
; 0000 00FB 
; 0000 00FC  lo=0;
	LDI  R16,LOW(0)
; 0000 00FD  co=0;
	LDI  R19,LOW(0)
; 0000 00FE  ro=0;
	LDI  R18,LOW(0)
; 0000 00FF  if(SENSOR_TYPE==0)
; 0000 0100  {
; 0000 0101         lo=read_adc(3);
; 0000 0102         PORTA=PINA|(1<<0);
; 0000 0103         left=read_adc(3);
; 0000 0104         PORTA=PINA&(~(1<<0));
; 0000 0105         left=left-lo;
; 0000 0106         delay_us(7);
; 0000 0107 
; 0000 0108         ro=read_adc(4);
; 0000 0109         PORTA=PINA|(1<<1);
; 0000 010A         right=read_adc(4);
; 0000 010B         PORTA=PINA&(~(1<<1));
; 0000 010C         right=right-ro;
; 0000 010D         delay_us(7);
; 0000 010E 
; 0000 010F         co=read_adc(5);
; 0000 0110         PORTA=PINA|(1<<2);
; 0000 0111         center=read_adc(5);
; 0000 0112         PORTA=PINA&(~(1<<2));
; 0000 0113         center=center-co;
; 0000 0114         delay_us(7);
; 0000 0115  }
; 0000 0116   if(SENSOR_TYPE==1)
; 0000 0117   {
; 0000 0118         left=read_adc(5);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x7
	STS  _left,R30
	STS  _left+1,R31
; 0000 0119         center=read_adc(6);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
	STS  _center,R30
	STS  _center+1,R31
; 0000 011A         right=read_adc(7);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x7
	STS  _right,R30
	STS  _right+1,R31
; 0000 011B   }
; 0000 011C   if(SENSOR_TYPE==2)
; 0000 011D   {
; 0000 011E       co=read_adc(2);//front right
; 0000 011F       right=read_adc(3);//right
; 0000 0120       left=read_adc(4);//left
; 0000 0121       center=(read_adc(5)+co)/2;//front left
; 0000 0122   }
; 0000 0123 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void show(unsigned int val,unsigned char xx, unsigned char yy)
; 0000 0126 {
_show:
; 0000 0127  unsigned char a,b,c;
; 0000 0128  lcd_gotoxy(xx,yy);
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
; 0000 0129  a=(val%10)+48;
	CALL SUBOPT_0x8
	CALL __MODW21U
	ADIW R30,48
	MOV  R17,R30
; 0000 012A  val/=10;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 012B  b=(val%10)+48;
	CALL __MODW21U
	ADIW R30,48
	MOV  R16,R30
; 0000 012C  val/=10;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 012D  c=(val%10)+48;
	CALL __MODW21U
	ADIW R30,48
	MOV  R19,R30
; 0000 012E // val/=10;
; 0000 012F // d=(val%10)+48;
; 0000 0130 // lcd_putchar(d);
; 0000 0131  lcd_putchar(c);
	ST   -Y,R19
	CALL _lcd_putchar
; 0000 0132  lcd_putchar(b);
	ST   -Y,R16
	CALL _lcd_putchar
; 0000 0133  lcd_putchar(a);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 0134 
; 0000 0135 }
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;
;
;void turnR(void)
; 0000 0139   {while(steps_remaining){}
; 0000 013A   while(steps_remaining){}
; 0000 013B   dirL=1;
; 0000 013C   dirR=0;
; 0000 013D 
; 0000 013E   steps_remaining=160;
; 0000 013F   while(steps_remaining){}
; 0000 0140   while(steps_remaining){}
; 0000 0141   }
;
;  void turnL(void)
; 0000 0144   {while(steps_remaining){}
; 0000 0145   while(steps_remaining){}
; 0000 0146 
; 0000 0147   dirR=1;
; 0000 0148   dirL=0;
; 0000 0149   steps_remaining=160;
; 0000 014A   while(steps_remaining){}
; 0000 014B   while(steps_remaining){}
; 0000 014C   }
; void turnB(void)
; 0000 014E   {while(steps_remaining){}
; 0000 014F   while(steps_remaining){}
; 0000 0150   dirL=1;
; 0000 0151   dirR=0;
; 0000 0152 
; 0000 0153   steps_remaining=305;
; 0000 0154   while(steps_remaining){}
; 0000 0155   while(steps_remaining){}
; 0000 0156   }
;
; void move_straight(void)
; 0000 0159  {
_move_straight:
; 0000 015A   while(steps_remaining){}
_0x4D:
	CALL SUBOPT_0x0
	BRNE _0x4D
; 0000 015B   while(steps_remaining){}
_0x50:
	CALL SUBOPT_0x0
	BRNE _0x50
; 0000 015C   wall_infoL = 0;
	LDI  R30,LOW(0)
	STS  _wall_infoL,R30
	STS  _wall_infoL+1,R30
; 0000 015D   wall_infoR = 0;
	STS  _wall_infoR,R30
	STS  _wall_infoR+1,R30
; 0000 015E   wall_infoF = 0;
	STS  _wall_infoF,R30
	STS  _wall_infoF+1,R30
; 0000 015F   dirR=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0160   dirL=1;
	MOV  R12,R30
; 0000 0161   steps_remaining=436;
	LDI  R30,LOW(436)
	LDI  R31,HIGH(436)
	STS  _steps_remaining,R30
	STS  _steps_remaining+1,R31
; 0000 0162 
; 0000 0163   while(steps_remaining){}
_0x53:
	CALL SUBOPT_0x0
	BRNE _0x53
; 0000 0164   while(steps_remaining){}
_0x56:
	CALL SUBOPT_0x0
	BRNE _0x56
; 0000 0165 
; 0000 0166       if(wall_infoL>70)
	LDS  R26,_wall_infoL
	LDS  R27,_wall_infoL+1
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRLO _0x59
; 0000 0167       {
; 0000 0168        lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0169        lcd_putsf("Lt");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0xB
; 0000 016A        wall[0]=TRUE;
	LDI  R30,LOW(1)
	RJMP _0x67
; 0000 016B       }
; 0000 016C       else
_0x59:
; 0000 016D       {
; 0000 016E        lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 016F        lcd_putsf("no");
	CALL SUBOPT_0xC
; 0000 0170          wall[0]=FALSE;
	LDI  R30,LOW(0)
_0x67:
	STS  _wall,R30
; 0000 0171       }
; 0000 0172       if(wall_infoR>70)
	LDS  R26,_wall_infoR
	LDS  R27,_wall_infoR+1
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	BRLO _0x5B
; 0000 0173       {
; 0000 0174        lcd_gotoxy(12,1);
	CALL SUBOPT_0xD
; 0000 0175        lcd_putsf("Rt");
	__POINTW1FN _0x0,6
	CALL SUBOPT_0xB
; 0000 0176         wall[2]=TRUE;
	LDI  R30,LOW(1)
	RJMP _0x68
; 0000 0177       }
; 0000 0178       else
_0x5B:
; 0000 0179       {
; 0000 017A        lcd_gotoxy(12,1);
	CALL SUBOPT_0xD
; 0000 017B        lcd_putsf("no");
	CALL SUBOPT_0xC
; 0000 017C         wall[2]=FALSE;
	LDI  R30,LOW(0)
_0x68:
	__PUTB1MN _wall,2
; 0000 017D       }
; 0000 017E       if(wall_infoF>50)
	LDS  R26,_wall_infoF
	LDS  R27,_wall_infoF+1
	SBIW R26,51
	BRLO _0x5D
; 0000 017F       {
; 0000 0180        lcd_gotoxy(5,1);
	CALL SUBOPT_0xE
; 0000 0181        lcd_putsf("Fr");
	__POINTW1FN _0x0,9
	CALL SUBOPT_0xB
; 0000 0182         wall[1]=TRUE;
	LDI  R30,LOW(1)
	RJMP _0x69
; 0000 0183       }
; 0000 0184       else
_0x5D:
; 0000 0185       {
; 0000 0186         lcd_gotoxy(5,1);
	CALL SUBOPT_0xE
; 0000 0187         lcd_putsf("no");
	CALL SUBOPT_0xC
; 0000 0188          wall[1]=FALSE;
	LDI  R30,LOW(0)
_0x69:
	__PUTB1MN _wall,1
; 0000 0189       }
; 0000 018A   }
	RET
;// Declare your global variables here
;
;void main(void)
; 0000 018E {
_main:
; 0000 018F // Declare your local variables here
; 0000 0190 int ii;
; 0000 0191 
; 0000 0192 // Input/Output Ports initialization
; 0000 0193 // Port A initialization
; 0000 0194 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0195 // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 0196 PORTA=0x00;
;	ii -> R16,R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0197 if(SENSOR_TYPE==2)DDRA=0x00;
; 0000 0198 else DDRA=0x07;
	LDI  R30,LOW(7)
_0x6A:
	OUT  0x1A,R30
; 0000 0199 
; 0000 019A // Port B initialization
; 0000 019B // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 019C // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 019D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 019E DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 019F 
; 0000 01A0 // Port C initialization
; 0000 01A1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01A3 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01A4 DDRC=0x00;
	OUT  0x14,R30
; 0000 01A5 
; 0000 01A6 // Port D initialization
; 0000 01A7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 01A8 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 01A9 PORTD=0x00;
	OUT  0x12,R30
; 0000 01AA DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 01AB initialize();
	RCALL _initialize
; 0000 01AC 
; 0000 01AD // Timer/Counter 0 initialization
; 0000 01AE // Clock source: System Clock
; 0000 01AF // Clock value: 2000.000 kHz
; 0000 01B0 // Mode: Normal top=FFh
; 0000 01B1 // OC0 output: Disconnected
; 0000 01B2 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 01B3 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01B4 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01B5 
; 0000 01B6 // Timer/Counter 1 initialization
; 0000 01B7 // Clock source: System Clock
; 0000 01B8 // Clock value: Timer 1 Stopped
; 0000 01B9 // Mode: Normal top=FFFFh
; 0000 01BA // OC1A output: Discon.
; 0000 01BB // OC1B output: Discon.
; 0000 01BC // Noise Canceler: Off
; 0000 01BD // Input Capture on Falling Edge
; 0000 01BE // Timer 1 Overflow Interrupt: Off
; 0000 01BF // Input Capture Interrupt: Off
; 0000 01C0 // Compare A Match Interrupt: Off
; 0000 01C1 // Compare B Match Interrupt: Off
; 0000 01C2 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01C3 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01C4 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01C5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01C6 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01C7 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01C8 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01C9 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01CA OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01CB OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01CC 
; 0000 01CD // Timer/Counter 2 initialization
; 0000 01CE // Clock source: System Clock
; 0000 01CF // Clock value: 2000.000 kHz
; 0000 01D0 // Mode: Normal top=FFh
; 0000 01D1 // OC2 output: Disconnected
; 0000 01D2 ASSR=0x00;
	OUT  0x22,R30
; 0000 01D3 TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 01D4 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01D5 OCR2=0x00;
	OUT  0x23,R30
; 0000 01D6 
; 0000 01D7 // External Interrupt(s) initialization
; 0000 01D8 // INT0: Off
; 0000 01D9 // INT1: Off
; 0000 01DA // INT2: Off
; 0000 01DB MCUCR=0x00;
	OUT  0x35,R30
; 0000 01DC MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01DD 
; 0000 01DE // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01DF TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 01E0 
; 0000 01E1 // USART initialization
; 0000 01E2 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E3 // USART Receiver: Off
; 0000 01E4 // USART Transmitter: On
; 0000 01E5 // USART Mode: Asynchronous
; 0000 01E6 // USART Baud Rate: 19200
; 0000 01E7 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01E8 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 01E9 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01EA UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01EB UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01EC // Analog Comparator initialization
; 0000 01ED // Analog Comparator: Off
; 0000 01EE // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01EF ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01F0 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01F1 
; 0000 01F2 // ADC initialization
; 0000 01F3 // ADC Clock frequency: 125.000 kHz
; 0000 01F4 // ADC Voltage Reference: Int., cap. on AREF
; 0000 01F5 // ADC Auto Trigger Source: None
; 0000 01F6 // Only the 8 most significant bits of
; 0000 01F7 // the AD conversion result are used
; 0000 01F8 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 01F9 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01FA 
; 0000 01FB // LCD module initialization
; 0000 01FC lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01FD 
; 0000 01FE // Global enable interrupts
; 0000 01FF #asm("sei")
	sei
; 0000 0200 //for(ii=0;ii<7;ii++)
; 0000 0201 //{
; 0000 0202 //       move_straight();
; 0000 0203 //}
; 0000 0204 //turnB();
; 0000 0205 //for(ii=0;ii<7;ii++)
; 0000 0206 //{
; 0000 0207 //       move_straight();
; 0000 0208 //}
; 0000 0209 move_straight();
	RCALL _move_straight
; 0000 020A while (1)
_0x61:
; 0000 020B       {
; 0000 020C //        if(wall[2]==TRUE)
; 0000 020D //        {
; 0000 020E //         turnR();
; 0000 020F //         move_straight();
; 0000 0210 //        }
; 0000 0211 //        else  if(wall[0]==TRUE)
; 0000 0212 //        {
; 0000 0213 //         turnL();
; 0000 0214 //         move_straight();
; 0000 0215 //        }
; 0000 0216 //        else  if(wall[1]==TRUE)
; 0000 0217 //        {
; 0000 0218 //         turnB();
; 0000 0219 //         move_straight();
; 0000 021A //         }
; 0000 021B //        else
; 0000 021C //        {
; 0000 021D //         move_straight();
; 0000 021E //        }
; 0000 021F 
; 0000 0220 
; 0000 0221 
; 0000 0222 
; 0000 0223 
; 0000 0224 
; 0000 0225 
; 0000 0226       };
	RJMP _0x61
; 0000 0227 }
_0x64:
	RJMP _0x64
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

	.CSEG
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
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0xF
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
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
	BRSH _0x2020004
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
_0x2020004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
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
	CALL SUBOPT_0xF
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0xF
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x11
	LDI  R30,LOW(4)
	CALL SUBOPT_0x11
	LDI  R30,LOW(133)
	CALL SUBOPT_0x11
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
_wall:
	.BYTE 0x3
_error:
	.BYTE 0x2
_MOTOR_DELAY:
	.BYTE 0x1
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	LDS  R30,_steps_remaining
	LDS  R31,_steps_remaining+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
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
SUBOPT_0x2:
	LDS  R26,_steps_remaining
	LDS  R27,_steps_remaining+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x6C)
	LDI  R30,HIGH(0x6C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,_steps_taken
	LDS  R31,_steps_taken+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDS  R22,_MOTOR_DELAY
	CLR  R23
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _show

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL _read_adc
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__POINTW1FN _0x0,3
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
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
