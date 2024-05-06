module washingmachine (
  input CLK, C, L, DW, 
  output reg T,L0,L1,L2,L3,L4,L5,L6,L7
);
parameter IDLE=3'd0,SOAK=3'd1,WASH1=3'd2,RINSE1=3'd3,WASH2=3'd4,RINSE2=3'd5,SPIN=3'd6,STOP=3'd7;
parameter stage_time = 3'd1; // +4 from state transitions for a total of 5 clock pulse per stage
// adjust accordingly

reg [2:0] state, next_state, counter;

initial
begin
  state <= IDLE;
  next_state <= IDLE;
  L0 <= 1'b1;
  L1 <= 1'b0;
  L2 <= 1'b0;
  L3 <= 1'b0;
  L4 <= 1'b0;
  L5 <= 1'b0;
  L6 <= 1'b0;
  L7 <= 1'b0;
  counter <= 3'd0;
end

always @(posedge CLK)
begin
  T <= (counter > stage_time);
  state <= next_state;
  
  L0 <= 1'b0;
  L1 <= 1'b0;
  L2 <= 1'b0;
  L3 <= 1'b0;
  L4 <= 1'b0;
  L5 <= 1'b0;
  L6 <= 1'b0;
  L7 <= 1'b0;
  case (state)
    IDLE: begin
      next_state <= (C) ? SOAK : IDLE;
      L0 <= 1'b1;
    end
    SOAK: begin
      counter <= (T) ? 3'd0 : (counter + 1'd1);
      next_state <= (T) ? WASH1 : SOAK;
      L1 <= 1'b1;
    end
    WASH1: begin
      counter <= (T) ? 3'd0 : (counter + 1'd1);
      next_state <= (T) ? RINSE1 : WASH1;
      L2 <= 1'b1;
    end
    RINSE1: begin
      counter <= (T) ? 3'd0 : (counter + 1'd1);
      if (T) next_state <= (DW) ? WASH2 : SPIN;
      else next_state <= RINSE1;
      L3 <= 1'b1;
    end
    WASH2: begin
      counter <= (T) ? 3'd0 : (counter + 1'd1);
      next_state <= (T) ? RINSE2 : WASH2;
      L4 <= 1'b1;
    end
    RINSE2: begin
      counter <= (T) ? 3'd0 : (counter + 1'd1);
      next_state <= (T) ? SPIN : RINSE2;
      L5 <= 1'b1;
    end
    SPIN: begin
      if (L) next_state <= STOP;
      else begin
        if (T) begin
	      next_state<= IDLE;
	      counter <= 3'd0;
	    end
	    else counter <= counter + 1'd1;
	  end
      L6 <= 1'b1;
      end
    STOP: begin
      next_state <= (L) ? STOP : SPIN;
      counter <= counter;
      L7 <= 1'b1;
    end 
  endcase
end

endmodule