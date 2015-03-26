/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.8a Evaluation
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/17/2008
Author  : Freeware, for evaluation and non-commercial use only
Company : 
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega32.h>
#include <stdio.h>
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>


#define BITx (1<<x)
#define CHECKBIT(x,b) (x&b)
#define SETBIT(x,b) x=x|b;
#define CLEARBIT(x,b) x=x&(~b);
#define TOGGLEBIT(x,b) x=x^b;
#define BIT0 0x01                                        
#define BIT1 0x02
#define BIT2 0x04
#define BIT3 0x08                   
#define BIT4 0x10
#define BIT5 0x20
#define BIT6 0x40
#define BIT7 0x80

#define ADC_MIN_FRONT 50
#define ADC_CENTRE 62 //105 //62 
#define ADC_MIN_LEFT 20 //5 //40
#define ADC_MIN_RIGHT 20 //5 //20
#define L 0
#define F 1
#define R 2


#define TRUE 1
#define FALSE 0
#define SHOW_DISPLAY TRUE
#define ACC_FACTOR 100
#define SENSOR_TYPE 0
unsigned char step[4]={0xCC,0x66,0x33,0x99};
unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z,accCounter;
unsigned char dirR,dirL;
unsigned rightMotorOn;
unsigned leftMotorOn;
unsigned int left,right,center;

unsigned int volatile steps_remaining,steps_taken;
unsigned int volatile wall_infoL,wall_infoR,wall_infoF;
unsigned char wall_act[3];
int error,error0;

unsigned char MOTOR_DELAY=30;
#define ADC_DELAY 60


void read(void);
void show(unsigned int ,unsigned char , unsigned char );
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
   //right motor
   y++;
   if(y>r_overflow && steps_remaining)
   {
    y=0;
    
    if(dirR)PORTD=step[r_step];
    else PORTD=step_rev[r_step];
    
    r_step++;
    if(r_step>3)r_step=0;
    steps_taken++;    
    steps_remaining--;
   }
   
   //left motor
   x++;
   if(x>l_overflow && steps_remaining)
   {
    x=0;
    
    if(dirL)PORTB=step[l_step];
    else  PORTB=step[l_step];
    
    l_step++;
    if(l_step > 3)l_step = 0;
    steps_taken++;    
    steps_remaining--;
   }
   
   //acceleration code
//  accCounter++;
//   if(accCounter>ACC_FACTOR)
//   {
//     accCounter=0;
//      if(MOTOR_DELAY>20)
//       MOTOR_DELAY--;
//   }
   
   
}


// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    unsigned char rTemp,lTemp;
   // Place your code here
   //read sensor
   z++;
   if(z>ADC_DELAY)
   {
        z=0;
        read();
        
        //get wall information
        if(left>ADC_MIN_LEFT) 
        {
          if(steps_remaining<200&&steps_remaining>107){wall_infoL+=steps_taken;}
	}
	if(center>ADC_MIN_FRONT) 
        {
	 if(steps_remaining<200&&steps_remaining>107){wall_infoF+=steps_taken;}
	}
	if(right>ADC_MIN_RIGHT) 
        {
	  if(steps_remaining<200&&steps_remaining>107){wall_infoR+=steps_taken;}
	}
	else {CLEARBIT(PORTC,BIT1);}   
        //error correction
        rTemp=right;
        lTemp=left;
        if(rTemp<ADC_MIN_RIGHT){rTemp= ADC_CENTRE;}    
        if(lTemp<ADC_MIN_LEFT){lTemp = ADC_CENTRE;}
        error = lTemp-rTemp;
        
	//if(error>0)
        l_overflow=MOTOR_DELAY-(error/8);
	//if(error<0)
        r_overflow=MOTOR_DELAY+(error/8);
        
        if(SHOW_DISPLAY)
        {
         putchar(0xFF);
         putchar(left);
         putchar(center);
         putchar(right);
        //show(right,0,0);
        //show(left,10,0);
        //show(center,5,0);
        }
   }
}

#include <delay.h>

#define ADC_VREF_TYPE 0x60

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

 void initialize(void)
{
 x=0;
 y=0;
 z=0;
 l_step=0;
 r_step=0;
 l_overflow=MOTOR_DELAY;
 r_overflow=MOTOR_DELAY;
 rightMotorOn=1;
 leftMotorOn=1;
 steps_remaining=0;
 steps_remaining=0;
 accCounter=0;
wall_act[L]=TRUE;
wall_act[R]=TRUE;
wall_act[F]=FALSE;
 //dirL=1;
 //dirR=1;
}
//void read(void)
//{
// unsigned char i;
// left=0;
// center=0;
// right=0;
// for(i=0;i<2;i++)
// {
// PORTA=PINA|(1<<0);
// left+=read_adc(3);
// PORTA=PINA&(~(1<<0));
// delay_us(7);
// }
//for(i=0;i<2;i++)
// {
// PORTA=PINA|(1<<1);
// right+=read_adc(4);
// PORTA=PINA&(~(1<<1));
// delay_us(7);
// }
//for(i=0;i<2;i++)
// {
// PORTA=PINA|(1<<2);
// center+=read_adc(5);
// PORTA=PINA&(~(1<<2));
// delay_us(7);
// }
//left/=2;
//right/=2;
//center/=2;  
//}

void read(void)
{
 unsigned char lo,co,ro;
 left=0;
 center=0;
 right=0;
 
 lo=0;
 co=0;
 ro=0;
 if(SENSOR_TYPE==0)
 {
        lo=read_adc(3); 
        PORTA=PINA|(1<<0);
        left=read_adc(3);
        PORTA=PINA&(~(1<<0));
        left=left-lo;
        delay_us(7);
  
        ro=read_adc(4);
        PORTA=PINA|(1<<1);
        right=read_adc(4);
        PORTA=PINA&(~(1<<1));
        right=right-ro;
        delay_us(7);

        co=read_adc(5);
        PORTA=PINA|(1<<2);
        center=read_adc(5);
        PORTA=PINA&(~(1<<2));
        center=center-co;
        delay_us(7);
 }
  if(SENSOR_TYPE==1)
  {
        left=read_adc(5);
        center=read_adc(6);
        right=read_adc(7); 
  }
  if(SENSOR_TYPE==2)
  {
      co=read_adc(2);//front right
      right=read_adc(3);//right 
      left=read_adc(4);//left
      center=(read_adc(5)+co)/2;//front left 
  }  
}

void show(unsigned int val,unsigned char xx, unsigned char yy)
{
 unsigned char a,b,c;
 lcd_gotoxy(xx,yy);
 a=(val%10)+48;
 val/=10;
 b=(val%10)+48;
 val/=10;
 c=(val%10)+48;
// val/=10;
// d=(val%10)+48;
// lcd_putchar(d);
 lcd_putchar(c);
 lcd_putchar(b);
 lcd_putchar(a);
 
}

void turnR(void)
  {while(steps_remaining){}
  while(steps_remaining){}
  dirL=1;
  dirR=0;
 
  steps_remaining=160;
  while(steps_remaining){}
  while(steps_remaining){}
  }
                                           
  void turnL(void)
  {while(steps_remaining){}
  while(steps_remaining){}

  dirR=1;
  dirL=0;
  steps_remaining=160;
  while(steps_remaining){}
  while(steps_remaining){}
  }
 void turnB(void)
  {while(steps_remaining){}
  while(steps_remaining){}
  dirL=1;
  dirR=0;
 
  steps_remaining=305;
  while(steps_remaining){}
  while(steps_remaining){}
  }

 void move_straight(void)
 {
  while(steps_remaining){}
  while(steps_remaining){}  
  wall_infoL = 0;
  wall_infoR = 0;
  wall_infoF = 0;
  dirR=1;
  dirL=1;
  steps_remaining=436; //424
  
  while(steps_remaining){}
  while(steps_remaining){}
  
      if(wall_infoL>70)
      {
       //lcd_gotoxy(12,1);
       //lcd_putsf("Lt");
       wall_act[L]=TRUE;
      }
      else
      {
       //lcd_gotoxy(12,1);
       //lcd_putsf("no");
         wall_act[L]=FALSE;
      }
      if(wall_infoR>70)
      {
       //lcd_gotoxy(0,1);
       //lcd_putsf("Rt");
        wall_act[R]=TRUE;
      }
      else
      {
       //lcd_gotoxy(0,1);
       //lcd_putsf("no");
        wall_act[R]=FALSE;
      }
      if(wall_infoF>20)
      { 
       //lcd_gotoxy(5,1);
       //lcd_putsf("Fr");
        wall_act[F]=TRUE;
      }
      else
      {
        //lcd_gotoxy(5,1);
        //lcd_putsf("no");
         wall_act[F]=FALSE;
      }
  }
// Declare your global variables here
unsigned char readSensors()
{
        return((wall_act[L]*100)+(wall_act[F]*10)+(wall_act[R]));
}
#include "solver.c"
void main(void)
{
// Declare your local variables here


// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTA=0x00;
if(SENSOR_TYPE==2)DDRA=0x00;
else DDRA=0x07;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x0F;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;
initialize();

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x02;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x02;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 19200
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")
//for(ii=0;ii<7;ii++)
//{
//       move_straight();
//}
//turnB();
//for(ii=0;ii<7;ii++)
//{
//       move_straight();
//}
   //move_straight();
//        move_straight();
//        move_straight();
//        if(wall_act[R]==FALSE)
//        { 
//         turnR();
//          move_straight();
//        }
//while (1)
//      {
//        if(wall_act[L]==FALSE)
//        {
//         turnL();
//         move_straight();
//        }
//        else if(wall_act[R]==FALSE)
//        {
//         turnR();
//         move_straight();
//        } 
//        else if(wall_act[F]==FALSE)
//        {
//         move_straight();
//         
//         }
//        else 
//        {
//         turnB();
//         move_straight();
//        }
//        
//        
//         
//        
//           
//    
//      };

solveMaze();
}
