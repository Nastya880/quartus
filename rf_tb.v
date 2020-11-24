`timescale 1ns / 10ps

//последовательность записи во все регистры случайных значений и их считывание после проверки правильности

module rf_testbench();

localparam CLK_FREQ_MHZ = 100;
localparam CLK_SEMIPERIOD = (1000/CLK_FREQ_MHZ/2);

	reg 				clk_i;
	reg 	[4:0] 	a1_i ;
	reg 	[4:0] 	a2_i ;
	reg 	[4:0] 	a3_i ;
	reg 	[31:0] 	wd3_i;
	reg 				we3_i;
	reg				reset;
	wire	[31:0]		rd1_o;
	wire	[31:0]		rd2_o;

rf DUT(
	.clk_i		 (clk_i),
	.a1_i 		 (a1_i) ,
	.a2_i 		 (a2_i) ,
	.a3_i 		 (a3_i) ,
	.wd3_i 		 (wd3_i),
	.we3_i 		 (we3_i),
	.reset 		 (reset),
	.rd1_o 		 (rd1_o),
	.rd2_o 		 (rd2_o)
	);

task rf_test_output;
	input integer port;
	input integer address;
	//!!!!!ВЫВОД - сообщения об ошибках об адресах регистров, в которые происходит запись + записанные данные + считанные данные + результат сравнеия
	begin
		if (port == 1) 
			begin
				a1_i = address;
				#10
				$display("%d - data returned from RD1, from %d", rd1_o, address);
			end
		else if (port == 2)
			begin
				a2_i = address;
				#10
				$display("%d - data returned from RD2, from %d", rd2_o, address);
			end
	end
endtask

task rf_test_input;
	input integer data;
	input integer address;
	
	begin
		a3_i = address;
		wd3_i = data;
		#30
		we3_i = 1;
		$display("%d - data written to %d", wd3_i, a3_i);
		#30
		we3_i = 0;
	end
endtask

initial begin
	rf_test_output(1, 32'd0);
	if (rd1_o !=  32'd0)
		$error("bad");
	#50
	rf_test_output(2, 32'd1);
	if (rd2_o !=  32'd1)
		$error("bad");
	#50
	rf_test_output(1, 32'd1);
	if (rd1_o !=  32'd1)
		$error("bad");
	#50
	rf_test_output(1, 32'd7);
	if (rd1_o !=  32'd7)
		$error("bad");
	#50
	rf_test_input(32'd333, 32'd1);
	#50
	rf_test_input(32'd333, 32'd6);
	#50
	rf_test_output(1, 32'd1);
	if (rd1_o !=  32'd333)
		$error("bad");
	#50
	rf_test_output(2, 32'd6);
	if (rd2_o !=  32'd333)
		$error("bad");
	#50
	reset = 1'b1;
	#50
	reset = 1'b0;
	#50
	rf_test_output(1, 32'd0);
	if (rd1_o !=  32'd0)
		$error("bad");
	#50
	rf_test_output(2, 32'd1);
	if (rd2_o !=  32'd0)
		$error("bad");
	#50
	rf_test_output(1, 32'd3);
	if (rd1_o !=  32'd0)
		$error("bad");
	
end


initial begin
  clk_i = 1'b0;
  forever #CLK_SEMIPERIOD clk_i = ~clk_i;  
end
endmodule	