module bball_scoring(
  input CLK, SW3, SW1, SW4, SW2, PB0, PB1, PB2, PB3, PB4,
  output wire [4:0] shotClock_S,
  output wire [3:0] shotClock_dS, timer_M,
  output wire [5:0] timer_S,
  output wire [7:0] Score1, Score2
);

wire RST;

shotClock shotClk(CLK, SW3, SW1, SW4, RST, shotClock_S, shotClock_dS);
timer gameTime(CLK, SW1, SW2, RST, timer_S, timer_M);
scoreTally scoring(CLK, PB0, PB1, PB2, PB3, PB4, Score1, Score2, RST);

endmodule


module shotClock(
  input CLK, SW3, SW1, SW4, RST,
  output reg [4:0] seconds,
  output reg [3:0] deciseconds
);

wire pe_deciseconds;

assign pe_deciseconds = (deciseconds == 4'd0);

initial begin
  seconds <= 5'd24;
  deciseconds <= 4'd0;
end

always @(posedge CLK or posedge SW3 or posedge SW1 or posedge RST) begin
  if (SW3 | SW1 | RST) begin
    seconds <= 5'd24;
    deciseconds <= 4'd0;
  end
  else begin
    seconds <= (SW4 & pe_deciseconds) ? ((seconds == 5'd0) ? 5'd24 : (seconds - 1'b1)) : seconds;
    deciseconds <= SW4 ? ((pe_deciseconds) ? 4'd9 : (deciseconds - 1'b1)) : deciseconds;
  end
end

endmodule 


module timer(
  input CLK, SW1, SW2, RST,
  output reg [5:0] seconds,
  output reg [3:0] minutes
);

wire pe_deciseconds, p_seconds;
reg [3:0] deciseconds;

assign pe_deciseconds = (deciseconds == 4'd0);
assign p_seconds = (seconds == 6'd0);

initial begin
  seconds <= 6'd0;
  deciseconds <= 4'd0;
  minutes <= 4'd12;
end

always @(posedge CLK or posedge SW1 or posedge RST) begin
  if (SW1 | RST) begin
    seconds <= 5'd0;
    deciseconds <= 4'd0;
    minutes <= 4'd12;
  end
  else begin
    if (SW2) begin
      deciseconds <= pe_deciseconds ? 4'd9 : (deciseconds - 1'b1);
      seconds <= (pe_deciseconds) ? ((minutes == 4'd0) ? 6'd0 : ((p_seconds) ? 6'd59 : (seconds - 1'b1))) : seconds;
      minutes <= (p_seconds & pe_deciseconds) ? ((minutes == 4'd0) ? 4'd0 : (minutes - 1'b1)) : minutes;
    end
    else begin
      deciseconds <= deciseconds;
      seconds <= seconds;
      minutes <= minutes;
    end
  end
end

endmodule

module scoreTally(
  input CLK, PB0, PB1, PB2, PB3, PB4,
  output reg [7:0] Score1, Score2,
  output wire PE0
);

reg RPB0, RPB1, RPB2, RPB3, RPB4;
wire PE1, PE2, PE3, PE4;

assign PE0 = PB0 & ~RPB0;
assign PE1 = PB1 & ~RPB1;
assign PE2 = PB2 & ~RPB2;
assign PE3 = PB3 & ~RPB3;
assign PE4 = PB4 & ~RPB4;
  
initial begin
  RPB0 <= 1'b0;
  RPB1 <= 1'b0;
  RPB2 <= 1'b0;
  RPB3 <= 1'b0;
  RPB4 <= 1'b0;
  Score1 <= 8'd0;
  Score2 <= 8'd0;
end
always @(posedge CLK) begin
  RPB0 <= PB0;
  RPB1 <= PB1;
  RPB2 <= PB2;
  RPB3 <= PB3;
  RPB4 <= PB4;
  
  if (PE0) begin
    Score1 <= 8'd0;
    Score2 <= 8'd0;
  end
  else begin
    if (PE1 & ~PE2) begin
      Score1 <= (&Score1) ? 8'd0 : (Score1 + 1'b1);
    end
    else if (~PE1 & PE2) begin
      Score1 <= (|Score1) ? (Score1 - 1'b1) : 8'd0;
    end
    else begin
      Score1 <= Score1;
    end
  
    if (PE3 & ~PE4) begin
      Score2 <= (&Score2) ? 8'd0 : (Score2 + 1'b1);
    end
    else if (~PE3 & PE4) begin
      Score2 <= (|Score2) ? (Score2 - 1'b1) : 8'd0;
    end
    else begin
      Score2 <= Score2;
    end
  end
end

endmodule