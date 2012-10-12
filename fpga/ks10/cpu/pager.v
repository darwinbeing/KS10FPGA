////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      Page Tables
//!
//! \details
//!
//! \todo
//!
//! \file
//!      page_table.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2009, 2012 Rob Doyle
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
// details.S
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////
//
// Comments are formatted for doxygen
//

`include "microcontroller/crom.vh"
`include "microcontroller/drom.vh"

module PAGE_TABLES(clk, rst, clken, crom, drom, dp);

   parameter cromWidth = `CROM_WIDTH;
   parameter dromWidth = `DROM_WIDTH;
   
   input 		  clk;        	// Clock
   input 		  rst;          // Reset
   input 		  clken;        // Clock Enable
   input  [0:cromWidth-1] crom;		// Control ROM Data
   input  [0:dromWidth-1] drom;		// Dispatch ROM Data
   input  [0:35]          dp;           // Data path

   //
   // VMA Logic
   //  DPE5/E76
   //  DPE6/E53
   //
   
   wire sweep    = `cromSPEC_EN_20 & (`cromSPEC_SEL == `cromSPEC_SEL_CLRCACHE);
   wire extended = `cromMEM_EXTADDR;		// Put VMA Bits onto Bus
   wire loadVMA  = `cromMEM_LOADVMA;	// Load the VMA
   wire aread    = `cromMEM_AREAD;		// Let DROM select type and load VMA
   wire mem_fun  = `cromMEM_CYCLE;		// 
   wire dromVMA  = `dromVMA;		// 

   wire vma_en = ((mem_fun & loadVMA) | 
                  (mem_fun & aread & dromVMA) |
                  (sweep));

   //
   // Page Table
   //  The Page Tables use asynchronous memory which won't work in
   //  an FPGA.  Since the Page Table is addressed by the VMA
   //  register and the VMA register is loaded synchronously, we can
   //  absorb the VMA register into the Page Table Memory addressing.
   //
   //  The page table translates virtual addresses/page numbers to
   //  phyical addresses/page numbers.  There are 512 virtual pages
   //  which map to 2048 pages.
   //
   //       18                26 27                    35
   //      +--------------------+------------------------+
   //      |Virtual Page Number |        Word Number     |
   //      +--------------------+------------------------+
   //               |
   //               |
   //              \ /
   //       +-------+-------+
   //       |      Page     |
   //       |  Translation  |
   //       +-------+-------+
   //               |
   //               |
   //              \ /
   //  +------------------------+------------------------+
   //  |  Physical Page Number  |        Word Number     |
   //  +------------------------+------------------------+
   //   16                    26 27                    35
   //
   //  DPM6/E130
   //  DPM6/E138
   //  DPM6/E154
   //  DPM6/E146
   //  DPM6/E162
   //  DPM6/E176
   //  DPM6/E184
   //  DPM6/E192
   //

/* -----\/----- EXCLUDED -----\/-----
 
   // FIXME
   
   reg  [0:15] page_table[0:511];
   reg  [0: 8] rd_addr;
   wire [0: 8] virt_page = dp[18:26];
   wire [0:15] din = {page_valid, page_writeable, page_cacheable, page_user,
                                  1'b0 }; 
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          read_addr <= 9'b000_000_000;
        else if (clken & vma_en)
          begin
             if (page_write)
               page_table[virt_page] <= din;
             read_addr <= virt_page;
          end
     end

 
   wire dout[0:15] = page_table[rd_addr];

  
   assign page_valid     = dout[0];
   assign page_writeable = dout[1];
   assign page_cacheable = dout[2];
   assign page_user      = dout[3];
   
 -----/\----- EXCLUDED -----/\----- */
   
   
   
endmodule
