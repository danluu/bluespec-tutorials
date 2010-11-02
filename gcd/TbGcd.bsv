import GCD::*;
import StmtFSM::*;


module mkTest(); 
	 ArithIO#(Bit#(32)) gcd <- mkGCD;	 
	 
	 Stmt test_seq =
	 seq
			gcd.start(15,25);
			$display("Output is %d",gcd.result);
			gcd.start(7,3);
			$display("Output is %d",gcd.result);
			gcd.start(4242,10000);
			$display("Output is %d",gcd.result);

	 endseq;
	 
	 mkAutoFSM(test_seq);
endmodule:mkTest
