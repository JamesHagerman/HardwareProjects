/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#if defined(__XC)
    #include <xc.h>         /* XC8 General Include File */
#elif defined(HI_TECH_C)
    #include <htc.h>        /* HiTech General Include File */
#endif

#include <stdint.h>        /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */
#include <stdio.h>  // needed for printf

#include "system.h"        /* System funct/params, like osc/peripheral config */
#include "user.h"          /* User funct/params, such as InitApp */

#define FOSC 8000000L
#define _XTAL_FREQ 8000000L

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

// UART/printf() requirements:
void putch(char data) {
    while( ! TXIF)
    continue;
    TXREG = data;
}

// SPI SendData:
void SPI_Write(uint16_t data) {
    // CS pin low (to enable MCP4921)
    PORTCbits.RC6 = 0;
    
    // config bits: 0x3 = 0011 -> output a, unbuffered, gain of 1x, enable the output buffer
    uint16_t config = 0x3 << 12;
    data = data & 0x0FFF; // strip off just the 12 bits of data we actually have

    config = (config | data) >> 8;

    SSPBUF = config; // first 8 bits
    while( ! SSPSTATbits.BF);

    SSPBUF = data;   // second 8 bits
    while( ! SSPSTATbits.BF);
    
    // CS pin high
    PORTCbits.RC6 = 1;
}

unsigned char SPI_Read(unsigned char addr)
{
  // Activate the SS SPI Select pin
  PORTCbits.RC6 = 0;
  // Start MCP23S17 OpCode transmission
  SSPBUF = 0; // Some address to read from? Chip specific...
  // Wait for Data Transmit/Receipt complete
  while(!SSPSTATbits.BF);
  // Start MCP23S17 Address transmission
  SSPBUF = addr;
  // Wait for Data Transmit/Receipt complete
  while(!SSPSTATbits.BF);

  // Send Dummy transmission for reading the data
  SSPBUF = 0x00;
  // Wait for Data Transmit/Receipt complete
  while(!SSPSTATbits.BF);

  // CS pin is not active
  PORTCbits.RC6 = 1;
  return(SSPBUF);
}

// Setup MultA control pins:
#define MultAS0 PORTAbits.RA2
#define MultAS1 PORTCbits.RC0
#define MultAS2 PORTCbits.RC1
#define MultAS3 PORTCbits.RC2

// Setup MultB control pins:
#define MultBS0 PORTBbits.RB4
#define MultBS1 PORTCbits.RC3
#define MultBS2 PORTCbits.RC4

/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/
void main(void)
{
    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    InitApp();

    __delay_ms(1000);
    while(1)
    {
        // Serial UART test:
//        printf("This is a test!\n");

        // Blink Test:
//        PORTA = 0xFFFF;
//        PORTB = 0xFFFF;
//        PORTC = 0xFFFF;
//        __delay_ms(1000);
//        PORTA = 0x0000;
//        PORTB = 0x0000;
//        PORTC = 0x0000;
//        __delay_ms(1000);

        // MCP9421 tests:
        // static value:
//        SPI_Write(4095);

        // Sawtooth wave
//        for (uint16_t i = 0; i < 4096; i=i+100) {
//            SPI_Write(i);
//        }
        
        // Square wave @10kHz
//        for (uint16_t i = 0; i < 4096; i=i+4095) {
//            SPI_Write(i);
//        }


        // Keyboard Input Test:
//        MultBS0 = 0;
//        MultBS1 = 0;
//        MultBS2 = 0;
//
//        if (PORTAbits.RA5 == 0) {
//            PORTCbits.RC5 = 1;
//        } else {
//            PORTCbits.RC5 = 0;
//        }

        //=============
        // Keyboard Input:
        uint8_t key_count = 23;
        uint8_t pressed_keys = 0;

        for (int8_t current_key = 0; current_key < key_count; current_key += 1) {

            if (current_key <= 15) {
                MultAS0 = (current_key >> 0) & 1;
                MultAS1 = (current_key >> 1) & 1;
                MultAS2 = (current_key >> 2) & 1;
                MultAS3 = (current_key >> 3) & 1;

                if (PORTAbits.RA4 == 0) {
                    pressed_keys += 1;
                }
            } else {
                MultBS0 = (current_key >> 0) & 1;
                MultBS1 = (current_key >> 1) & 1;
                MultBS2 = (current_key >> 2) & 1;
                if (PORTAbits.RA5 == 0) {
                    pressed_keys += 1;
                }
            }

        }

        if (pressed_keys > 0) {
            PORTCbits.RC5 = 1;
        } else {
            PORTCbits.RC5 = 0;
        }
        // End keyboard input
        //=============
        
    }

}

