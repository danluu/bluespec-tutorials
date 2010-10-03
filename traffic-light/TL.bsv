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
typedef UInt#(20) CtrSize;

(* synthesize *)
module sysTL(TL);
   Time32 allRedDelay = 2;
   Time32 amberDelay = 4;
   Time32 nsGreenDelay = 20;
   Time32 ewGreenDelay = 10;   
   Time32 pedGreenDelay = 10;
   Time32 pedAmberDelay = 6;   
   
   CtrSize clocks_per_sec = 100;
   
   Reg#(TLstates) state <- mkReg(AllRed);
   Reg#(TLstates) next_green <- mkReg(GreenNS);   
   Reg#(Time32) secs <- mkReg(0);   
   Reg#(Bool) ped_button_pushed <- mkReg(False);   
   Reg#(CtrSize) cycle_ctr <- mkReg(0);
   
   rule dec_cycle_ctr (cycle_ctr != 0);
      cycle_ctr <= cycle_ctr - 1;
   endrule
   
   rule inc_sec (cycle_ctr == 0);
      secs <= secs + 1;
      cycle_ctr <= clocks_per_sec;
   endrule: inc_sec   
   
   function Action next_state(TLstates ns);
      action
	 state <= ns;
	 secs <= 0;
      endaction
   endfunction: next_state      
   
   (* preempts = "fromAllRed, inc_sec" *)
   rule fromAllRed (state == AllRed && secs >= allRedDelay);
      if (ped_button_pushed)
	 next_state(GreenPed);
      else
	 next_state(next_green);

      ped_button_pushed <= False;
   endrule: fromAllRed
   
   (* preempts = "fromGreenPed, inc_sec" *)
   rule fromGreenPed (state == GreenPed && secs >= pedGreenDelay);
      next_state(AmberPed);
   endrule: fromGreenPed
   
   (* preempts = "fromAmberPed, inc_sec" *)
   rule fromAmberPed (state == AmberPed && secs >= pedAmberDelay);
      next_state(AllRed);
   endrule: fromAmberPed
   
   (* preempts = "fromGreenNS, inc_sec" *)
   rule fromGreenNS (state == GreenNS && secs >= nsGreenDelay);
      next_state(AmberNS);
   endrule: fromGreenNS

   (* preempts = "fromAmberNS, inc_sec" *)
   rule fromAmberNS (state == AmberNS && secs >= amberDelay);
      next_state(AllRed);
      next_green <= GreenE;
   endrule: fromAmberNS

   (* preempts = "fromGreenE, inc_sec" *)
   rule fromGreenE (state == GreenE && secs >= ewGreenDelay);
      next_state(AmberE);
   endrule: fromGreenE

   (* preempts = "fromAmberE, inc_sec" *)
   rule fromAmberE (state == AmberE && secs >= amberDelay);
      next_state(AllRed);
      next_green <= GreenW;
   endrule: fromAmberE

   (* preempts = "fromGreenW, inc_sec" *)
   rule fromGreenW (state == GreenW && secs >= ewGreenDelay);
      next_state(AmberW);
   endrule: fromGreenW

   (* preempts = "fromAmberW, inc_sec" *)
   rule fromAmberW (state == AmberW && secs >= amberDelay);
      next_state(AllRed);
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

