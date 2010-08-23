package TbTL0;

import TL0::*;

(* synthesize *)
module mkTest();
   let dut <- sysTL;
   
   Reg#(Bit#(8)) ctr <- mkReg(0);

   rule go;
      ctr <= ctr + 1;
   endrule

   rule stop (ctr > 128);
      $display("TESTS FINISHED");
      $finish(0);
   endrule
endmodule

endpackage

/* How to run without using the (relatively) heavy bluespec environment:
 1. Using bluesim
 a. bsc -sim -g mkTest -u TbTL0.bsv 
 b. bsc -sim -e mkTest
 c. ./a.out
 */