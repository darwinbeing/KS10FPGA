//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    UART Object
//!
//! \details
//!    This object provide a UART abstraction.
//!
//! \file
//!    uart.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
//
// This file is part of the KS10 FPGA Project
//
// The KS10 FPGA project is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// The KS10 FPGA project is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this software.  If not, see <http://www.gnu.org/licenses/>.
//
//******************************************************************************

#include <stdint.h>

#include "uart.h"
#include "stdio.h"
#include "console.hpp"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/inc/hw_memmap.h"
#include "driverlib/inc/hw_ints.h"
#include "SafeRTOS/SafeRTOS_API.h"

//
// Static variables
//

static const uint32_t baudrate = 9600;                          //!< baudrate
void initializeUART(void) __attribute__((constructor(101)));    //!< run as constructor

//!
//! \brief
//!    Initialize the UART
//!
//! \details
//!    This function is executed like a constructor so that the UART is
//!    initialize before main() is called.  This guarantees that this function
//!    is executed before all others.  This allows all functions called by
//!    main() to use UART or STDIO functions.
//!

void initializeUART(void) {

    ROM_SysCtlClockSet(SYSCTL_SYSDIV_1 | SYSCTL_USE_OSC | SYSCTL_OSC_MAIN |
                       SYSCTL_XTAL_8MHZ);

    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART1);

    ROM_GPIOPinTypeUART(GPIO_PORTD_BASE, GPIO_PIN_0 | GPIO_PIN_1);
    ROM_GPIOPinConfigure(GPIO_PD0_U1RX);
    ROM_GPIOPinConfigure(GPIO_PD1_U1TX);
    ROM_UARTConfigSetExpClk(UART1_BASE, ROM_SysCtlClockGet(), 9600,
                            UART_CONFIG_PAR_NONE | UART_CONFIG_STOP_ONE |
                            UART_CONFIG_WLEN_8);
}

//!
//! \brief
//!    Enable UART Interrupts
//!
//! \details
//!    This function enables the UART interrupts.  Interrupts should be enabled
//!    after the serial interface queue has been created.
//!

void enableUARTIntr(void) {
    ROM_IntEnable(INT_UART1);
    ROM_UARTIntEnable(UART1_BASE, UART_INT_RX | UART_INT_RT);
    ROM_UARTEnable(UART1_BASE);
}

//!
//! \brief
//!    This function returns the state of the UART Transmitter.
//!
//! \returns
//!    Returns true if the UART transmitter is full.  False otherwise.
//!

bool txFull(void) {
    return ROM_UARTBusy(UART1_BASE);
}

//!
//! \brief
//!    This function outputs a character to the UART transmitter.
//!
//! \param ch -
//!    Character to output to UART transmitter.
//!

void putUART(char ch) {
    ROM_UARTCharPut(UART1_BASE, ch);
}

//!
//! \brief
//!    This function gets a character from the UART receiver queue.
//!
//! \returns
//!    Character read from UART receiver.  -1 if empty.
//!

int getUART(void) {
    char ch;
    portBASE_TYPE status = xQueueReceive(serialQueueHandle, &ch, 0);
    if (status == pdPASS) {
        return ch;
    } else {
        return -1;
    }
}

//!
//! \brief
//!    This function queues a character to a handler task.
//!

void uart1IntHandler(void) {

    char ch = ROM_UARTCharGet(UART1_BASE) & 0x7f;

    portBASE_TYPE taskWoken;
    portBASE_TYPE status = xQueueSendFromISR(serialQueueHandle, &ch, &taskWoken);
    if (status != pdPASS) {
        printf("queue(): Failed to send from ISR.  Status was %ld\n", status);
    }

    ROM_UARTIntClear(UART1_BASE, 0xffffffff);

    taskYIELD_FROM_ISR(taskWoken);
}
