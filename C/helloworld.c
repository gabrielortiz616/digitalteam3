#include "xparameters.h"
#include "stdio.h"
#include "xgpio.h"
#include "xil_types.h"
#include "math.h"
#include "xil_assert.h"
#include <xuartlite_l.h>

#include "stdlib.h"

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
extern int kc_LCDPrintString(char* str1, char* str2);

u32 *baseaddr_p = (u32 *) XPAR_MYIP_0_S00_AXI_BASEADDR;
u32 num;
unsigned int data1_int;
unsigned int data2_int;
signed int eval2 = 0;
signed int eval1 = 0;
signed int offset_ev;
signed int offset_int;
signed int duty_ev;
signed int duty_int;

// Main Loop
int main(void) {
	init_platform();
	u8 counter_side_wave1 = 0;
	u8 counter_side_wave2 = 0;
	u8 counter_side_duty1 = 0;
	u8 counter_side_duty2 = 0;
	u8 counter_side_offset2 = 0;
	u8 counter_side_output = 0;
	u8 counter_side_cutoff = 0;
	u8 counter_vertical = 0;
	volatile int Delay;
	u8 flag = 0;
	u8 menu = 0;
	u8 run = 0;
	u8 runa = 0;
	u8 in_flag = 2;
	kc_initLCD();  // Initialize LCD
	XGpio_Initialize(&GpioOutput, LEDS_ID);
	XGpio_SetDataDirection(&GpioOutput, LED_CHANNEL, 0x0);
	kc_LCDPrintString("Wave Type Osc1: ", "Sine            ");
	char wave1[17];
	char wave2[17];
	char duty1[17];
	char duty2[17];
	char offset2[17];
	char out[17];
	char output_offset[17];
	char output_duty[17];
	char cutoff[17];
	snprintf(wave1, 17, "%s", "Sine            ");
	snprintf(wave2, 17, "%s", "Sine            ");
	snprintf(duty1, 17, "%s", "MIDI            ");
	snprintf(duty2, 17, "%s", "MIDI            ");
	snprintf(offset2, 17, "%s", "MIDI            ");
	snprintf(out, 17, "%s", "Add              ");
	snprintf(output_offset, 17, "%s", "Offset:0        ");
	snprintf(output_duty, 17, "%s", "DutyCycle:50%    ");
	snprintf(cutoff, 17, "%s", "MIDI            ");
	*(baseaddr_p + 0) = 0x00000001;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000002;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000003;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000004;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000005;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000006;
	*(baseaddr_p + 1) = 0x00000000;
	*(baseaddr_p + 0) = 0x00000007;
	*(baseaddr_p + 1) = 0x00000000;

	// Filter variables

	float wp,wp_low,wp_high, N_low, N_high, N, tempb0, tempa1, tempa2;
	double Q_temp;
	int b0, a0, a1, a2, A, B, fs, fc, Q, temp1, temp2, temp3, b0_low, a0_low, a1_low,a2_low, A_low, B_low,b0_high, a0_high, a1_high, a2_high, A_high, B_high,b0_band, a0_band, a1_band, a2_band, A_band, B_band;
	long tempin;
	int filter_type, current_frequency;
	int fl;
	int fh;
	int fo;
	float W;
	float wpl;
	float wpu;
	float wo2;
	int BW;

	// LFO variables

	long LFO_in;
	float LFO_depth, LFO_frequency;
	int LFO_out;

	while (1) {

		// 		Filters

		fs = 40000;
		filter_type = 2;	// 1=lowpass	2=highpass	3=bandpass	4=follow



		if (filter_type == 1) {				// Lowpass

			// Read multiplier output from register 1
			xil_printf("Read : 0x%08x \n\r", *(baseaddr_p + 5));
			tempin = *(baseaddr_p + 5);

			Q = (tempin / 4096);
			fc = tempin - Q * 4096;
			Q_temp = Q / 100;

			xil_printf("fc: %d \n\r", fc);
			xil_printf("Q: %d \n\r", Q);
			wp = tan(2 * 3.1415926 * fc / (2 * fs));
			N = 1 * 1000 / (wp * wp * 1000 + (wp * 1000 * 100 / (Q)) + 1000);




			tempb0 = N * wp * wp * 1024;

			tempa1 = 2 * N * (wp * wp - 1) * 1024;
			tempa2 = N * (wp * wp - wp * 100 / (Q) + 1) * 1024;

			b0 = tempb0;

			a1 = abs(tempa1);
			a2 = tempa2;

			B = b0;

			A = a1 + (a2 * 4096);
			*(baseaddr_p + 3) = A;
			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 3));
			*(baseaddr_p + 4) = B;
			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 4));

		} else if (filter_type == 2) {			// Highpass


			// Read multiplier output from register 1
			xil_printf("Read : 0x%08x \n\r", *(baseaddr_p + 8));
			tempin = *(baseaddr_p + 8);

			Q = (tempin / 4096);
			fc = tempin - Q * 4096;
			Q_temp = Q / 100;

			xil_printf("fc: %d \n\r", fc);
			xil_printf("Q: %d \n\r", Q);
			wp = tan(2 * 3.1415926 * fc / (2 * fs));
			N = 1 * 1000 / (wp * wp * 1000 + (wp * 1000 * 100 / (Q)) + 1000);




			b0 = N * 1024;

			a1 = abs(2 * N * (wp * wp - 1)) * 1024;
			a2 = N * (wp * wp - wp * 100 / Q + 1) * 1024;

			b0 = 967;
			a1=1931;
			a2=914;

			B = b0;

			A = a1 + (a2 * 4096);
			*(baseaddr_p + 6) = A;
			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 6));
			*(baseaddr_p + 7) = B;
			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 7));

			*(baseaddr_p + 9) = B;

//		} else if (filter_type == 3) {
//
//
//			// Read multiplier output from register 1
//			xil_printf("Read : 0x%08x \n\r", *(baseaddr_p + 11));
//			tempin = *(baseaddr_p + 11);
//
//			Q = (tempin / 4096);
//			fc = tempin - Q * 4096;
//			Q_temp = Q / 100;
//
//			xil_printf("fc: %d \n\r", fc);
//			xil_printf("Q: %d \n\r", Q);
//			wp = tan(2 * 3.1415926 * fc / (2 * fs));
//			N = 1 * 1000 / (wp * wp * 1000 + (wp * 1000 * 100 / (Q)) + 1000);
//
//
//
//
//			if (fc > 1000) {
//				fl = fc - 200;
//				fh = fc + 200;
//			} else if (fc > 500) {
//				fl = fc - 100;
//				fh = fc + 100;
//			} else if (fc > 100) {
//				fl = fc - 50;
//				fh = fc + 50;
//			} else if (fc > 20) {
//				fl = fc - 10;
//				fh = fc + 10;
//			} else {
//				fl = fc;
//				fh = fc;
//			}
//
//			fo = sqrt(fl * fh);
//			BW = fh - fl;
//			Q = 100 * fo / BW;
//
//			wpl = tan(3.1415926 * fl / fs);
//			wpu = tan(3.1415926 * fh / fs);
//			W = wpu - wpl;
//			wo2 = wpu * wpl;
//
//			b0 = W * 1024;
//
//			a0 = (1 + W + wo2) * 1024;
//			a1 = (2 * wo2 - 2) * 1024;
//			a2 = (1 + wo2 - W) * 1024;
//
//			B = b0 + (a0 * 4096);
//
//
//			A = a1 + (a2 * 4096);
//			*(baseaddr_p + 9) = A;
//			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 9));
//			*(baseaddr_p + 10) = B;
//			xil_printf("Wrote: 0x%08x \n\r", *(baseaddr_p + 10));
//
//
//

		}


		// LFO

		xil_printf("Read LFO: 0x%08x \n\r", *(baseaddr_p + 13));
		LFO_in = *(baseaddr_p + 13);

		LFO_depth = (LFO_in / 128);
		LFO_frequency = (LFO_in - LFO_depth * 128)*100/635;
		xil_printf("LFO: %d \n\r", LFO_in);
		LFO_out = fs / (2*LFO_frequency*LFO_depth);

		*(baseaddr_p + 12) = LFO_out;



		// 		User interface

		if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1) & 0x00000010) //Center button
		!= 0) {
			for (Delay = 0; Delay < 1000000; Delay++)
				;
			menu = menu + 1;
			if (menu == 2) {
				menu = 0;
			}
			if (menu == 1) {
				run = 1;
			} else if (menu == 0) {
				runa = 1;
			}
		}
		if (menu == 1) {
			if (run == 1) {
				if (counter_vertical == 0) {
					kc_LCDPrintString("Wave Type Osc1: ", wave1);
				} else if (counter_vertical == 1) {
					kc_LCDPrintString("Wave Type Osc2: ", wave2);
				} else if (counter_vertical == 2) {
					kc_LCDPrintString("Duty Cycle Osc1: ", duty1);
				} else if (counter_vertical == 3) {
					kc_LCDPrintString("Duty Cycle Osc2: ", duty2);
				} else if (counter_vertical == 4) {
					kc_LCDPrintString("Offset Osc2:    ", offset2);
				} else if (counter_vertical == 5) {
					kc_LCDPrintString("Output Signal:  ", out);
				} else if (counter_vertical == 6) {
					kc_LCDPrintString("Filter Cutoff:  ", cutoff);
				}
				run = 0;
			}
			if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1) & 0x00000002)
					!= 0) {
				counter_vertical = counter_vertical + 1;
				for (Delay = 0; Delay < 1000000; Delay++)
					;
				if (counter_vertical == 7) {
					counter_vertical = 0;
				}
				if (counter_vertical == 0) {
					kc_LCDPrintString("Wave Type Osc1: ", wave1);
				} else if (counter_vertical == 1) {
					kc_LCDPrintString("Wave Type Osc2: ", wave2);
				} else if (counter_vertical == 2) {
					kc_LCDPrintString("Duty Cycle Osc1: ", duty1);
				} else if (counter_vertical == 3) {
					kc_LCDPrintString("Duty Cycle Osc2: ", duty2);
				} else if (counter_vertical == 4) {
					kc_LCDPrintString("Offset Osc2:    ", offset2);
				} else if (counter_vertical == 5) {
					kc_LCDPrintString("Output Signal:  ", out);
				} else if (counter_vertical == 6) {
					kc_LCDPrintString("Filter Cutoff:  ", cutoff);
				}
			} else if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
					& 0x00000001) != 0) {
				for (Delay = 0; Delay < 1000000; Delay++)
					;
				XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
				if (counter_vertical == 0) {
					counter_vertical = 6;
				} else {
					counter_vertical = counter_vertical - 1;
				}
				if (counter_vertical == 0) {
					kc_LCDPrintString("Wave Type Osc1: ", wave1);
				} else if (counter_vertical == 1) {
					kc_LCDPrintString("Wave Type Osc2: ", wave2);
				} else if (counter_vertical == 2) {
					kc_LCDPrintString("Duty Cycle Osc1: ", duty1);
				} else if (counter_vertical == 3) {
					kc_LCDPrintString("Duty Cycle Osc2: ", duty2);
				} else if (counter_vertical == 4) {
					kc_LCDPrintString("Offset Osc2:    ", offset2);
				} else if (counter_vertical == 5) {
					kc_LCDPrintString("Output Signal:  ", out);
				} else if (counter_vertical == 6) {
					kc_LCDPrintString("Filter Cutoff:  ", cutoff);
				}
			}

			if (counter_vertical == 0) { // WAVE TYPE OSCILLATOR 1
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_wave1 = counter_side_wave1 + 1;
					for (Delay = 0; Delay < 1000000; Delay++)
						;
					if (counter_side_wave1 == 6) {
						counter_side_wave1 = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 1000000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_wave1 == 0) {
						counter_side_wave1 = 6;
					} else {
						counter_side_wave1 = counter_side_wave1 - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_wave1 == 1) {
						kc_LCDPrintString("Wave Type Osc1: ",
								"Sine            ");
						*(baseaddr_p + 0) = 0x00000001;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(wave1, 17, "%s", "Sine             ");
					} else if (counter_side_wave1 == 2) {
						kc_LCDPrintString("Wave Type Osc1: ",
								"Square          ");
						*(baseaddr_p + 0) = 0x00000001;
						*(baseaddr_p + 1) = 0x00000002;
						snprintf(wave1, 17, "%s", "Square           ");
					} else if (counter_side_wave1 == 3) {
						kc_LCDPrintString("Wave Type Osc1: ",
								"Triangle        ");
						*(baseaddr_p + 0) = 0x00000001;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(wave1, 17, "%s", "Triangle         ");
					} else if (counter_side_wave1 == 4) {
						kc_LCDPrintString("Wave Type Osc1: ",
								"Sawtooth        ");
						*(baseaddr_p + 0) = 0x00000001;
						*(baseaddr_p + 1) = 0x00000003;
						snprintf(wave1, 17, "%s", "Sawtooth         ");
					} else if (counter_side_wave1 == 5) {
						kc_LCDPrintString("Wave Type Osc1: ",
								"Noise           ");
						*(baseaddr_p + 0) = 0x00000001;
						*(baseaddr_p + 1) = 0x00000004;
						snprintf(wave1, 17, "%s", "Noise            ");
					}

				}
			} else if (counter_vertical == 1) {  // WAVE TYPE OSCILLATOR 2
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_wave2 = counter_side_wave2 + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_wave2 == 6) {
						counter_side_wave2 = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_wave2 == 0) {
						counter_side_wave2 = 5;
					} else {
						counter_side_wave2 = counter_side_wave2 - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_wave2 == 1) {
						kc_LCDPrintString("Wave Type Osc2: ",
								"Sine            ");
						*(baseaddr_p + 0) = 0x00000002;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(wave2, 17, "%s", "Sine             ");
					} else if (counter_side_wave2 == 2) {
						kc_LCDPrintString("Wave Type Osc2: ",
								"Square          ");
						*(baseaddr_p + 0) = 0x00000002;
						*(baseaddr_p + 1) = 0x00000002;
						snprintf(wave2, 17, "%s", "Square          ");
					} else if (counter_side_wave2 == 3) {
						kc_LCDPrintString("Wave Type Osc2: ",
								"Triangle        ");
						*(baseaddr_p + 0) = 0x00000002;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(wave2, 17, "%s", "Triangle        ");
					} else if (counter_side_wave2 == 4) {
						kc_LCDPrintString("Wave Type Osc2: ",
								"Sawtooth        ");
						*(baseaddr_p + 0) = 0x00000002;
						*(baseaddr_p + 1) = 0x00000003;
						snprintf(wave2, 17, "%s", "Sawtooth        ");
					} else if (counter_side_wave2 == 5) {
						kc_LCDPrintString("Wave Type Osc2: ",
								"Noise           ");
						*(baseaddr_p + 0) = 0x00000002;
						*(baseaddr_p + 1) = 0x00000004;
						snprintf(wave2, 17, "%s", "Noise           ");
					}
				}
			} else if (counter_vertical == 2) {  //DUTY CYCLE OSC1
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_duty1 = counter_side_duty1 + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_duty1 == 3) {
						counter_side_duty1 = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_duty1 == 0) {
						counter_side_duty1 = 2;
					} else {
						counter_side_duty1 = counter_side_duty1 - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_duty1 == 1) {
						kc_LCDPrintString("Duty Cycle Osc1: ",
								"MIDI            ");
						*(baseaddr_p + 0) = 0x00000003;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(duty1, 17, "%s", "MIDI             ");
					} else if (counter_side_duty1 == 2) {
						kc_LCDPrintString("Duty Cycle Osc1: ",
								"LFO             ");
						*(baseaddr_p + 0) = 0x00000003;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(duty1, 17, "%s", "LFO              ");
					}
				}
			} else if (counter_vertical == 3) {  //DUTY CYCLE OSC2
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_duty2 = counter_side_duty2 + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_duty2 == 3) {
						counter_side_duty2 = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_duty2 == 0) {
						counter_side_duty2 = 2;
					} else {
						counter_side_duty2 = counter_side_duty2 - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_duty2 == 1) {
						kc_LCDPrintString("Duty Cycle Osc2: ",
								"MIDI            ");
						*(baseaddr_p + 0) = 0x00000004;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(duty2, 17, "%s", "MIDI             ");
					} else if (counter_side_duty2 == 2) {
						kc_LCDPrintString("Duty Cycle Osc2: ",
								"LFO             ");
						*(baseaddr_p + 0) = 0x00000004;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(duty2, 17, "%s", "LFO              ");
					}
				}
			} else if (counter_vertical == 4) {  //OFFSET 2
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_offset2 = counter_side_offset2 + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_offset2 == 3) {
						counter_side_offset2 = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_offset2 == 0) {
						counter_side_offset2 = 2;
					} else {
						counter_side_offset2 = counter_side_offset2 - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_offset2 == 1) {
						kc_LCDPrintString("Offset Osc2:    ",
								"MIDI            ");
						*(baseaddr_p + 0) = 0x00000005;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(offset2, 17, "%s", "MIDI             ");
					} else if (counter_side_offset2 == 2) {
						kc_LCDPrintString("Offset Osc2:    ",
								"LFO             ");
						*(baseaddr_p + 0) = 0x00000005;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(offset2, 17, "%s", "LFO              ");
					}
				}
			} else if (counter_vertical == 5) {  //OUTPUT
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_output = counter_side_output + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_output == 5) {
						counter_side_output = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_output == 0) {
						counter_side_output = 4;
					} else {
						counter_side_output = counter_side_output - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_output == 1) {
						kc_LCDPrintString("Output Signal:  ",
								"Add             ");
						*(baseaddr_p + 0) = 0x00000006;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(out, 17, "%s", "Add            ");
					} else if (counter_side_output == 2) {
						kc_LCDPrintString("Output Signal:  ",
								"Osc1            ");
						*(baseaddr_p + 0) = 0x00000006;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(out, 17, "%s", "Osc1             ");
					} else if (counter_side_output == 3) {
						kc_LCDPrintString("Output Signal:  ",
								"Osc2            ");
						*(baseaddr_p + 0) = 0x00000006;
						*(baseaddr_p + 1) = 0x00000002;
						snprintf(out, 17, "%s", "Osc2             ");
					} else if (counter_side_output == 4) {
						kc_LCDPrintString("Output Signal:  ",
								"LFO             ");
						*(baseaddr_p + 0) = 0x00000006;
						*(baseaddr_p + 1) = 0x00000003;
						snprintf(out, 17, "%s", "LFO              ");
					}
				}
			} else if (counter_vertical == 6) {  //FilterCutoff
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000004) != 0) {
					counter_side_cutoff = counter_side_cutoff + 1;
					for (Delay = 0; Delay < 900000; Delay++)
						;
					if (counter_side_cutoff == 3) {
						counter_side_cutoff = 0;
					}
					flag = 1;
				}
				if ((XGpio_ReadReg(XPAR_PUSH_BUTTONS_5BITS_BASEADDR, 1)
						& 0x00000008) != 0) {
					for (Delay = 0; Delay < 900000; Delay++)
						;
					XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 5);
					if (counter_side_cutoff == 0) {
						counter_side_cutoff = 2;
					} else {
						counter_side_cutoff = counter_side_cutoff - 1;
					}
					flag = 1;
				}
				if (flag == 1) {
					flag = 0;
					if (counter_side_cutoff == 1) {
						kc_LCDPrintString("Filter Cutoff:  ",
								"MIDI            ");
						*(baseaddr_p + 0) = 0x00000007;
						*(baseaddr_p + 1) = 0x00000000;
						snprintf(cutoff, 17, "%s", "MIDI             ");
					} else if (counter_side_cutoff == 2) {
						kc_LCDPrintString("Filter Cutoff:  ",
								"LFO             ");
						*(baseaddr_p + 0) = 0x00000007;
						*(baseaddr_p + 1) = 0x00000001;
						snprintf(cutoff, 17, "%s", "LFO              ");
					}
				}
			}
		} else if (menu == 0) {
			eval1 = *(baseaddr_p + 2);
			if ((eval1 != eval2)) {
				eval2 = eval1;
				if (eval1 <= -2147483549) {
					in_flag = 1;
				} else {
					in_flag = 0;
				}
			} else if (runa == 1) {
				kc_LCDPrintString(output_offset, output_duty);
				runa = 0;
			}
			if (in_flag == 1) {
				if ((duty_ev != *(baseaddr_p + 2)) || (runa == 1)) {
					duty_ev = *(baseaddr_p + 2);
					duty_int = 0xFFFFFF80 | *(baseaddr_p + 2);
					if ((duty_int >= -128) && (duty_int <= -27)) {
						duty_int = duty_int + 128;
					}
					snprintf(output_duty, 17, "DutyCycle:%d%%    ", duty_int);
					kc_LCDPrintString(output_offset, output_duty);
					runa = 0;
					//xil_printf("%d", eval1);
				}
				in_flag = 2;
			}
			if (in_flag == 0) {
				if ((offset_ev != *(baseaddr_p + 2)) || (runa == 1)) {
					offset_ev = *(baseaddr_p + 2);
					offset_int = 0xFFFFFFE0 | *(baseaddr_p + 2);
					if ((offset_int >= -32) && (offset_int <= -25)) {
						offset_int = offset_int + 32;
					}
					snprintf(output_offset, 17, "Offset:%d        ",
							offset_int);
					kc_LCDPrintString(output_offset, output_duty);
					runa = 0;
				}
				in_flag = 2;
			}
		}

	}

	return 0;
}
