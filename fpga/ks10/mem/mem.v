////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Memory Interface
//!
//! \details
//!
//! \todo
//!
//! \file
//!      mem.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

module MEM(clk, clken, memWRITE, memADDR, memDIN, memDOUT, memACK);

   input          clk;          // Clock
   input          clken;        // Clock enable
   input          memWRITE;     // Write
   input  [14:35] memADDR;      // Address
   input  [ 0:35] memDIN;       // Data in
   output [ 0:35] memDOUT;      // Data out
   output         memACK;       // Memory ACK

   //
   // Address bus resize
   //
   // Note
   //  Only 32K implemented.
   //

   wire [0:14] addr = memADDR[21:35];

   //
   // PDP10 Memory Initialization
   //
   // Note:
   //  We initialize the PDP10 memory with the diagnostic
   //  code.  This saves having to figure out how to load
   //  the code into memory by some other means.
   //
   //  Object code is extracted from the listing file by a
   //  'simple' AWK script and is included below.
   //

   reg [0:35] RAM [0:32767];
   initial
     begin
       `ifdef INITMEM
         `include "dskaa.dat"
       `endif
     end

   //
   // Synchronous RAM
   //
   // Details
   //  This is PDP10 memory.
   //
   // Note:
   //  Only 32K is implemented.  This is sufficient to run the
   //  MAINDEC diagnostics.
   //
   // FIXME
   //  This is temporary and won't synthesize well.  Notice the clock
   //  polarity.
   //

   always @(negedge clk)
     begin
        if (clken)
          begin
             if (memWRITE && (memADDR != 0))
               RAM[memADDR] <= memDIN;
             rd_addr <= memADDR;
          end
     end

   assign memDOUT = RAM[rd_addr];

   //
   // ACK the memory if implemented.x
   //

   assign memACK = memADDR < 32768;

endmodule
