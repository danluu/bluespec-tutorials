import MyCounter::*;
import StmtFSM::*;

(* synthesize *)
module mkTbCounter();
    Counter#(8) counter <- mkCounter();
    Reg#(Bit#(16)) state <- mkReg(0);
   
   function check(expected_val);
      action
         if (counter.read() != expected_val)
            $display("FAIL: counter != %0d", expected_val);
	 else
	    $display("Checked Passed: counter = %0d", expected_val);
	endaction
      endfunction
   
   Stmt test_seq = 
   seq
      counter.load(42);
      check(42);
      action
	 counter.increment(5);
	 counter.decrement(5);
	 check(42);
      endaction
      check(42);
      counter.increment(2);
      check(44);
      counter.decrement(44);
      check(0);
      action
	 counter.increment(5);
	 counter.decrement(0);
      endaction
      check(5);
      $display("TESTS FINISHED");
   endseq;
   mkAutoFSM(test_seq);   
endmodule
