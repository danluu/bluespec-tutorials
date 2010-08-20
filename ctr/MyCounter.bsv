interface Counter;
   method Bit#(8) read();
   method Action load(Bit#(8) newval);
   method Action increment();
   method Action decrement();
endinterface

(* synthesize *)
module mkCounter(Counter);
   Reg#(Bit#(8)) value <- mkReg(0);
      
   PulseWire increment_called <- mkPulseWire();
   PulseWire decrement_called <- mkPulseWire();

   rule do_increment(increment_called && !decrement_called);
      value <= value + 1;
   endrule

   rule do_decrement(!increment_called && decrement_called);
      value <= value - 1;
   endrule
   
   method Bit#(8) read();
      return value;
   endmethod
   
   method Action load(Bit#(8) newval);
      value <= newval;
   endmethod
   
   method Action increment();
      increment_called.send();
   endmethod
   
   method Action decrement();
      decrement_called.send();
   endmethod
endmodule