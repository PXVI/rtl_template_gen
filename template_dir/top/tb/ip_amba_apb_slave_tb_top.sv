/* -----------------------------------------------------------------------------------
 * Module Name  :
 * Date Created : 18:53:44 IST, 15 May, 2021 [ Saturday ]
 *
 * Author       : pxvi
 * Description  :
 * -----------------------------------------------------------------------------------

   MIT License

   Copyright (c) 2021 k-sva

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

`include "ip_amba_apb_slave_top.v"

module ip_amba_apb_slave_tb_top(   
    `ifdef VERILATOR
            input ip_amba_apb_slave_tb_top_clock
    `endif
);

    /* verilator lint_off MULTITOP */

    // Wires / Registers


    // IP Instantiation
    

    // Dedicated Testbench Core / Code
    

    // ---------------
    // Dump Generation
    // ---------------
    
    `ip_amba_apb_slave_dump
    
    `ifdef VERILATOR
        always@( posedge ip_amba_apb_slave_tb_top_clock )
        begin
            $display( "ip_amba_apb_slave_tb_top : Temporary Code. Disable/Comment this part after running the initial code." );
            $finish;
        end
    `endif

    initial
    begin
        $display( "Testbench is working" );
    end

endmodule
