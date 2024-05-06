module shift_reg(CLK, CLRn, S1, S0, SL, SR, LDINPUT, Q);
input CLK, CLRn, S1, S0, SL, SR;
input [3:0] LDINPUT;
output [3:0] Q;

wire [3:0] Q;
reg [3:0] nextQ;

assign Q = (CLRn) ? (nextQ) : (4'b0000);

always @(posedge CLK)
  if (!CLRn) nextQ <= 4'b0000;
  else
    if (S1)
	  if (S0) nextQ <= LDINPUT;
	  else nextQ <= {Q[2:0], SL};
    else
      if(S0) nextQ <= {SR, Q[3:1]};

endmodule
