/*
 * Author: James Hagerman
 * Date: December 7, 2013
 *
 * This project is a basic boiler plate/template for using the the UBW32
 * development board as a development core for a digital synthesizer. It is
 * basically a fork from the UBW_32_starter_project.X project that I put
 * together a while back. That project was patched together from the UBW32
 * schematic, the PIC32MX datasheet, and a few of the tutorials located here:
 *
 * http://umassamherstm5.org/tech-tutorials/pic32-tutorials/ubw32-tutorials
 *
 * Those tutorials were a big help in building out some of this basic
 * template.
 *
 * This code includes:
 * - the PIC42 peripheral libraries
 * - the basic configuration setup lines
 * - the lines needed to configure the UBW32 LED's and buttons
 *
 * This code will include (in the future):
 * - SPI communication setup configuration
 * - SPI send and receive commands
 * - Wolfson WM8731 CODEC Chip control interface (over SPI)
 * - Wolfson WM8731 PCM->I2S interface.
 * - A basic example of using the WM8731 for ADC/DAC.
 * - Serial communication (at least send)
 *
 *
 * SPI Info groked from the UMASS Tutorials:
 *
 * The PIC32MX4xxH series on the CUI32 has one SPI channel.
 * The PIC32MX7xxH series on the UBW32 has three SPI channels.
 *
 * SPI1 Setup: (NOT USED IN CODE BELOW!!!)
 * ? Chip Select (CS) : PIC32 pin RD9  (SS1) This is under OUR MANUAL control!
 * ?  Data Out (MOSI) : PIC32 pin RD0  (SDO1)
 * ?   Data In (MISO) : PIC32 pin RC4  (SDI1)
 * ?   SPICLOCK (SCK) : PIC32 pin RD10 (SCK1)
 *
 * SPI2 Setup:
 * ? Chip Select (CS) : PIC32 pin RG9  (SS2) This is under OUR MANUAL control!
 * ?  Data Out (MOSI) : PIC32 pin RG8  (SDO2)
 * ?   Data In (MISO) : PIC32 pin RG7  (SDI2)
 * ?   SPICLOCK (SCK) : PIC32 pin RG6  (SCK2)
 *
 */


/******************************************************************************/
/*  Files to Include                                                          */
/******************************************************************************/

#include <plib.h>           /* Include to use PIC32 peripheral libraries      */
#include <stdint.h>         /* For uint32_t definition                        */
#include <stdbool.h>        /* For true/false definition                      */

#include "system.h"         /* System funct/params, like osc/periph config    */
#include "user.h"           /* User funct/params, such as InitApp             */

/******************************************************************************/
/* Global Variable Declaration                                                */
/******************************************************************************/

/* i.e. uint32_t <variable_name>; */

// Needed for __delay_ms and __delay_us
#define _XTAL_FREQ 80000000

// I/O Definitions
#define DAC_CS _RG9 // DAC chip select
#define DAC_TCS _TRISG9 // DAC tris control for CS pin
#define ADC_CS _RA0 // DAC chip select
#define ADC_TCS _TRISA0 // DAC tris control for CS pin


// ===========================================================================
// ShortDelay - Delays (blocking) for a very short period (in CoreTimer Ticks)
// ---------------------------------------------------------------------------
// The DelayCount is specified in Core-Timer Ticks.
// This function uses the CoreTimer to determine the length of the delay.
// The CoreTimer runs at half the system clock.
// If CPU_CLOCK_HZ is defined as 80000000UL, 80MHz/2 = 40MHz or 1LSB = 25nS).
// Use US_TO_CT_TICKS to convert from uS to CoreTimer Ticks.
// ---------------------------------------------------------------------------

void ShortDelay(                       // Short Delay
  UINT32 DelayCount)                   // Delay Time (CoreTimer Ticks)
{
  UINT32 StartTime;                    // Start Time
  StartTime = ReadCoreTimer();         // Get CoreTimer value for StartTime
  while ( (UINT32)(ReadCoreTimer() - StartTime) < DelayCount ) {};
}

// delay in microseconds function
void delay_us( uint32_t delay ){
        // note that 1 core tick = 2 SYS cycles (this is fixed)
        int us_ticks=(SYS_FREQ/1000000)/2;
        WriteCoreTimer( 0 );
        while( ReadCoreTimer() < delay*us_ticks );
} // END delay_us()

void delay_ms(unsigned char delay)	// Max input is 255, add second delay if you need more time...
{
   unsigned char one_ms;
   one_ms = 0xFF;
   while (delay--)
   {
       do
       {
           one_ms--;
       } while (one_ms);
   }
}

/*
 SPI Methods:
 */
// send one byte of data and receive one back at the same time
char writeSPI2_8( char i ){
    SPI2BUF = i; // write to buffer for TX
    while( !SPI2STATbits.SPIRBF ); // wait for TX complete
    return SPI2BUF; // read the received values
} // END writeSPI2()

// send one byte of data and receive one back at the same time
int16_t writeSPI2_16( int16_t i ){
    SPI2BUF = i; // write to buffer for TX
    while( !SPI2STATbits.SPIRBF ); // wait for TX complete
    return SPI2BUF; // read the received values
} // END writeSPI2_16()

// send one byte of data and receive one back at the same time
int32_t writeSPI2_32( int32_t i ){
    SPI2BUF = i; // write to buffer for TX
    while( !SPI2STATbits.SPIRBF ); // wait for TX complete
    return SPI2BUF; // read the received values
} // END writeSPI2_32()



// write data to AD5206 digital pot
//void writePot( char addr, char potVal ){
//    CS = 0; // select chip
//    writeSPI2_8( addr );
//    writeSPI2_8( potVal );
//    CS = 1; // release chip
//} // END writePot()

// Write data to the MCP4921 12bit DAC:
void writeDAC(int16_t data) {
    DAC_CS = 0;
    int16_t config = 0x3 << 12;
    data = data & 0x0FFF; // strip off just the 12 bits of data we actually have
    writeSPI2_16(config | data);
    DAC_CS = 1;
}

// Write and read data back from the MCP3204 DAC:
int32_t readADC(int32_t data) {
    int32_t toRet;
    ADC_CS = 0;
    toRet = writeSPI2_32(data);
    ADC_CS = 1;
    return toRet;
}


/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/

int32_t main(void)
{

    /*Refer to the C32 peripheral library compiled help file for more
    information on the SYTEMConfig function.
    
    This function sets the PB divider, the Flash Wait States, and the DRM
    /wait states to the optimum value.  It also enables the cacheability for
    the K0 segment.  It could has side effects of possibly alter the pre-fetch
    buffer and cache.  It sets the RAM wait states to 0.  Other than
    the SYS_FREQ, this takes these parameters.  The top 3 may be '|'ed
    together:
    
    SYS_CFG_WAIT_STATES (configures flash wait states from system clock)
    SYS_CFG_PB_BUS (configures the PB bus from the system clock)
    SYS_CFG_PCACHE (configures the pCache if used)
    SYS_CFG_ALL (configures the flash wait states, PB bus, and pCache)*/

    /* TODO Add user clock/system configuration code if appropriate.  */
    SYSTEMConfig(SYS_FREQ, SYS_CFG_ALL | SYS_CFG_PCACHE);

    OpenCoreTimer( 0xFFFFFFFF );

    /* Initialize I/O and Peripherals for application */
    InitApp();

    /*Configure Multivector Interrupt Mode.  Using Single Vector Mode
    is expensive from a timing perspective, so most applications
    should probably not use a Single Vector Mode*/
    INTConfigureSystem(INT_SYSTEM_CONFIG_MULT_VECTOR);

    /* TODO <INSERT USER APPLICATION CODE HERE> */

    // This is how you get the values of the buttons on the UBW32:
    //something = PORTEbits.RE7 // PRG button
    //something = PORTEbits.RE6 // USER button

    // Set up the SPI peripheral:
    // CKP (clock polarity control) = 0
    // CKE (clock edge control) = 1
    // 8-bit, Master Mode
    // Baud = 4MHz (Fpb/20 = 80/20 MHz)
//    SpiChnOpen( 2, SPICON_MSTEN | SPICON_CKE | SPICON_ON | SPICON_MODE32, 20 ); // Old variable names

    // New SPI Peripheral setup config lines:
    // The last value is the baud rate.
    // 3.3333 = 24MHz
    //      8 = 10MHz
    //     20 = 4MHz


    // 8 bit transfer:
//    SpiChnOpen( SPI_CHANNEL2, SPI_OPEN_MSTEN | SPI_OPEN_MODE8, 20 ); // New variable names

    // 16 bit transfer:
    SpiChnOpen( SPI_CHANNEL2, SPI_OPEN_MSTEN | SPI_OPEN_MODE16, 4 ); // New variable names

    // 32 bit transfer:
//    SpiChnOpen( SPI_CHANNEL2, SPI_OPEN_MSTEN | SPI_OPEN_MODE32, 20 ); // New variable names


    // Set the demo CS pin (_RG9) as an output, and set it high to release the
    // chip. The pin will be set LOW when we need to write to the device.
    DAC_TCS = 0; // make CS pin output
    DAC_CS = 1; // release chip
    ADC_TCS = 0; // make CS pin output
    ADC_CS = 1; // release chip
    
    bool statusLed = false;

    while(1)
    {
        LATEbits.LATE0 = PORTEbits.RE7;
//        LATEbits.LATE1 = PORTEbits.RE6;
        if (statusLed == false) {
            statusLed = true;
        } else {
            statusLed = false;
        }
        LATEbits.LATE1 = statusLed;
        LATEbits.LATE2 = 0;
        LATEbits.LATE3 = 0;

        // 0011 (output a, unbuffered, gain of 1x, enable the output buffer)
        writeDAC(0x0);

        delay_us(10); // 500ms
        writeDAC(0xFFF);
        
        delay_us(10); // 500ms
    }

    return 1;
}

