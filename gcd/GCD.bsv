package GCD;

interface ArithIO#(type a); 
	 method Action start (a n, a m); 
	 method a result; 
endinterface: ArithIO 

module mkGCD(ArithIO#(Bit#(size_t))); 
	 Reg#(Bit#(size_t)) n(); 
	 mkRegU r1(n); 

	 Reg #(Bit#(size_t)) m(); 
	 mkRegU r2(m); 
	 
	 rule swap (n > m && m != 0); 
			n <= m; 
			m <= n; 
	 endrule 
	 
	 rule sub (n <= m && m != 0); 
			m <= m - n; 
	 endrule 
	 
	 method Action start(Bit#(size_t) in_n, Bit#(size_t) in_m) if (m == 0); 
			action 
				 n <= in_n; 
				 m <= in_m; 
			endaction 
	 endmethod: start 
	 
	 method Bit#(size_t) result() if (m == 0); 
			result = n; 
	 endmethod: result 
endmodule: mkGCD 
endpackage: GCD
