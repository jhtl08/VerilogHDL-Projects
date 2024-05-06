module tbird(CLK, SW0, SW1, SW2, TLIGHT);
input CLK, SW0, SW1, SW2;
output wire [7:0] TLIGHT;

reg [3:0] LEFT, RIGHT;

assign TLIGHT = {LEFT[3:0], RIGHT[3:0]};

always @(posedge CLK) 
begin
    if (SW1) LEFT <= (LEFT[3]) ? 4'b0000 : {LEFT[2:0], 1'b1};
    else LEFT <= {SW0, SW0, SW0, SW0};

    if (SW2) RIGHT <= (RIGHT[0]) ? 4'b0000 : {1'b1, RIGHT[3:1]};
    else RIGHT <= {SW0, SW0, SW0, SW0};
end

endmodule
