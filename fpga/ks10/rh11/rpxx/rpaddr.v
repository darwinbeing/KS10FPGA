////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   SD Card Sector Address Calculator
//
// Details
//  This calculates:
//

//
// File
//   sdaddr.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
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

module SDADDR(clk, rst, start, lastSURF, lastSECT,
              rpDCA, rpTA, rpSA, sdADDR);
   
   input          clk;          // Clock
   input          rst;          // Reset
   input          start;        //   
   input  [ 4: 0] lastSURF;     // Number of Surfaces
   input  [ 4: 0] lastSECT;     // Number of Sectors
   input  [ 9: 0] rpDCA;        // Cylinder
   input  [ 4: 0] rpTA;         // Track
   input  [ 4: 0] rpSA;         // Sector
   output [31: 0] sdADDR;       // SD Sector Address
                 
   //
   // States
   //
   
   parameter [2:0] stateIDLE  = 0,
                   stateTRACK = 1,
                   stateSECT  = 2,
                   stateWORD  = 3;
   
   //
   // SD Sector Address Calculator State Machine
   //
   
   reg [31:0] sum;
   reg [31:0] temp;
   reg [ 2:0] state;
   reg [ 4:0] loop;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             sum   <= 0;
             temp  <= 0;
             loop  <= 0;
             state <= stateIDLE;
          end
        else
          begin
             case (state)
               stateIDLE:
                 begin
                    if (start)
                      begin
                         sum   <= 0;
                         temp  <= rpDCA;
                         loop  <= lastSURF;
                         state <= stateTRACK;
                      end
                 end
               stateTRACK:
                 begin
                    if (loop == 0)
                      begin
                         sum   <= 0;
                         temp  <= sum + rpTA;
                         loop  <= lastSECT;
                         state <= stateSECT;
                      end
                    else
                      begin
                         sum  <= sum + temp;
                         loop <= loop - 1'b1;
                      end
                 end
               stateSECT:
                 begin
                    if (loop == 0)
                      begin
                         sum   <= sum + rpSA;
                         state <= stateWORD;
                      end
                    else
                      begin
                         sum  <= sum + temp;
                         loop <= loop - 1'b1;
                      end
                 end
               stateWORD:
                 begin
                    sum   <= sum + sum;
                    state <= stateIDLE;
                 end
             endcase
          end
     end

   assign sdADDR = sum;
   
endmodule