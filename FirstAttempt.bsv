package FirstAttempt;
String s = "Hello World";

(* synthesize *)
module mkAttempt(Empty);
   Reg#(UInt#(3)) ctr <- mkReg(0);
   
   rule end_run (ctr==5);
      $finish(0);
   endrule
   
   rule say_hello;
      ctr <= ctr + 1;
      $display(s);
   endrule
   
endmodule
endpackage