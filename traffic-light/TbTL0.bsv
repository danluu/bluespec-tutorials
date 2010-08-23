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