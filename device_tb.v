`timescale 1ns / 10ps

 module device_testbench();
 
 
localparam CLK_FREQ_MHZ = 100;
localparam CLK_SEMIPERIOD = (1000/CLK_FREQ_MHZ/2);

reg 				clk_i;
reg 	[9:0]		sw_i ;
reg				reset;
wire [31:0]	hex_dec;
wire [31:0] operation;
wire [31:0] operand_1;
wire [31:0]	operand_2;

device DUT(
	.clk_i (clk_i),
	.sw_i	 (sw_i ),
	.reset (reset),
	.hex_dec (hex_dec),
	.operation (operation),
	.operand_1 (operand_1),
	.operand_2 (operand_2)
);

initial begin
	sw_i = 10'd2;
	reset = 1'b0;
	#30
	reset = 1'b1;
	#30
	reset = 1'b0;
	end
	
initial begin
  clk_i = 1'b0;
  forever #CLK_SEMIPERIOD clk_i = ~clk_i;  
end

endmodule