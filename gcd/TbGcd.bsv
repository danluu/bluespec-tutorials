import GCD::*;
import StmtFSM::*;


module mkTest(); 
   Reg#(Bit#(32)) n <- mkReg(1);
   Reg#(Bit#(32)) m <- mkReg(1);
	 ArithIO#(Bit#(32)) gcd <- mkGCD;	 	 

	 Stmt test = 
	 seq
			for (n <= 1; n < 7; n <= n + 1) 
				 for (m <= 1; m < 11; m <= m + 1) seq
						gcd.start(n, m);
						$display("gcd(%d,%d)=%d",n,m,gcd.result);
				 endseq
	 endseq;
	 
	 mkAutoFSM(test);
	 
endmodule:mkTest
