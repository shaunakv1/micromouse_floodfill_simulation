/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.8a Evaluation
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : NewBoardWithMiniStepper
Version : 
Date    : 1/7/2009
Author  : Freeware, for evaluation and non-commercial use only
Company : 
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>

#define ADC_DELAY 40
#define TRUE 1
#define FALSE 0
#define SHOW_DISPLAY FALSE
#define ACC_FACTOR 100
#define SENSOR_TYPE 0
#define CORRECT_ERROR TRUE
unsigned char step[4]={0xCC,0x66,0x33,0x99};
unsigned char step_rev[4]={0x99,0x33,0x66,0xCC};
unsigned char l_overflow,r_overflow,l_step,r_step,x,y,z;
unsigned rightMotorOn;
unsigned leftMotorOn;
unsigned int left,right,center;
int error,error0;

unsigned char MOTOR_DELAY=30;
unsigned char ADC_CENTER;


void read(void);

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
   //right motor
   y++;
   if(y>r_overflow && rightMotorOn)
   {
    y=0;
    PORTB=step_rev[r_step];
    r_step++;
    if(r_step>3)r_step=0;
   }
   
   //left motor
   x++;
   if(x>l_overflow && leftMotorOn)
   {
    x=0;
    PORTD=step_rev[l_step];
    l_step++;
    if(l_step > 3)l_step = 0;
   }
   
   //acceleration code
//  accCounter++;
//   if(accCounter>ACC_FACTOR)
//   {
//     accCounter=0;
//       if(MOTOR_DELAY>20)
//       MOTOR_DELAY--;
//   }
   
   
}

// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here
   //read sensor
   z++;
   if(z>ADC_DELAY)
   {
   z=0;
   read();
   //error correction
   error0=error;
   if(left < 15 )
        {
         error = ADC_CENTER-right;
         ADC_CENTER=(ADC_CENTER+right)/2;
        }
   else if(right < 15) 
        {
         error = left-ADC_CENTER;
         ADC_CENTER=(left+ADC_CENTER)/2;
        }
   else
        {
         error = left-right;
         ADC_CENTER=(left+right)/2;
        }
   
   if(CORRECT_ERROR)
   {
        if(error>0)r_overflow=MOTOR_DELAY+(error/8);//+(error-error0)/8;
        else if(error<0)l_overflow=MOTOR_DELAY-(error/8);//+(error-error0)/8;
   } 
//   
//    if(error>0)r_overflow=MOTOR_DELAY+((error*r_overflow)/40); 
//   else if(error<0)l_overflow=MOTOR_DELAY-((error*l_overflow)/40);
        if(SHOW_DISPLAY)
        {
        //show(right,0,0);
        //show(left,10,0);
        //show(center,5,0);
        }
   }
}

#include <delay.h>

#define ADC_VREF_TYPE 0xE0

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
 unsigned char i,lo,co,ro;
 left=0;
 center=0;
 right=0;
 
 lo=0;
 co=0;
 ro=0;
 if(SENSOR_TYPE==0)
 {
        lo=read_adc(3); 
        PORTC=PINC|(1<<0);
        left=read_adc(3);
        PORTC=PINC&(~(1<<0));
        left=left-lo;
        delay_us(7);
  
        ro=read_adc(4);
        PORTC=PINC|(1<<1);
        right=read_adc(4);
        PORTC=PINC&(~(1<<1));
        right=right-ro;
        delay_us(7);

        co=read_adc(5);
        PORTC=PINC|(1<<2);
        center=read_adc(5);
        PORTC=PINC&(~(1<<2));
        center=center-co;
        delay_us(7);
 }
  if(SENSOR_TYPE==1)
  {
        left=read_adc(3);
        center=read_adc(4);
        right=read_adc(5); 
  }
  if(SENSOR_TYPE==2)
  {
      co=read_adc(2);//front right
      right=read_adc(3);//right 
      left=read_adc(4);//left
      center=(read_adc(5)+co)/2;//front left 
  }  
}



void turnBack(void)
{
    unsigned char i;
    rightMotorOn=0;
          leftMotorOn=0;
    
    for(i=0;i<150;i++)
    {
          
    PORTB=step[r_step];
    r_step++;
    if(r_step>3)r_step=0;
   
    PORTD=step_rev[l_step];
    l_step++;
    if(l_step > 3)l_step = 0;
     
        delay_ms(4); 
    }
    rightMotorOn=1;
    leftMotorOn=1;
}
void turnRight(void)
{
        unsigned char i;

    rightMotorOn=0;
          leftMotorOn=0;
    
    for(i=0;i<75;i++)
    {
          
    PORTB=step_rev[r_step];
    r_step++;
    if(r_step>3)r_step=0;
   
    PORTD=step[l_step];
    l_step++;
    if(l_step > 3)l_step = 0;
     
        delay_ms(2); 
    }
    rightMotorOn=1;
    leftMotorOn=1;
}

void turnLeft(void)
{
    unsigned char i;
    rightMotorOn=0;
          leftMotorOn=0;
    
    
    for(i=0;i<75;i++)
    {
          
    PORTB=step[r_step];
    r_step++;
    if(r_step>3)r_step=0;
   
    PORTD=step_rev[l_step];
    l_step++;
    if(l_step > 3)l_step = 0;
     
        delay_ms(4); 
    }
    
    rightMotorOn=1;
    leftMotorOn=1;
    
}
// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x0F;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
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
TCCR0=0x02;
TCNT0=0x00;

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
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: Int., cap. on AREF
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
          if(center>90)
        turnRight();
      };
}
