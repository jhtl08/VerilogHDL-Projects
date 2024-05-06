module pingpong(
  input CLK, SW0, SW1, SW2, PB0, PB1,
  output wire [9:0] LEDs,
  output reg [8:0] maxT,
  output reg [2:0] Score1, Score2
);
parameter IDLE=10'b0000000000,
		  L0=10'b1000000000,
		  L1=10'b0100000000,
		  L2=10'b0010000000,
		  L3=10'b0001000000,
		  L4=10'b0000100000,
		  L5=10'b0000010000,
		  L6=10'b0000001000,
		  L7=10'b0000000100,
		  L8=10'b0000000010,
		  L9=10'b0000000001,
		  maxScore=3'd7;

edgeDetect peED(CLK, PB0, PB1, RPE0, RPE1);

wire T, RPE0, RPE1;
wire [8:0] speed_select;
reg [9:0] state, next_state;
reg [8:0] count, next_maxT;
reg next_dir, state_dir, dir;
reg [2:0] next_Score1, next_Score2;

assign T = (count == maxT);
assign LEDs = state; // moore
assign speed_select = SW1 ? ( SW2 ? 9'd50 : 9'd100) :
                      (SW2 ? 9'd200 : 9'd400);
assign gameOver = (Score1 == 3'd7) | (Score2 == 3'd7);

initial begin
  state <= L0;
  next_state <= L0;
  maxT <= 9'd400;
  next_maxT <= 9'd400;
  count <= 9'd0;
  dir <= 1'b1; // going right 
  next_dir <= 1'b1;
  Score1 <= 3'd0;
  Score2 <= 3'd0;
  next_Score1 <= 3'd0;
  next_Score2 <= 3'd0;
end

always @(posedge CLK or posedge SW0)
begin
  if (SW0) begin
    count <= 9'd0;
    dir <= 1'b1;
    maxT <= speed_select;
  end
  else begin
    count <= T ? 9'd0 : (count + 1'b1);
    dir <= next_dir;
    maxT <= next_maxT;
  end
end

always @(posedge T or posedge SW0)
begin
  if (SW0) begin
    Score1 <= 3'd0;
    Score2 <= 3'd0;
    state <= next_state;
    state_dir <= 1'b1;
    end
  else begin
    Score1 <= next_Score1;
    Score2 <= next_Score2;
    state <= next_state;
    state_dir <= next_dir;
  end
end

always @(state or RPE0 or RPE1 or dir or Score1 or Score2 or maxT or speed_select or state_dir)
begin
    case(state)
      IDLE: begin
        next_state <= dir ? L0 : L9;
        next_dir <= ~state_dir; 
        next_maxT <= speed_select;
        if (gameOver) next_Score1 <= 3'd0;
        else next_Score1 <= dir ? Score1 : (Score1 + 1'b1);
        if (gameOver) next_Score2 <= 3'd0;
        else next_Score2 <= dir ? (Score2 + 1'b1) : Score2;
      end
      L0: begin
        next_state <= dir ? L1 : IDLE;
        next_dir <= RPE0 ? 1'b1 : dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L1: begin
        next_state <= dir ? L2 : L0;
        next_dir <= RPE0 ? 1'b1 : dir;
        if (RPE0) next_maxT <= (maxT == 6'd50) ? maxT : 
                       {1'b0, maxT[8:1]}; // divides by two
        else next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L2: begin 
        next_state <= dir ? L3 : L1;
        next_dir <= dir; 
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L3: begin 
        next_state <= dir ? L4 : L2;
        next_dir <= dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L4: begin 
        next_state <= dir ? L5 : L3;
        next_dir <= dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L5: begin 
        next_state <= dir ? L6 : L4;
        next_dir <= dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L6: begin
        next_state <= dir ? L7 : L5;
        next_dir <= dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L7: begin
        next_state <= dir ? L8 : L6;
        next_dir <= dir;
	    next_maxT <= maxT;
	    next_Score1 <= Score1;
        next_Score2 <= Score2;
   	  end
      L8: begin
        next_state <= dir ? L9 : L7;
        next_dir <= RPE1 ? 1'b0 : dir;
        if (RPE1) next_maxT <= (maxT == 6'd50) ? maxT : 
                       {1'b0, maxT[8:1]}; // divides by two
        else next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
      L9: begin
        next_state <= dir ? IDLE : L8;
        next_dir <= RPE1 ? 1'b0 : dir;
        next_maxT <= maxT;
        next_Score1 <= Score1;
        next_Score2 <= Score2;
      end
    endcase
end
endmodule

module edgeDetect(
  input CLK, PB0, PB1, 
  output reg RPE0, RPE1
);

reg RPB0, RPB1;

always @(posedge CLK)
begin
  RPB0 <= PB0;
  RPB1 <= PB1;
  RPE0 <= PB0 & ~RPB0;
  RPE1 <= PB1 & ~RPB1;
end
  
endmodule