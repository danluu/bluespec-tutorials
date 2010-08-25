package TL;

interface TL;
endinterface: TL

typedef enum {
   GreenNS, AmberNS, RedAfterNS,
   GreenE, AmberE, RedAfterE,
   GreenW, AmberW, RedAfterW} TLstates deriving (Eq, Bits);

(* synthesize *)
module sysTL(TL);
   Reg#(TLstates) state <- mkReg(RedAfterW);
   
   rule fromGreenNS (state == GreenNS);
      state <= AmberNS;
   endrule: fromGreenNS
   
   rule fromAmberNS (state == AmberNS);
      state <= RedAfterNS;
   endrule: fromAmberNS

   rule fromRedAfterNS (state == RedAfterNS);
      state <= GreenE;
   endrule: fromRedAfterNS

   rule fromGreenE (state == GreenE);
      state <= AmberE;
   endrule: fromGreenE

   rule fromAmberE (state == AmberE);
      state <= RedAfterE;
   endrule: fromAmberE

   rule fromRedAfterE (state == RedAfterE);
      state <= GreenW;
   endrule: fromRedAfterE

   rule fromGreenW (state == GreenW);
      state <= AmberW;
   endrule: fromGreenW

   rule fromAmberW (state == AmberW);
      state <= RedAfterW;
   endrule: fromAmberW

   rule fromRedAfterW (state == RedAfterW);
      state <= GreenNS;
   endrule: fromRedAfterW
endmodule: sysTL

endpackage: TL

