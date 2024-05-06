module decoder(
	input G2B, G2A, G1, C, B, A,
	output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7
);

wire enable;

assign enable = G2B | G2A | ~G1;

assign Y0 = enable | (C | B | A);
assign Y1 = enable | (C | B | ~A);
assign Y2 = enable | (C | ~B | A);
assign Y3 = enable | (C | ~B | ~A);
assign Y4 = enable | (~C | B | A);
assign Y5 = enable | (~C | B | ~A);
assign Y6 = enable | (~C | ~B | A);
assign Y7 = enable | (~C | ~B | ~A);

endmodule