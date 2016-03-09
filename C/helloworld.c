#include "xparameters.h"
#include "stdio.h"
#include "xgpio.h"
#include "xil_types.h"
#include "math.h"
#include "xil_assert.h"
#include <xuartlite_l.h>


#define	XGpio_mSetDataReg		XGpio_WriteReg
#define	XGpio_mSetDataDirection	XGpio_WriteReg
extern void InitInst(void);
extern void WriteInst(unsigned long inst1, unsigned long inst2);
extern void WriteData(unsigned long data1, unsigned long data2);
extern void LCDOn(void);
extern void LCDOff(void);
extern void LCDClear(void);
extern void LCDInit(void);
extern void MoveCursorHome(void);
extern void MoveCursorLeft(void);
extern void MoveCursorRight(void);
extern void LCDSetLine(int line);
extern void LCDPrintChar(char c);
extern void LCDPrintString(char * line1, char * line2);
extern void LCDTest(void);
extern void LCDTest_main(void);
#define LED_DELAY	  1000000

#define LED_CHANNEL 1
#define LED_MAX_BLINK	0x1	/* Number of times the LED Blinks */
#define GPIO_BITWIDTH	16	/* This is the width of the GPIO */
#define LEDS_ID  XPAR_AXI_GPIO_2_DEVICE_ID
#define BTNS_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define XPAR_PUSH_BUTTONS_5BITS_BASEADDR XPAR_AXI_GPIO_0_BASEADDR

XGpio GpioOutput; /* The driver instance for GPIO Device configured as O/P */


extern int kc_initLCD(void);
extern int kc_LCDPrintString (char* str1, char* str2);

u32 *baseaddr_p = (u32 *)XPAR_MYIP_0_S00_AXI_BASEADDR;
u32 num;
unsigned int data1_int;
unsigned int data2_int;

// Main Loop
int main(void)
{
	init_platform();
	u8 counter_side_wave1 = 0;
	u8 counter_side_wave2 = 0;
	u8 counter_side_duty1 = 0;
	u8 counter_side_duty2 = 0;
	u8 counter_side_offset2 = 0;
	u8 counter_side_output = 0;
	u8 counter_vertical = 0;
    volatile int Delay;
	u8 flag = 0;
    kc_initLCD();  // Initialize LCD
    XGpio_Initialize(&GpioOutput, LEDS_ID);
	XGpio_SetDataDirection(&GpioOutput, LED_CHANNEL, 0x0);
   	kc_LCDPrintString ("Wave Type Osc1: ","Sine            ");
   	char wave1[17];
   	char wave2[17];
   	char duty1[17];
   	char duty2[17];
   	char offset2[17];
   	char output[17];
   	snprintf(wave1,17,"%s","Sine            ");
   	snprintf(wave2,17,"%s","Sine            ");
   	snprintf(duty1,17,"%s","MIDI            ");
   	snprintf(duty2,17,"%s","MIDI            ");
   	snprintf(offset2,17,"%s","MIDI            ");
   	snprintf(output,17,"%s","Add             ");
	*(baseaddr_p+0) = 0x00000001;
	*(baseaddr_p+1) = 0x00000000;
	*(baseaddr_p+0) = 0x00000002;
	*(baseaddr_p+1) = 0x00000000;
	*(baseaddr_p+0) = 0x00000003;
	*(baseaddr_p+1) = 0x00000000;
	*(baseaddr_p+0) = 0x00000004;
	*(baseaddr_p+1) = 0x00000000;
	*(baseaddr_p+0) = 0x00000005;
	*(baseaddr_p+1) = 0x00000000;
   	*(baseaddr_p+0) = 0x00000006;
	*(baseaddr_p+1) = 0x00000000;





	while(1)
  {

//	if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000010) != 0){
//		xil_printf("Presionado Center!\r\n\r\n");
//		XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,1);
//		kc_SetDDRAM(0x40);
//	   	kc_LCDPrintString ("Wave Type Osc1: ","Square          ");
//		*(baseaddr_p+0) = 0x00000001;
//		*(baseaddr_p+1) = 0x00000002;
//	}
//	if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000001) != 0){
//		xil_printf("Presionado Up!\r\n\r\n");
//		XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,2);
//		kc_SetDDRAM(0x40);
//	   	kc_LCDPrintString ("Wave Type Osc1: ","Triangle        ");
//		*(baseaddr_p+0) = 0x00000001;
//		*(baseaddr_p+1) = 0x00000001;
//	}
	if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000002) != 0){
		counter_vertical = counter_vertical + 1;
		for (Delay = 0; Delay < 1000000; Delay++);
		if (counter_vertical ==6){
			counter_vertical = 0;
		}
		if (counter_vertical ==0){
			kc_LCDPrintString ("Wave Type Osc1: ",wave1);
		}else if(counter_vertical ==1){
			kc_LCDPrintString ("Wave Type Osc2: ",wave2);
		}else if(counter_vertical ==2){
			kc_LCDPrintString ("Duty Cycle Osc1: ",duty1);
		}else if(counter_vertical ==3){
			kc_LCDPrintString ("Duty Cycle Osc2: ",duty2);
		}else if(counter_vertical ==4){
			kc_LCDPrintString ("Offset Osc2:    ",offset2);
		}else if(counter_vertical ==5){
			kc_LCDPrintString ("Output Signal:  ",output);
		}
	}

	if (counter_vertical == 0){ // WAVE TYPE OSCILLATOR 1
		if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
			counter_side_wave1 = counter_side_wave1 + 1;
			for (Delay = 0; Delay < 1000000; Delay++);
			if (counter_side_wave1 == 6){
				counter_side_wave1 = 0;
			}
			flag = 1;
		}
		if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
			for (Delay = 0; Delay < 1000000; Delay++);
			XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
			if (counter_side_wave1 == 0){
				counter_side_wave1 = 5;
			}else{
				counter_side_wave1 = counter_side_wave1 - 1;
			}
			flag = 1;
		}
		if (flag == 1){
			flag=0;
			if (counter_side_wave1 == 1) {
				kc_LCDPrintString ("Wave Type Osc1: ","Sine            ");
				*(baseaddr_p+0) = 0x00000001;
				*(baseaddr_p+1) = 0x00000000;
				snprintf(wave1,17,"%s","Sine             ");
			}else if (counter_side_wave1 == 2){
				kc_LCDPrintString ("Wave Type Osc1: ","Square          ");
				*(baseaddr_p+0) = 0x00000001;
				*(baseaddr_p+1) = 0x00000002;
				snprintf(wave1,17,"%s","Square           ");
			}else if (counter_side_wave1 == 3){
				kc_LCDPrintString ("Wave Type Osc1: ","Triangle        ");
				*(baseaddr_p+0) = 0x00000001;
				*(baseaddr_p+1) = 0x00000001;
				snprintf(wave1,17,"%s","Triangle         ");
			}else if (counter_side_wave1 == 4){
				kc_LCDPrintString ("Wave Type Osc1: ","Sawtooth        ");
				*(baseaddr_p+0) = 0x00000001;
				*(baseaddr_p+1) = 0x00000003;
				snprintf(wave1,17,"%s","Sawtooth         ");
			}else if (counter_side_wave1 == 5){
				kc_LCDPrintString ("Wave Type Osc1: ","Noise           ");
				*(baseaddr_p+0) = 0x00000001;
				*(baseaddr_p+1) = 0x00000004;
				snprintf(wave1,17,"%s","Noise            ");
			}

		}
	}else if (counter_vertical == 1){  // WAVE TYPE OSCILLATOR 2
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
				counter_side_wave2 = counter_side_wave2 + 1;
				for (Delay = 0; Delay < 900000; Delay++);
				if (counter_side_wave2 == 6){
					counter_side_wave2 = 0;
				}
				flag = 1;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
				for (Delay = 0; Delay < 900000; Delay++);
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
				if (counter_side_wave2 == 0){
					counter_side_wave2 = 5;
				}else{
					counter_side_wave2 = counter_side_wave2 - 1;
				}
				flag = 1;
			}
			if (flag == 1){
				flag=0;
				if (counter_side_wave2 == 1) {
					kc_LCDPrintString ("Wave Type Osc2: ","Sine            ");
					*(baseaddr_p+0) = 0x00000002;
					*(baseaddr_p+1) = 0x00000000;
					snprintf(wave2,17,"%s","Sine             ");
				}else if (counter_side_wave2 == 2){
					kc_LCDPrintString ("Wave Type Osc2: ","Square          ");
					*(baseaddr_p+0) = 0x00000002;
					*(baseaddr_p+1) = 0x00000002;
					snprintf(wave2,17,"%s","Square          ");
				}else if (counter_side_wave2 == 3){
					kc_LCDPrintString ("Wave Type Osc2: ","Triangle        ");
					*(baseaddr_p+0) = 0x00000002;
					*(baseaddr_p+1) = 0x00000001;
					snprintf(wave2,17,"%s","Triangle        ");
				}else if (counter_side_wave2 == 4){
					kc_LCDPrintString ("Wave Type Osc2: ","Sawtooth        ");
					*(baseaddr_p+0) = 0x00000002;
					*(baseaddr_p+1) = 0x00000003;
					snprintf(wave2,17,"%s","Sawtooth        ");
				}else if (counter_side_wave2 == 5){
					kc_LCDPrintString ("Wave Type Osc2: ","Noise           ");
					*(baseaddr_p+0) = 0x00000002;
					*(baseaddr_p+1) = 0x00000004;
					snprintf(wave2,17,"%s","Noise           ");
				}
			}
		}else if (counter_vertical == 2){  //DUTY CYCLE OSC1
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
				counter_side_duty1 = counter_side_duty1 + 1;
				for (Delay = 0; Delay < 900000; Delay++);
				if (counter_side_duty1 == 3){
					counter_side_duty1 = 0;
				}
				flag = 1;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
				for (Delay = 0; Delay < 900000; Delay++);
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
				if (counter_side_duty1 == 0){
					counter_side_duty1 = 2;
				}else{
					counter_side_duty1 = counter_side_duty1 - 1;
				}
				flag = 1;
			}
			if (flag == 1){
				flag=0;
				if (counter_side_duty1 == 1) {
					kc_LCDPrintString ("Duty Cycle Osc1: ","MIDI            ");
					*(baseaddr_p+0) = 0x00000003;
					*(baseaddr_p+1) = 0x00000000;
					snprintf(duty1,17,"%s","MIDI             ");
				}else if (counter_side_duty1 == 2){
					kc_LCDPrintString ("Duty Cycle Osc1: ","LFO             ");
					*(baseaddr_p+0) = 0x00000003;
					*(baseaddr_p+1) = 0x00000001;
					snprintf(duty1,17,"%s","LFO              ");
				}
			}
		}else if (counter_vertical == 3){  //DUTY CYCLE OSC2
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
				counter_side_duty2 = counter_side_duty2 + 1;
				for (Delay = 0; Delay < 900000; Delay++);
				if (counter_side_duty2 == 3){
					counter_side_duty2 = 0;
				}
				flag = 1;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
				for (Delay = 0; Delay < 900000; Delay++);
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
				if (counter_side_duty2 == 0){
					counter_side_duty2 = 2;
				}else{
					counter_side_duty2 = counter_side_duty2 - 1;
				}
				flag = 1;
			}
			if (flag == 1){
				flag=0;
				if (counter_side_duty2 == 1) {
					kc_LCDPrintString ("Duty Cycle Osc2: ","MIDI            ");
					*(baseaddr_p+0) = 0x00000004;
					*(baseaddr_p+1) = 0x00000000;
					snprintf(duty2,17,"%s","MIDI             ");
				}else if (counter_side_duty2 == 2){
					kc_LCDPrintString ("Duty Cycle Osc2: ","LFO             ");
					*(baseaddr_p+0) = 0x00000004;
					*(baseaddr_p+1) = 0x00000001;
					snprintf(duty2,17,"%s","LFO              ");
				}
			}
		}else if (counter_vertical == 4){  //OFFSET 2
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
				counter_side_offset2 = counter_side_offset2 + 1;
				for (Delay = 0; Delay < 900000; Delay++);
				if (counter_side_offset2 == 3){
					counter_side_offset2 = 0;
				}
				flag = 1;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
				for (Delay = 0; Delay < 900000; Delay++);
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
				if (counter_side_offset2 == 0){
					counter_side_offset2 = 2;
				}else{
					counter_side_offset2 = counter_side_offset2 - 1;
				}
				flag = 1;
			}
			if (flag == 1){
				flag=0;
				if (counter_side_offset2 == 1) {
					kc_LCDPrintString ("Offset Osc2:    ","MIDI            ");
					*(baseaddr_p+0) = 0x00000005;
					*(baseaddr_p+1) = 0x00000000;
					snprintf(offset2,17,"%s","MIDI             ");
				}else if (counter_side_offset2 == 2){
					kc_LCDPrintString ("Offset Osc2:    ","LFO             ");
					*(baseaddr_p+0) = 0x00000005;
					*(baseaddr_p+1) = 0x00000001;
					snprintf(offset2,17,"%s","LFO              ");
				}
			}
		}else if (counter_vertical == 5){  //OUTPUT
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000004) != 0){
				counter_side_output = counter_side_output + 1;
				for (Delay = 0; Delay < 900000; Delay++);
				if (counter_side_output == 4){
					counter_side_output = 0;
				}
				flag = 1;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000008) != 0){
				for (Delay = 0; Delay < 900000; Delay++);
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,5);
				if (counter_side_output == 0){
					counter_side_output = 3;
				}else{
					counter_side_output = counter_side_output - 1;
				}
				flag = 1;
			}
			if (flag == 1){
				flag=0;
				if (counter_side_output == 1) {
					kc_LCDPrintString ("Output Signal:  ","Add             ");
					*(baseaddr_p+0) = 0x00000006;
					*(baseaddr_p+1) = 0x00000000;
					snprintf(output,17,"%s","Add            ");
				}else if (counter_side_output == 2){
					kc_LCDPrintString ("Output Signal:  ","Osc1            ");
					*(baseaddr_p+0) = 0x00000006;
					*(baseaddr_p+1) = 0x00000001;
					snprintf(output,17,"%s","Osc1             ");
				}else if (counter_side_output == 3){
					kc_LCDPrintString ("Output Signal:  ","Osc2            ");
					*(baseaddr_p+0) = 0x00000006;
					*(baseaddr_p+1) = 0x00000002;
					snprintf(output,17,"%s","Osc2             ");
				}
			}
		}
//	if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)  & 0x00000002) != 0){
//		xil_printf("Presionado Down!\r\n\r\n");
//		XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,4);
//		kc_SetDDRAM(0x40);
//	   	kc_LCDPrintString ("Wave Type Osc1: ","Sine            ");
//		*(baseaddr_p+0) = 0x00000001;
//		*(baseaddr_p+1) = 0x00000000;
//	}





/*  *(baseaddr_p+0) = data1_int;
	*(baseaddr_p+1) = data2_int;

    signed int data3_int;
    data3_int = 0xFFFFFFE0 | *(baseaddr_p+2);
    if ((data3_int >= -32) && (data3_int <= -25)){
    	data3_int = data3_int + 32;
    }
    snprintf(output,50,"Offset:%d        ", data3_int);
   	kc_LCDPrintString (output,"Frequency: 21Hz ");*/

  }


    return 0;
}
