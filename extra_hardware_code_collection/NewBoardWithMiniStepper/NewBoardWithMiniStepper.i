
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

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

interrupt [10] void timer0_ovf_isr(void)
{

y++;
if(y>r_overflow && rightMotorOn)
{
y=0;
PORTB=step_rev[r_step];
r_step++;
if(r_step>3)r_step=0;
}

x++;
if(x>l_overflow && leftMotorOn)
{
x=0;
PORTD=step_rev[l_step];
l_step++;
if(l_step > 3)l_step = 0;
}

}

interrupt [5] void timer2_ovf_isr(void)
{

z++;
if(z>40)
{
z=0;
read();

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

if(1)
{
if(error>0)r_overflow=MOTOR_DELAY+(error/8);
else if(error<0)l_overflow=MOTOR_DELAY-(error/8);
} 

if(0)
{

}
}
}

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0xE0 & 0xff);

delay_us(10);

ADCSRA|=0x40;

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

void read(void)
{
unsigned char i,lo,co,ro;
left=0;
center=0;
right=0;

lo=0;
co=0;
ro=0;
if(0==0)
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
if(0==1)
{
left=read_adc(3);
center=read_adc(4);
right=read_adc(5); 
}
if(0==2)
{
co=read_adc(2);
right=read_adc(3);
left=read_adc(4);
center=(read_adc(5)+co)/2;
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

void main(void)
{

PORTB=0x00;
DDRB=0x0F;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xF0;
initialize();

TCCR0=0x02;
TCNT0=0x00;

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

ASSR=0x00;
TCCR2=0x02;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x41;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0xE0 & 0xff;
ADCSRA=0x87;

#asm("sei")

while (1)
{

if(center>90)
turnRight();
};
}
