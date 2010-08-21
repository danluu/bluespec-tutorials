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
	 counter.increment();
	 counter.decrement();
	 check(42);
      endaction
      check(42);
      counter.increment();
      check(43);
      counter.decrement();
      
      $display("TESTS FINISHED");
   endseq;
   mkAutoFSM(test_seq);   
endmodule
