package FirstAttempt;
String s = "Hello World";

(* synthesize *)
module mkAttempt(Empty);
   rule say_hello;
      $display(s);
      $finish(0);
   endrule
endmodule
endpackage