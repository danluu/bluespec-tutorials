package FirstAttempt;
String s = "Hello World";

(* synthesize *)
module mkAttempt(Empty);
   rule say_hello;
      $display(s);
   endrule
endmodule
endpackage