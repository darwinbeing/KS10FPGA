////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   Dispatch ROM (DROM)
//
// Details
//   The Dispatch ROM maps the instruction (from the Instruction Register) to
//   the address of code that executes that instruction in the Control ROM.
//
// Note
//   The contents of this file was extracted from the microcode listing file by
//   a simple AWK script.  Go see the makefile.
//
// File
//   drom.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "crom.vh"
`include "drom.vh"

module DROM(clk, rst, clken, dbus, crom, drom);

   parameter  cromWidth = `CROM_WIDTH;
   parameter  dromWidth = `DROM_WIDTH;

   input                      clk;      // Clock
   input                      rst;      // Reset
   input                      clken;    // Clock Enable
   input      [0:35]          dbus;     // DBUS
   input      [0:cromWidth-1] crom;     // Control ROM
   output reg [0:dromWidth-1] drom;     // Dispatch ROM Output

   //
   // Microcode decode
   //

   wire loadIR = `cromSPEC_EN_40 & (`cromSPEC_SEL == `cromSPEC_SEL_LOADIR);
   wire [0:8] addr = dbus[0:8];

   //
   // Dispatch ROM initialization
   //
   // Note:
   //  The KS10 microcode is extracted from the listing file by
   //  a 'simple' AWK script and is included below.
   //

   reg [0:dromWidth-1] DROM[0:511];

   initial
     begin
        `include "drom.dat"
     end

   //
   // Dispatch ROM
   //
   // Details:
   //  The DROM in the KS10 is asynchronous.  That won't work in an FPGA
   //  implementation.  Fortunately the DROM is addressed by the Instruction
   //  Register (IR) which is loaded synchronously.  Therefore we can
   //  absorb a copy of the OPCODE portion of IR directly into Dispatch ROM
   //  addressing.
   //
   //  Simply put: when we load the IR, we also synchronously lookup the
   //  contents of the Dispatch ROM.
   //
   // Trace:
   //  DPEA/E98
   //  DPEA/E117
   //  DPEA/E110
   //

   always @(posedge clk)
     begin
        if (clken & loadIR)
          drom <= DROM[addr];
     end

endmodule
