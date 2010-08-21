interface Counter#(type size_t);
   method Bit#(size_t) read();
   method Action load(Bit#(size_t) newval);
   method Action increment(Bit#(size_t) inc_by);
   method Action decrement(Bit#(size_t) dec_by);
endinterface

module mkCounter(Counter#(size_t));
   Reg#(Bit#(size_t)) value <- mkReg(0);
      
   Wire#(Bit#(size_t)) inc_val <- mkWire();
   Wire#(Bit#(size_t)) dec_val <- mkWire();
   
   
   (* descending_urgency = "do_both, do_increment, do_decrement" *)
   rule do_both;
      value <= value + inc_val - dec_val;
   endrule
   
   rule do_increment;
      value <= value + inc_val;
   endrule

   rule do_decrement;
      value <= value - dec_val;
   endrule
   
   method Bit#(size_t) read();
      return value;
   endmethod
   
   method Action load(Bit#(size_t) newval);
      value <= newval;
   endmethod
   
   method Action increment(inc_by);
      inc_val <= inc_by;
   endmethod
   
   method Action decrement(dec_by);
      dec_val <= dec_by;
   endmethod
endmodule