package TbTL;

import TL::*;

interface Lamp;
   method Bool changed;
   method Action show_offs;
   method Action show_ons;
   method Action reset;
endinterface

module mkLamp#(String name, Bool lamp)(Lamp);
   Reg#(Bool) prev <- mkReg(False);

   method changed = (prev != lamp);
      
   method Action show_offs;
      if (prev && !lamp)
	 $write (name + " off, ");
   endmethod
      
   method Action show_ons;
      if (!prev && lamp)
	 $write (name + " on, ");
   endmethod
      
   method Action reset;
      prev <= lamp;
   endmethod
endmodule


(* synthesize *)
module mkTest();
   let dut <- sysTL;
   
   Reg#(Bit#(8)) ctr <- mkReg(0);
   
   Lamp lamps[9];   
   
   lamps[0] <- mkLamp("0: NS  red  ", dut.lampRedNS);
   lamps[1] <- mkLamp("1: NS  amber", dut.lampAmberNS);
   lamps[2] <- mkLamp("2: NS  green", dut.lampGreenNS);
   lamps[3] <- mkLamp("3: E   red  ", dut.lampRedE);
   lamps[4] <- mkLamp("4: E   amber", dut.lampAmberE);
   lamps[5] <- mkLamp("5: E   green", dut.lampGreenE);
   lamps[6] <- mkLamp("6: W   red  ", dut.lampRedW);
   lamps[7] <- mkLamp("7: W   amber", dut.lampAmberW);
   lamps[8] <- mkLamp("8: W   green", dut.lampGreenW);   
   
   rule start (ctr == 0);
      $dumpvars;
   endrule

   rule go;
      ctr <= ctr + 1;
   endrule

   rule stop (ctr > 128);
      $display("TESTS FINISHED");
      $finish(0);
   endrule

   function do_offs(l) = l.show_offs;
   function do_ons(l) = l.show_ons;
   function do_reset(l) = l.reset;
      
   function do_it(f);
      action
	 for (Integer i=0; i<9; i=i+1)
	    f(lamps[i]);
      endaction
   endfunction
      
   function any_changes();
      Bool b = False;
      for (Integer i=0; i<9; i=i+1)
	 b = b || lamps[i].changed;
      return b;
   endfunction

   rule show (any_changes());
      do_it(do_offs);
      do_it(do_ons);
      do_it(do_reset);
      $display("(at time %d)", $time);
   endrule   
endmodule

endpackage

/* How to run without using the (relatively) heavy bluespec environment:
 1. Using bluesim
 a. bsc -sim -g mkTest -u TbTL.bsv 
 b. bsc -sim -e mkTest
 c. ./a.out
 */