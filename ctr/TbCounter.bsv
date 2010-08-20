import MyCounter::*;
import StmtFSM::*;

(* synthesize *)
module mkTbCounter();
    Counter counter <- mkCounter();
    Reg#(Bit#(16)) state <- mkReg(0);
   
   function check(expected_val);
      action
         if (counter.read() != expected_val)
            $display("FAIL: counter != %0d", expected_val);
	endaction
      endfunction
   
   Stmt test_seq = 
   seq
      counter.load(42);
      check(42);
      action
	 counter.increment();
	 counter.decrement();
	 check(42);
      endaction
      check(42);
	 
      $display("TESTS FINISHED");
   endseq;
   mkAutoFSM(test_seq);   
endmodule
