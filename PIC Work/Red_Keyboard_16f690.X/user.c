/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#if defined(__XC)
    #include <xc.h>         /* XC8 General Include File */
#elif defined(HI_TECH_C)
    #include <htc.h>        /* HiTech General Include File */
#endif

#include <stdint.h>         /* For uint8_t definition */
#include <stdbool.h>        /* For true/false definition */

#include "user.h"

/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* <Initialize variables in user.h and insert code for user algorithms.> */

void InitApp(void)
{
    OSCCON = 0x70;	/*Select 8 Mhz internal clock */

    // Set Analog Input pins to be digital input pins... if at all
    ANSEL = 0;
    ANSELH = 0;

    // Setup all pins to be outputs:
    TRISA = 0;
    TRISB = 0;
    TRISC = 0;



    //================
    // Setup serial:
    TRISBbits.TRISB5 = 1; // RX
    TRISBbits.TRISB7 = 1; // TX

    BAUDCTLbits.BRG16 = 0; // 8-bit baud rate generator is used
    // SPBRG = ((FOSC/<baud rate>)/16)-1
//    SPBRG = 51; // 9600bps
    SPBRG = 15; // 31250bps (MIDI)

    BRGH = 1; // High speed
    SYNC = 0; // Async
    SPEN = 1; // Serial Port Enabled
    CREN = 0; // Continuous Receive Enabled
    TXEN = 1; // Transmit enabled

//    RCIE = 1;//Enables the EUSART receive interrupt
//    GIE = 1;//Enables all unmasked interrupts
//    PEIE = 1;//Enables all unmasked peripheral interrupts


    //================
    // SPI Setup:
    TRISCbits.TRISC7 = 0; // SDO
    TRISBbits.TRISB4 = 1; // SDI Automatically controlled
    TRISBbits.TRISB6 = 0; // SCK
    TRISCbits.TRISC6 = 0; // CS
    PORTCbits.RC6 = 1;

    SSPCONbits.SSPEN = 0; // SPI disabled
    SSPCONbits.SSPM = 0b0000; //  SPI Master mode, clock = FOSC/4 = 2MHz
    SSPSTATbits.SMP = 1; // input at end of data output time
    SSPSTATbits.CKE = 1; // Data transmitted on rising edge of SCK
    SSPCONbits.CKP = 0;   // Idle low

    SSPCONbits.SSPEN = 1; // SPI Enabled


    //================
    // Setup GPIO for Red Keyboard:
    TRISCbits.TRISC5 = 0; // output to status LED

    // MultA:
    TRISAbits.TRISA4 = 1; // digital in from MultA
    nRABPU = 0; //  0 Enables port A's weakpullups
    WPUAbits.WPUA4 = 1; // Enable RA4's Weak Pullup. Shared pin MultA
    TRISAbits.TRISA2 = 0;
    TRISCbits.TRISC0 = 0;
    TRISCbits.TRISC1 = 0;
    TRISCbits.TRISC2 = 0;

    // MultB:
    TRISAbits.TRISA5 = 1; // digital in from MultB
    nRABPU = 0; //  0 Enables port A's weakpullups
    WPUAbits.WPUA5 = 1; // Enable RA5's Weak Pullup. Shared pin MultB
    TRISBbits.TRISB4 = 0; // S0
    TRISCbits.TRISC3 = 0; // S1
    TRISCbits.TRISC4 = 0; // S2
    // S3 is always zero.

    
}

