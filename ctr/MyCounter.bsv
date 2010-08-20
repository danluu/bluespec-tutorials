interface Counter;
   method Bit#(8) read();
   method Action load(Bit#(8) newval);
   method Action increment();
endinterface