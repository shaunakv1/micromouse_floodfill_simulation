/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.8a Evaluation
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/3/2008
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

#include <mega16.h>
#include <delay.h>
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>
unsigned char step[4]={0xCC,0x66,0x33,0x99};
unsigned char l_overflow,r_overflow,l_step,r_step,x,y;
unsigned rightMotorOn;
unsigned leftMotorOn;
unsigned char BASE_SPEED=60;
// Timer 0 overflow interrupt service routine
//right motor Timer
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    //Place your code here
   y++;
if(y>r_overflow && rightMotorOn)
  {
   y=0;
   PORTD=step[r_step];
   r_step++;
   if(r_step>3)r_step=0;
  }


}

// Timer 2 overflow interrupt service routine
//left motor timer
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{

x++;
if(x>l_overflow && leftMotorOn)
  {
   x=0;
   PORTB=step[l_step];
   l_step++;
   if(l_step > 3)l_step = 0;
  }
}
void initialize(void)
{
 x=0;
 y=0;
 l_step=0;
 r_step=0;
 l_overflow=BASE_SPEED;
 r_overflow=BASE_SPEED;
 rightMotorOn=1;
 leftMotorOn=1;
}


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

// Declare your global variables here
void displayNumberOnLCD(int x,int y,int cen)
{
      unsigned char a,b,c;
      lcd_gotoxy(x,y);
      a=(cen%10)+48;
      cen/=10;
      b=(cen%10)+48;
      cen/=10;
      c=(cen%10)+48;
      lcd_putchar(c);
      lcd_putchar(b);
      lcd_putchar(a);  
}
void main(void)
{
// Declare your local variables here
unsigned char cOff,cOn,cDiff,rOff,rOn,rDiff,lOff,lOn,lDiff;
unsigned char error,aerror;
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=0 State3=0 State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x38;// for our sensors
//DDRA=0x07;

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

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x86;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")
  initialize();
while (1)
      {
      // Place your code here
      //PORTA=PINA|0x07;//Light Leds PORTA|=0x38
      //PORTA|=0x08;
      //delay_us(10);
      //rOn=read_adc(0);
//      PORTA&=0xF7;
//      PORTA|=0x10;
//      delay_us(10);
//      lOn=read_adc(2);
//      PORTA&=0xEF;
//      PORTA|=0x02;
//      delay_us(10);
//      cOn=read_adc(3);
      //PORTA&=0xF7;
      //PORTA=PINA&0xf8;//off Leds    PORTA&=0xc7;
      //delay_us(5);
      //aerror= read_adc(3)-read_adc(4);
      //delay_us(5);
      //error=(lOn-rOn);//-aerror;
      //if(error>0)
      //{
       // r_overflow=BASE_SPEED+error;
        
        
      //}
      //else l_overflow=BASE_SPEED-error;           
       
      /*delay_ms(20);
      rOff=read_adc(0);
      cOff=read_adc(1);
      lOff=read_adc(2);
      
      rDiff=rOn-rOff;
      cDiff=cOn-cOff;
      lDiff=lOn-lOff;
            
      displayNumberOnLCD(0,0,rDiff);
      displayNumberOnLCD(5,0,cDiff);
      displayNumberOnLCD(10,0,lDiff);*/
      
      //displayNumberOnLCD(0,0,rOn);
      //displayNumberOnLCD(5,0,cOn);
      //displayNumberOnLCD(10,0,lOn);
      
//      if(cOn>230)
//        {
//             rightMotorOn=0;
//             leftMotorOn=0;   
//        }
      };
}
