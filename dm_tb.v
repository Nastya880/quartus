`timescale 1ns / 10ps
//написан после написания тестбенча для rf (поэтому мало комментирую)   ))
module dm_testbench();

localparam CLK_FREQ_MHZ = 100;
localparam CLK_SEMIPERIOD = (1000/CLK_FREQ_MHZ/2);

reg 				clk_i;
reg 	[31:0] 	a_i ;
reg 	[31:0] 	wd_i;
reg 				we_i;
wire	[31:0]	rd_o;

dm DUT(
	.clk_i		 (clk_i),
	.a_i 		 	 (a_i)  ,
	.wd_i 		 (wd_i) ,
	.we_i 		 (we_i) ,
	.rd_o 		 (rd_o)
	);

task dm_test_output;
	input integer address;
	
	begin
		a_i = address;
		#30
		$display("%d - data returned from RD, from %d", rd_o, a_i[7:2]);
	end
endtask

task dm_test_input;
	input integer data;
	input integer address;
	
	begin
		a_i = address;
		wd_i = data;
		#30
		we_i = 1;
		$display("%d - data written to %d", wd_i, a_i[7:2]);
		#30
		we_i = 0;
	end
endtask


initial begin
	dm_test_output(32'd0);
	if (rd_o !=  32'd0)
		$error("TEST NOT OK");
	#50
	dm_test_input(32'd333, 32'h71000010);
	#50
	dm_test_output(32'h71000010);
	if (rd_o !=  32'd333)
		$error("TEST NOT OK");
	//dm_test_input(32'd333, 32'h67111110);
	//#50
	dm_test_output(32'h71000011);
	if (rd_o !=  32'd333)
		$error("TEST NOT OK");
end


initial begin
  clk_i = 1'b0;
  forever #CLK_SEMIPERIOD clk_i = ~clk_i;  
end


endmodule