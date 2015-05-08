/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <xc.h>           /* Global Header File */
#include <stdint.h>        /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */
#include <stdio.h>  // needed for printf

#include "system.h"        /* System funct/params, like osc/peripheral config */
#include "user.h"          /* User funct/params, such as InitApp */

// Needed for __delay_ms and __delay_us
#define _XTAL_FREQ 4000000  

//#use rs232 (baud=9600, xmit=PIN_A6, rcv=PIN_A3, parity=N, bits=8)

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

/* i.e. uint8_t <variable_name>; */

// Shadow variable to hold port values:
//uint8_t sGPIO = 0;
union {
    uint8_t port;
    struct {
        unsigned GP0                    :1;
        unsigned GP1                    :1;
        unsigned GP2                    :1;
        unsigned GP3                    :1;
        unsigned GP4                    :1;
        unsigned GP5                    :1;
    };
} sGPIO;

//void setPin(union sGPIO *some_pin, bool value) {
//    value -> *some_pin;
//    GPIO = sGPIO.port;
//}

//DelayTXBitUART delay for[(2 * f)/(4 * baud) + 1]/2 - 12 cycles --- f = 48MHz
// wtf. This is the thing we need:
// delay time = (((2*OSC_FREQ)/(4*BAUDRATE))+1)/2
//              (((2*_XTAL_FREQ)/(4*9600)) + 1 )/2
//              (((2*4000000)/(4*9600))+1)/2
//              104

void DelayTXBitUART(void)
{
    // 416 = 373 micro seconds
    // 410 = 368 micro seconds
    // 300 = 276 micro seconds
    // 41 = 57
    // 80 = 90
    // 77 = 88 micro seconds. This is what we need!
    _delay(77);

    // 88 micro seconds per bit is needed for 9600 baud
    // 176 micro seconds per 2 bits.
    // 5.682kHz
    
    // LSB IS SENT FIRST!
    // I should be getting back 'a' which is 97 in decimal or:
    // 0110 0001 MSB first
    // 1000 0110 LSB first

}

////DelayRXHalfBitUART delay for[(2 * f)/(8 * baud) + 1]/2 - 9 cycles
//void DelayRXHalfBitUART(void)
//{
//    _delay(148); //38400 baud: 147.8 cycles
//}
//
////DelayRXBitUART delay for[(2 * f)/(4 * baud) + 1]/2 - 14 cycles
//void DelayRXBitUART()
//{
//    _delay(299); //38400 baud: 299 cycles
//}

void putch(char c) {

    unsigned char bitcount = 8;

    //start
    sGPIO.GP1 = 0;   // falling edge means "start bit"
    GPIO = sGPIO.port;
    DelayTXBitUART();

    while (bitcount--) {
        sGPIO.GP1 = (c & 0x01);
        GPIO = sGPIO.port;
        DelayTXBitUART();
        c>>=1;
    }
    //stop
    sGPIO.GP1 = 1;   // go back to "holding pattern of "high"
    GPIO = sGPIO.port;
    DelayTXBitUART();

}

uint16_t analogRead() {
    ADCON0bits.ADON = 1; //enable the a2d 
    __delay_us(25); // delay 2 us for each bit (10 total) plus some extra just in case
    ADCON0bits.GO_DONE = 1; //enable conversion   
    while (ADCON0bits.GO_DONE) {}
    return (ADRESH << 8) | ADRESL;
}

/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/

uint8_t main(void)
{
    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    InitApp();

    /* TODO <INSERT USER APPLICATION CODE HERE> */
    
    //GPIObits.GP1 = 1;

    while(1)
    {
//        __delay_ms(1000);

//        putch('a'); // 0110 0001  MSB
//        __delay_ms(1);
//        sGPIO.GP2 = 0;
//        GPIO = sGPIO.port;
//        __delay_ms(1);
//        putch('e'); // 0110 0001  MSB
//        __delay_ms(1);
//        GPIObits.GP2=0;


        printf("This is a test\n\r");

        //GPIObits.GP2=1;
        sGPIO.GP2 = 1;
        GPIO = sGPIO.port;
        //delay_ms(500); // 2.27 = 440 hertz
        __delay_ms(500);
        sGPIO.GP2 = 0;
        GPIO = sGPIO.port;
        //delay_ms(500);
        __delay_ms(500);

        // RA3 is the switch on the LPC Demo board.
        // It also happens to be GP3 (pin 4 on the 12f683)
        if (GPIObits.GP3 == 0) {

            // GP0 is pin 7.. which just happens to be the LPC's potentiometer.
            sGPIO.GP0 = 0;
            GPIO = sGPIO.port;
        }
        if (GPIObits.GP3 == 1) {
            sGPIO.GP0 = 1;
            GPIO = sGPIO.port;
        }
        
        uint16_t knob = analogRead();
        printf(" knob: %i\n\r", knob);

    }
    return 0;

}

