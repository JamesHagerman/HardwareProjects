/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <plib.h>            /* Include to use PIC32 peripheral libraries     */
#include <stdint.h>          /* For uint32_t definition                       */
#include <stdbool.h>         /* For true/false definition                     */
#include "user.h"            /* variables/params used by user.c               */

/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

/* TODO Initialize User Ports/Peripherals/Project here */

void InitApp(void)
{

    // PORT A is all fucked because of JTAG. Input only on A0 and A1 it seems...
    // Disable JTAG so we can use A4 and A5 for gpio (and maybe A0-A3 too?)
    DDPCONbits.JTAGEN = 0;


    // Set GPIO pin functionality:
    // ===========================

    // Note: how to set pins:
    // TRIS*CLR -> clears a pin/bit in the * port
    // TRIS*SET -> sets a pin/bit in the * port
    // TRIS*INV -> inverts a pin/bit in the * port

    // Note: UBW32 pin meaning:
    // Set the LED's on the UBW32 as outputs:
    // RE0 -> yellow
    // RE1 -> red
    // RE2 -> white
    // RE3 -> green
    //
    // RE6 -> PRG button
    // RE7 -> USER button

    // Cleared pins (set to zero) are configured as outputs.
    // This is the hard way to clear pins:
//    TRISECLR = 0x0F;
    
    // And this is the easy way:
    _TRISE0 = 0;    // yellow
    _TRISE1 = 0;    // red
    _TRISE2 = 0;    // white
    _TRISE3 = 0;    // green



    // Set the PRG and USER buttons on the UBW32 as an inputs:
    // This is the hard way:
//    TRISESET = 0x00C0; // This sets pin RE7 and RE6: 1100 0000 = C0
    
    // This is the easy way:
    // 1 = input. 0 = output.
    _TRISE6 = 1;    // PRG
    _TRISE7 = 1;    // USER

    // Because the pic32mx450 has a slightly different pinout, the RE6 and RE7
    // pins are also useable as analog inputs. That means, to use them for any
    // GPIO tasks, we need to disable the ANSEL bits for those pins:
    #if defined(__32MX450F256L__)
    ANSELEbits.ANSE6 = 0;
    ANSELEbits.ANSE7 = 0;
    #endif

    // Just some random input testing:
    _TRISF0 = 1;
    
    // Set RE9 as an output to test the 44.1kHz interupt timing:
    _TRISE9 = 0;

    // Set pin RD8 as an output, could be written as TRISD = 0xFEFF;
    // but that takes more clock cycles to perform:
//    TRISDCLR = 0x0100;


    
    // PWM Intialization:
    // ==================
    // configure RD0 as output for PWM
    // PWM mode, Single output, Active High
    
//    TRISDCLR = 0x00000001;
//    OC1R 	 = 0;
//    OC1CON   = 0x0000;
//    OC1RS    = 0;
//    OC1CON   = 0x0006;
//    OC1CONSET = 0x8000;



    // Set PBCLK This MUST be set in code! Apparently, setting it with the
    // config bits alone is not enough:
    mOSCSetPBDIV( OSC_PB_DIV_1 );

    // Set up some interupts:
    // ======================
    OpenCoreTimer( 0xFFFFFFFF ); // This is needed for the delay functions

    // The next line: turn on timer2 | have it use an internal clock source | have it
    // use a prescaler of 1:256, and use a period of 0xFFFF or 2^16 cycles
    //
    // This fires an interrupt at a frequency of (80MHZ/256/65535), or 4.77
    // times a second.
//    OpenTimer2( T2_ON | T2_SOURCE_INT | T2_PS_1_256, 0xFFFF);

    // Set Timer2 to fire at 44.1kHz:
    // (80MHz/1/44100) = 1814.059 = 1814 = 0x0716 with a prescaler of 1:1
//    OpenTimer2( T2_ON | T2_SOURCE_INT | T2_PS_1_1, 0x0716);

    // Well, actually, it's gonna have to fire at 12.288MHz because we will be
    // generating the main clock manually.
    // (80MHz/1/6) is as close as we can get. And thats 13.333 MHz so no good.
    //
    // Damnit. We can't run this chip at the right speed using a PIC32 as master.
    //

    // Now to use the pic32mx450f256L:
    // With an 8MHz POSC, the closest FOSC we can get to 100MHz while still
    // being able to generate the 48MHz USB clock is by using the PLL:
    // 8MHz, PLL input divider of 2, PLL mult of 24x, PLL output div of 1:
    // 8MHz/2*24/1 = 96MHz
    //
    // Since timers can either use the SOSC (T2_SOURCE_EXT) or PBCLK (T2_SOURCE_INT)
    // as their main clock, those OSC speeds determine the timer speeds.
    //
    // We are not using an SOSC so we will use the PBCLK and it's dividers to
    // figure out the timers timing. The PBCLK postscaler (PBDIV) determines the
    // division of 96MHz in part of this. Currently, the divider is set to 1 so:
    // timer2: 96MHz FOSC, PBCLK div of 1, timer prescale of 1:
    // 96MHz/PBDIV/prescaler/wanted frequency =
    // 96000000/1/44100 = 2176 = 0x880
    OpenTimer2( T2_ON | T2_SOURCE_INT | T2_GATE_OFF | T2_PS_1_1, 0x880);

    /*Configure Multivector Interrupt Mode.  Using Single Vector Mode
    is expensive from a timing perspective, so most applications
    should probably not use a Single Vector Mode*/
    INTConfigureSystem(INT_SYSTEM_CONFIG_MULT_VECTOR);

    // The next line seems to provide the exact same functionality...
    INTEnableSystemMultiVectoredInt();// Use multi-vectored interrupts:


    // This statement configured the timer to produce an interrupt with a priority of 2
    ConfigIntTimer2( T2_INT_ON | T2_INT_PRIOR_2);
}
