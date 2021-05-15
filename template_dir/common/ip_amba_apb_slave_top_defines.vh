/* -----------------------------------------------------------------------------------
 * Module Name  :
 * Date Created : 10:27:43 IS, 14 January, 2020 [ Tuesday ] 
 *
 * Author       : pxvi
 * Description  :
 * -----------------------------------------------------------------------------------

   MIT License

   Copyright (c) 2020 k-sva

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the Software), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.

 * ----------------------------------------------------------------------------------- */

/* ---------------
 * Example Defines
 * ---------------

`define SOMETHING_width         4
*/

`define debug( x ) \
    `ifdef ip_amba_apb_slave_debug_en \
        $display( $sformat( "ip_amba_apb_slave : %s", x ) ); \
    `endif

`define ip_amba_apb_slave_dump \
    `ifdef ip_amba_apb_slave_dump_en \
        initial begin \
            $display( "ip_amba_apb_slave : VCD Dump Generation Is Enabled ( ip_amba_apb_slave.vcd )" ); \
            $dumpfile( "ip_amba_apb_slave.vcd" ); \
            $dumpvard( 0, ip_amba_apb_slave_top ); \
        end \
    `elsif ip_amba_apb_slave_tb_dump_en \
        initial begin \
            $display( "ip_amba_apb_slave_tb : VCD Dump Generation Is Enabled ( ip_amba_apb_slave_tb.vcd )" ); \
            $dumpfile( "ip_amba_apb_slave_tb.vcd" ); \
            $dumpvard( 0, ip_amba_apb_slave_tb_top ); \
        end \
    `endif

// ip_amba_apb_slave_check_en :    
//
// Use define this to write an assertion or a simple
// functionality check for basic testing. If
// enabled from the make/run script, the checks
// will be run.

// ip_amba_apb_slave_fa_en :    
//
// Use this define to write formal assertion and then
// run them using the make switch
