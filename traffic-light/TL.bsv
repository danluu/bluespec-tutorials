package TL;

interface TL;
   method Action ped_button_push();
   
   method Bool lampRedNS();
   method Bool lampAmberNS();
   method Bool lampGreenNS();
      
   method Bool lampRedE();
   method Bool lampAmberE();
   method Bool lampGreenE();

   method Bool lampRedW();
   method Bool lampAmberW();
   method Bool lampGreenW();   
      
   method Bool lampRedPed();
   method Bool lampAmberPed();
   method Bool lampGreenPed();      
endinterface: TL

typedef enum {
   AllRed,
   GreenNS, AmberNS,
   GreenE, AmberE,
   GreenW, AmberW,
   GreenPed, AmberPed} TLstates deriving (Eq, Bits);

typedef UInt#(5) Time32;

(* synthesize *)
module sysTL(TL);
   Time32 allRedDelay = 2;
   Time32 amberDelay = 4;
   Time32 nsGreenDelay = 20;
   Time32 ewGreenDelay = 10;   
   Time32 pedGreenDelay = 10;
   Time32 pedAmberDelay = 6;   
   
   Reg#(TLstates) state <- mkReg(AllRed);
   Reg#(TLstates) next_green <- mkReg(GreenNS);   
   Reg#(Time32) secs <- mkReg(0);   
   Reg#(Bool) ped_button_pushed <- mkReg(False);   
   
   rule inc_sec;
      secs <= secs + 1;
   endrule: inc_sec   

   (* preempts = "fromAllRed, inc_sec" *)
   rule fromAllRed (state == AllRed && secs + 1 >= allRedDelay);
      state <= (ped_button_pushed ? GreenPed : next_green);
      secs <= 0;
      ped_button_pushed <= False;
   endrule: fromAllRed
   
   (* preempts = "fromGreenPed, inc_sec" *)
   rule fromGreenPed (state == GreenPed && secs + 1 >= pedGreenDelay);
      state <= AmberPed;
      secs <= 0;
   endrule: fromGreenPed
   
   (* preempts = "fromAmberPed, inc_sec" *)
   rule fromAmberPed (state == AmberPed && secs + 1 >= pedAmberDelay);
      state <= AllRed;
      secs <= 0;
   endrule: fromAmberPed
   
   (* preempts = "fromGreenNS, inc_sec" *)
   rule fromGreenNS (state == GreenNS && secs + 1 >= nsGreenDelay);
      state <= AmberNS;
      secs <= 0;
   endrule: fromGreenNS

   (* preempts = "fromAmberNS, inc_sec" *)
   rule fromAmberNS (state == AmberNS && secs + 1 >= amberDelay);
      state <= AllRed;
      secs <= 0;
      next_green <= GreenE;
   endrule: fromAmberNS

   (* preempts = "fromGreenE, inc_sec" *)
   rule fromGreenE (state == GreenE && secs + 1 >= ewGreenDelay);
      state <= AmberE;
      secs <= 0;
   endrule: fromGreenE

   (* preempts = "fromAmberE, inc_sec" *)
   rule fromAmberE (state == AmberE && secs + 1 >= amberDelay);
      state <= AllRed;
      secs <= 0;
      next_green <= GreenW;
   endrule: fromAmberE

   (* preempts = "fromGreenW, inc_sec" *)
   rule fromGreenW (state == GreenW && secs + 1 >= ewGreenDelay);
      state <= AmberW;
      secs <= 0;
   endrule: fromGreenW

   (* preempts = "fromAmberW, inc_sec" *)
   rule fromAmberW (state == AmberW && secs + 1 >= amberDelay);
      state <= AllRed;
      secs <= 0;
      next_green <= GreenNS;
   endrule: fromAmberW

   method Action ped_button_push();   
      ped_button_pushed <= True;
   endmethod: ped_button_push
   
   method lampRedNS() = (!(state == GreenNS || state == AmberNS));
   method lampAmberNS() = (state == AmberNS);
   method lampGreenNS() = (state == GreenNS);
   method lampRedE() = (!(state == GreenE || state == AmberE));
   method lampAmberE() = (state == AmberE);
   method lampGreenE() = (state == GreenE);
   method lampRedW() = (!(state == GreenW || state == AmberW));
   method lampAmberW() = (state == AmberW);
   method lampGreenW() = (state == GreenW);   
      
   method lampRedPed() = (!(state == GreenPed || state == AmberPed));
   method lampAmberPed() = (state == AmberPed);
   method lampGreenPed() = (state == GreenPed);
      
endmodule: sysTL

endpackage: TL

