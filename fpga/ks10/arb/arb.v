////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 Bus Arbiter
//
// Details
//   This device is the KS10 Bus Arbiter and Bus Multiplexer
//
// File
//   arb.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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
`timescale 1ns/1ps

module ARB (
      // CPU Interfaces
      input  wire        cpuREQI,       // CPU Bus Request
      output reg         cpuACKO,       // CPU Bus Acknowledge
      input  wire [0:35] cpuADDRI,      // CPU Address
      input  wire [0:35] cpuDATAI,      // CPU Data In
      output reg  [0:35] cpuDATAO,      // CPU Data Out
      // Console Interfaces
      input  wire        cslREQI,       // CSL Bus Request In
      output reg         cslREQO,       // CSL Bus Request Out
      input  wire        cslACKI,       // CSL Bus Acknowledge In
      output reg         cslACKO,       // CSL Bus Acknowledge Out
      input  wire [0:35] cslADDRI,      // CSL Address In
      input  wire [0:35] cslDATAI,      // CSL Data In
      output reg  [0:35] cslDATAO,      // CSL Data Out
      // UBA Interfaces
      input  wire [0: 3] ubaREQI,       // UBA Bus RequestIn
      output reg         ubaREQO,       // UBA Bus Request Out
      input  wire [0: 3] ubaACKI,       // UBA Bus Acknowledge In
      output reg  [0: 3] ubaACKO,       // UBA Bus Acknowledge Out
      input  wire [0:35] uba0ADDRI,     // UBA 0 Address In
      input  wire [0:35] uba1ADDRI,     // UBA 1 Address In
      input  wire [0:35] uba2ADDRI,     // UBA 2 Address In
      input  wire [0:35] uba3ADDRI,     // UBA 3 Address In
      input  wire [0:35] uba0DATAI,     // UBA 0 Data In
      input  wire [0:35] uba1DATAI,     // UBA 1 Data In
      input  wire [0:35] uba2DATAI,     // UBA 2 Data In
      input  wire [0:35] uba3DATAI,     // UBA 3 Data In
      output reg  [0:35] ubaDATAO,      // UBA Data Out
      // Memory Interfaces
      output reg         memREQO,       // MEM Bus Request Out
      input  wire        memACKI,       // MEM Bus Acknowledge In
      input  wire [0:35] memDATAI,      // MEM Data In
      output reg  [0:35] memDATAO,      // MEM Data Out
      // ARB Output
      output reg  [0:35] arbADDRO       // ARB Address
   );

   //
   // Bus Request Arbitration
   //
   // Details:
   //  Console has highest priority
   //  Unibus has next priority
   //  CPU has lowest priority
   //

   always @*
     begin

        cpuACKO  = 0;
        cslREQO  = 0;
        cslACKO  = 0;
        ubaREQO  = 0;
        ubaACKO  = 0;
        memREQO  = 0;
        arbADDRO = 36'b0;
        cslDATAO = 36'bx;
        cpuDATAO = 36'bx;
        memDATAO = 36'bx;
        ubaDATAO = 36'bx;

        //
        // Bus Request from the Console
        //
        // Details
        //  The console can access the memory or the unibus
        //

        if (cslREQI)
          begin
             ubaREQO  = 1;
             memREQO  = 1;
             arbADDRO = cslADDRI;
             cpuDATAO = cslDATAI;
             memDATAO = cslDATAI;
             ubaDATAO = cslDATAI;
             if (memACKI)
               begin
                  cslACKO  = 1;
                  cslDATAO = memDATAI;
               end
             else if (ubaACKI[0])
               begin
                  cslACKO  = 1;
                  cslDATAO = uba0DATAI;
               end
             else if (ubaACKI[1])
               begin
                  cslACKO  = 1;
                  cslDATAO = uba1DATAI;
               end
             else if (ubaACKI[2])
               begin
                  cslACKO  = 1;
                  cslDATAO = uba2DATAI;
               end
             else if (ubaACKI[3])
               begin
                  cslACKO  = 1;
                  cslDATAO = uba3DATAI;
               end
          end

        //
        // Bus Request from the Unibus #0
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[0])
          begin
             memREQO  = 1;
             arbADDRO = uba0ADDRI;
             cslDATAO = uba0DATAI;
             cpuDATAO = uba0DATAI;
             memDATAO = uba0DATAI;
             if (memACKI)
               begin
                  ubaACKO[0] = 1;
                  ubaDATAO   = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #1
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[1])
          begin
             memREQO  = 1;
             arbADDRO = uba1ADDRI;
             cslDATAO = uba1DATAI;
             cpuDATAO = uba1DATAI;
             memDATAO = uba1DATAI;
             if (memACKI)
               begin
                  ubaACKO[1] = 1;
                  ubaDATAO   = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #2
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[2])
          begin
             memREQO  = 1;
             arbADDRO = uba2ADDRI;
             cslDATAO = uba2DATAI;
             cpuDATAO = uba2DATAI;
             memDATAO = uba2DATAI;
             if (memACKI)
               begin
                  ubaACKO[2] = 1;
                  ubaDATAO   = memDATAI;
               end
          end

        //
        // Bus Request from the Unibus #3
        //
        // Details
        //  The unibus can access the memory
        //

        else if (ubaREQI[3])
          begin
             memREQO  = 1;
             arbADDRO = uba3ADDRI;
             cslDATAO = uba3DATAI;
             cpuDATAO = uba3DATAI;
             memDATAO = uba3DATAI;
             if (memACKI)
               begin
                  ubaACKO[3] = 1;
                  ubaDATAO   = memDATAI;
               end
          end

        //
        // Bus Request from the CPU
        //
        // Details
        //  The CPU can access the memory, unibus or console.
        //
        // Note
        //  The ARB needs to assert a 36'b0 on the data bus if no device
        //  acknowledges a WRU bus cycle.  This occurs on a PI interrupt.
        //  This simulates the DEC KS10 which implemented this using a
        //  tristated bus with pullups.
        //

        else if (cpuREQI)
          begin
             cslREQO  = 1;
             ubaREQO  = 1;
             memREQO  = 1;
             arbADDRO = cpuADDRI;
             cslDATAO = cpuDATAI;
             memDATAO = cpuDATAI;
             ubaDATAO = cpuDATAI;

             if (memACKI)
               begin
                  cpuACKO  = 1;
                  cpuDATAO = memDATAI;
               end
             else if (ubaACKI[0])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = uba0DATAI;
               end
             else if (ubaACKI[1])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = uba1DATAI;
               end
             else if (ubaACKI[2])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = uba2DATAI;
               end
             else if (ubaACKI[3])
               begin
                  cpuACKO  = 1;
                  cpuDATAO = uba3DATAI;
               end
             else if (cslACKI)
               begin
                  cpuACKO  = 1;
                  cpuDATAO = cslDATAI;
               end
             else
               cpuDATAO = 0;

          end
     end

endmodule
