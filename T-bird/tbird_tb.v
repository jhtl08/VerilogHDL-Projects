`timescale 1ns / 1ps

module tbird_tb;
  reg CLK, SW0, SW1, SW2;
  wire [7:0] TLIGHT;
  
  tbird test (
        .CLK(CLK),
        .SW0(SW0),
        .SW1(SW1),
        .SW2(SW2),
        .TLIGHT(TLIGHT)
    );
  
  always #(5) CLK = ~CLK;
  
  initial
    begin
      CLK = 0;
      SW0 = 0;
      SW1 = 0;
      SW2 = 0;
      #100;
      
      // Test Case 1
      SW1 = 1;
      #50;
      SW2 = 1;
      #50;
      
      // Test Case 2
      SW1 = 0;
      #50;
      SW2 = 1;
      #50;
      
      // Test Case 3
      SW0 = 1;
      #50;
      SW1 = 1;
      #50;
      
      // Test Case 4
      SW2 = 0;
      #50;
      SW1 = 0;
      #50;
      
      $finish; 
    end
endmodule