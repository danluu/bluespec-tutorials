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

