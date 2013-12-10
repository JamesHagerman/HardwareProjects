/*
 * Author: James Hagerman
 * Date: December 7, 2013
 *
 * This project is a basic boiler plate/template for the UBW32 development
 * board. It has been patched together from the UBW32 schematic, the chips
 * datasheet, and a few of the tutorials located here:
 *
 * http://umassamherstm5.org/tech-tutorials/pic32-tutorials/ubw32-tutorials
 *
 * Those tutorials were a big help in building out some of this basic
 * template.
 *
 * This code includes:
 * - the PIC42 peripheral libraries
 * - the basic configuration setup lines
 *
 * and most of all:
 * - the lines needed to configure the UBW32 LED's and buttons
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
    SYSTEMConfig(SYS_FREQ, SYS_CFG_ALL); 

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

    // This is left over from some old project
//    LATE = 0x0001;

    while(1)
    {
        LATEbits.LATE0 = PORTEbits.RE7;
        LATEbits.LATE1 = PORTEbits.RE6;
        LATEbits.LATE2 = 0;
        LATEbits.LATE3 = 0;

        // This stuff is left over from some timeing tests:
        
//        //LATF = 0x0020; // set pin F5 high (LATF:5)
//        LATEbits.LATE0 = 1;
//
//        delay_ms(250);
////        delay_ms(250);
//
//        LATEbits.LATE0 = 0;
//
//        delay_ms(250);
////        delay_ms(250);
    }
}
