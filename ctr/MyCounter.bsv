interface Counter#(type size_t);
   method Bit#(size_t) read();
   method Action load(Bit#(size_t) newval);
   method Action increment();
   method Action decrement();
endinterface

module mkCounter(Counter#(size_t));
   Reg#(Bit#(size_t)) value <- mkReg(0);
      
   PulseWire increment_called <- mkPulseWire();
   PulseWire decrement_called <- mkPulseWire();

   rule do_increment(increment_called && !decrement_called);
      value <= value + 1;
   endrule

   rule do_decrement(!increment_called && decrement_called);
      value <= value - 1;
   endrule
   
   method Bit#(size_t) read();
      return value;
   endmethod
   
   method Action load(Bit#(size_t) newval);
      value <= newval;
   endmethod
   
   method Action increment();
      increment_called.send();
   endmethod
   
   method Action decrement();
      decrement_called.send();
   endmethod
endmodule