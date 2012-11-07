////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Console Interface
//!
//! \details
//!
//! \note
//!
//! \todo
//!
//! \file
//!      intf.v
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

`include "useq/crom.vh"

module INTF(clk, rst, clken, crom,
            consRUN, consCONT, consEXEC, consHALT,
            cpuRUN,  cpuCONT,  cpuEXEC, cpuHALT
            );

   parameter cromWidth = `CROM_WIDTH;

   input                 clk;                   // clock
   input                 rst;                   // reset
   input                 clken;                 // clock enable
   input [0:cromWidth-1] crom;                  // Control ROM Data
   input                 consRUN;               // Console Run Switch
   input                 consCONT;              // Console Continue Switch
   input                 consEXEC;              // Console Execute Switch
   input                 consHALT;              // Console Halt Switch
   output reg            cpuRUN;                // CPU Run Status
   output reg            cpuCONT;               // CPU Continue Status
   output reg            cpuEXEC;               // CPU Execute Status
   output reg            cpuHALT;               // CPU Halt Status

   //
   // Spec Decoder
   //  CRA2/E97
   //

   wire consEN = `cromSPEC_EN_10 & (`cromSPEC_SEL == `cromSPEC_SEL_CONS);

   //
   // HALT Status
   //  CSL4/E161
   //  CSL4/E162
   //  CSL4/E168
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuHALT <= 1'b0;
        else if (clken & consEN)
          begin
             if (`cromCONS_SET_HALT)
               cpuHALT <= 1'b1;
             else if (`cromCONS_CLR_HALT)
               cpuHALT <= 1'b0;
          end
     end

   //
   // RUN Status
   //  CSL4/E98
   //  CSL4/E135
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuRUN <= 1'b0;
        else if (clken & consEN)
          begin
             if (consRUN)
               cpuRUN <= 1'b1;
             else if (`cromCONS_CLR_RUN)
               cpuRUN <= 1'b0;
          end
     end

   //
   // EXECUTE Status
   //  CSL4/E149
   //  CSL4/E168
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuEXEC <= 1'b0;
        else if (clken & consEN)
          begin
             if (consEXEC)
               cpuEXEC <= 1'b1;
             else if (`cromCONS_CLR_EXEC)
               cpuEXEC <= 1'b0;
          end
     end

   //
   // CONTINUE Status
   //  CSL4/E168
   //  CSL4/E171
   //

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          cpuCONT <= 1'b0;
        else if (clken & consEN)
          begin
             if (consCONT)
               cpuCONT <= 1'b1;
             else if (`cromCONS_CLR_CONT)
               cpuCONT <= 1'b0;
          end
     end

endmodule