package TL;

interface TL;
   method Bool lampRedNS();
   method Bool lampAmberNS();
   method Bool lampGreenNS();
      
   method Bool lampRedE();
   method Bool lampAmberE();
   method Bool lampGreenE();

   method Bool lampRedW();
   method Bool lampAmberW();
   method Bool lampGreenW();   
endinterface: TL

typedef enum {
   AllRed,
   GreenNS, AmberNS,
   GreenE, AmberE,
   GreenW, AmberW} TLstates deriving (Eq, Bits);

(* synthesize *)
module sysTL(TL);
   Reg#(TLstates) state <- mkReg(AllRed);
   Reg#(TLstates) next_green <- mkReg(GreenNS);   

   rule fromAllRed (state == AllRed);
      state <= next_green;
   endrule: fromAllRed

   rule fromGreenNS (state == GreenNS);
      state <= AmberNS;
   endrule: fromGreenNS
   
   rule fromAmberNS (state == AmberNS);
      state <= AllRed;
      next_green <= GreenE;
   endrule: fromAmberNS

   rule fromGreenE (state == GreenE);
      state <= AmberE;
   endrule: fromGreenE

   rule fromAmberE (state == AmberE);
      state <= AllRed;
      next_green <= GreenW;
   endrule: fromAmberE

   rule fromGreenW (state == GreenW);
      state <= AmberW;
   endrule: fromGreenW

   rule fromAmberW (state == AmberW);
      state <= AllRed;
      next_green <= GreenNS;
   endrule: fromAmberW
   
   method lampRedNS() = (!(state == GreenNS || state == AmberNS));
   method lampAmberNS() = (state == AmberNS);
   method lampGreenNS() = (state == GreenNS);
   method lampRedE() = (!(state == GreenE || state == AmberE));
   method lampAmberE() = (state == AmberE);
   method lampGreenE() = (state == GreenE);
   method lampRedW() = (!(state == GreenW || state == AmberW));
   method lampAmberW() = (state == AmberW);
   method lampGreenW() = (state == GreenW);   
endmodule: sysTL

endpackage: TL

