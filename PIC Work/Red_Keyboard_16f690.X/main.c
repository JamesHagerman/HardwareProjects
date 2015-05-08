/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#include <xc.h>         /* XC8 General Include File */
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

void write16_eeprom(uint8_t addr, uint16_t value) {
    uint8_t lo_byte = value & 0xFF;
    uint8_t hi_byte = value >> 8;

//    printf("Writing: %i\t Low: %i \t high: %i\n\r", value, lo_byte, hi_byte);
    eeprom_write(addr, lo_byte);
    while(WR){
        printf(".");
    }
    eeprom_write(addr+1, hi_byte);
    while(WR){
        printf(".");
    }
}
uint16_t read16_eeprom(uint8_t addr) {
    uint8_t lo_byte = eeprom_read(addr);
    uint8_t hi_byte = eeprom_read(addr+1);
    uint16_t toRet = (hi_byte << 8 | lo_byte);
//    printf("low: %i \t high: %i\t combined: %i\n\r", lo_byte, hi_byte, toRet);

    return toRet;
}

//=============
// Keyboard Input:
// Setup MultA control pins:
#define MultAS0 PORTAbits.RA2
#define MultAS1 PORTCbits.RC0
#define MultAS2 PORTCbits.RC1
#define MultAS3 PORTCbits.RC2

// Setup MultB control pins:
#define MultBS0 PORTBbits.RB4
#define MultBS1 PORTCbits.RC3
#define MultBS2 PORTCbits.RC4

static uint16_t key_count = 23;
uint16_t pressed_keys = 0;
uint16_t last_key = 0;
uint8_t current_key = 0;
uint16_t tuning[23];

// Check a key and return true if it's currently pressed
bool checkKey(uint8_t keyVal) {
   keyVal = (key_count - keyVal - 1); // Flip the index
   if (keyVal <= 15) {
        MultAS0 = (keyVal >> 0) & 1;
        MultAS1 = (keyVal >> 1) & 1;
        MultAS2 = (keyVal >> 2) & 1;
        MultAS3 = (keyVal >> 3) & 1;

        __delay_ms(1); // It takes some time to update the multiplexer

        if (PORTAbits.RA4 == 0) {
            return true;
        }
    } else {
        MultBS0 = (keyVal >> 0) & 1;
        MultBS1 = (keyVal >> 1) & 1;
        MultBS2 = (keyVal >> 2) & 1;

        __delay_ms(1); // It takes some time to update the multiplexer

        if (PORTAbits.RA5 == 0) {
            return true;
        }
    }
    return false;
}

// take a keyCode between 0-22 and convert it to a number between 0-4095
uint32_t get_voltage(uint32_t keyCode) {
    //NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
//    return (keyCode * 4095) / (key_count-1);
    
    // We do NOT want the full 5 volt range though.
    // 4095/5 = 819 = 1 volt
    // The keyboard has 12 keys in an octave in the middle of the board...
    // but 11 keys above and below that middle octave.
    // That makes 1.91667 volts across the full keyboard.
    // That means: 819*1.916 = 1569.752... so, 1570 is the HIGH end of the keyboard.
    //
    // This is not accounting for temperament...
//    return (keyCode * 1502) / (key_count-1); 
    
    // We're now using values from the tuning array:
    return tuning[keyCode];
}

// Tuning mode:
bool in_tuning_mode = false;
int8_t currently_tuning = 0;
void tuningCheck() {
    // This will check to see if the two highest lowest keys are currently pressed
    // If so, the program will enter a "tuning mode" that will allow offsets to
    // be written into the chips EEPROM.
    if (checkKey(21) && checkKey(22)) {
        in_tuning_mode = true;
        printf("\n\rEntering tuning mode...\n\r");
    }
}


void load_tuning() {
    for (current_key = 0; current_key < key_count; current_key += 1) {
        tuning[current_key] = read16_eeprom(current_key*2);
    }
}
void print_tuning() {
    for (current_key = 0; current_key < key_count; current_key += 1) {
        printf("Note: %i\t Value: %i\n\r",current_key, tuning[current_key]);
    }
}
void save_tuning() {
    for (current_key = 0; current_key < key_count; current_key += 1) { 
        uint16_t value = tuning[current_key];
        printf("Writing value: %i", value);
        write16_eeprom(current_key*2, value);
        printf("Done!\n\r");
    }
}
void check_key_range() {
    if (currently_tuning < 0) {
        currently_tuning = 0;
    } else if (currently_tuning > key_count-1) {
        currently_tuning = key_count-1;
    }
    printf("Current key: %i\n\r", currently_tuning);
}
void move_down() {
    currently_tuning -= 1;
    check_key_range();
}
void move_up() {
    currently_tuning += 1;
    check_key_range();
}

void check_value_range(uint8_t key) {
    uint16_t value = tuning[key];
    if (value > 5000 ) { // unsigned. therefore, strange.
        tuning[key] = 0;
    } else if (value > 4095) {
        tuning[key] = 4095;
    }
    printf("Current key: %i\t Current value: %i\n\r", key, tuning[key]);
//    SPI_Write(tuning[key]);
}
void tune_down(uint8_t key) {
    uint16_t value = tuning[key];
    tuning[key] = value - 1;
    check_value_range(key);
}
void tune_up(uint8_t key) {
    uint16_t value = tuning[key];
    tuning[key] = value + 1;
    check_value_range(key);
}

void resetTuning() {
    printf("Resetting tuning to factory defaults...\n\r");
    for (current_key = 0; current_key < key_count; current_key += 1) {
        tuning[current_key] = (current_key * 1502) / (key_count-1);
    }
    save_tuning();
    printf("Tuning reset to factory defaults. Better tune it again!\n\r");
    printf("We'll put you back in tuning mode so you can fix it now. \n\r");
}

void tune() {
    // Slow this mode down so we don't get double ui interaction:
    __delay_ms(100);
    
    // Loop through the keys to allow us to manage the tuning mode
    for (current_key = 0; current_key < key_count; current_key += 1) {
        if (checkKey(current_key)) {
            // If lowest key on keyboard is pressed, exit tuning mode:
            if (current_key == 0) {
                in_tuning_mode = false;
                save_tuning();
                break;
            }

            // Pick which key we're currently tuning
            if (current_key == 19) {
                move_up();
            }
            if (current_key == 17) {
                move_down();
            }
            
            // Actually tune the key:
            if (current_key == 18) {
                tune_down(currently_tuning);
            }
            if (current_key == 20) {
                tune_up(currently_tuning);
            }
            
            if (current_key == 5) {
                resetTuning();
            }

        } 
    }
    SPI_Write(tuning[currently_tuning]);
}

void play() {
    pressed_keys = 0;
    last_key = 100;
    for (current_key = 0; current_key < key_count; current_key += 1) {
        if (checkKey(current_key)) {
            pressed_keys += 1;
            last_key = current_key;
        } 
    }

    if (pressed_keys > 0) {
        PORTCbits.RC5 = 1; // Gate on

        uint16_t real_value = get_voltage(last_key); 
//        printf("Last Key: %i \t Real Value: %i  \t Pressed Keys: %i \n\r", last_key, real_value, pressed_keys);
        SPI_Write(real_value);
    } else {
        PORTCbits.RC5 = 0; // Gate off
    }
}



/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/
void main(void)
{
    /* Configure the oscillator for the device */
    ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    InitApp();
    
    printf("\n\rRed Keyboard by James Hagerman 2015\n\r");
    
    // Load and print tuning values stored in EEPROM:
    load_tuning();
//    print_tuning();
    
    // Save the tuning as a test:
//    save_tuning();
    
    // Check to see if we should enter tuning mode:
    tuningCheck();
    while(in_tuning_mode) {
        tune();
    }

    __delay_ms(1000);
    while(1)
    {
        play();
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
    }

}

