module dec_counter(CLK, LOADn, CTENn, U_Dn, LD_INPUT, MAX_MIN, RCOn, Q);
parameter N=4;
input CLK, LOADn, CTENn, U_Dn;
input [N-1:0] LD_INPUT;
output MAX_MIN, RCOn;
output [N-1:0] Q;

wire [N-1:0] Q;
reg [N-1:0] next_Q;
wire MAX_MIN;

assign MAX_MIN = (U_Dn) ? (Q === 4'b0000) : (Q === 4'b1001);
assign RCOn = !MAX_MIN;
assign Q = (LOADn) ? (next_Q) : (LD_INPUT);

always @(posedge CLK)
  if (!CTENn)
    if (U_Dn) 
      begin
        if (Q===4'b0000|Q>4'b1001) next_Q <= 4'b1001;
        else next_Q <= Q-1;
      end
    else
      begin
        if (Q<4'b1001) next_Q <= Q+1;
        else next_Q <= 4'b0000;
      end
endmodule  

