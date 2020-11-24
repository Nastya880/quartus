`timescale 1ns / 1ps

`define ALU_ADD 6'b011000
`define ALU_SUB 6'b011001
`define ALU_XOR 6'b101111
`define ALU_OR  6'b101110
`define ALU_AND 6'b010101
`define ALU_SRA 6'b100100
`define ALU_SRL 6'b100101
`define ALU_SLL 6'b100111
`define ALU_LTS 6'b000000
`define ALU_LTU 6'b000001
`define ALU_GES 6'b001010
`define ALU_GEU 6'b001011
`define ALU_EQ  6'b001100
`define ALU_NE	6'b001101

module testbench();

reg 	[6:0] 	operator_i;
reg 	[31:0]	operand_a_i;
reg 	[31:0]	operand_b_i;
wire 	[31:0]	result_o;
wire				comparision_result_o;

miriscv_alu DUT(
	.operator_i 				(operator_i),
	.operand_a_i 				(operand_a_i),
	.operand_b_i 				(operand_b_i),
	.result_o 					(result_o),
	.comparision_result_o 	(comparision_result_o)
	);

task alu_oper_test;
	input integer oper_i;
	input integer a_i;
	input integer b_i;
	integer file;
		
	begin
		operator_i = oper_i;
		operand_a_i = a_i;
		operand_b_i = b_i;
		#10
		
		$display("a_i = %d", operand_a_i, " b_i = %d", operand_b_i);
		$display("result = %d" , result_o, " comparision result = %d", comparision_result_o);
		//$display("Time = %t", $realtime);
		
		file = $fopen("task_log.txt","a+");
		$fwrite(file,"\n");
		$fwrite(file, "operation = %d", operator_i, " a_i = %d", operand_a_i, " b_i = %d\n", operand_b_i);
		$fwrite(file,"result = %d" , result_o, " comparision result = %d\n", comparision_result_o);
		//$fwrite(file,"Time = %t\n", $realtime);
		$fclose(file);
	end
endtask	
	
initial begin
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, 1, 1);
	if (result_o != 10'd2)
		$error("***TEST FAILED***");
	$display(" ");
	#20
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, 50, 34);
	if (result_o != 10'd84)
		$error("***TEST FAILED***");
	#20
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, 4000000000, 4000000000);
	if (result_o != 10'd8000000000)
		$error("***TEST FAILED***");
	#20
	alu_oper_test(`ALU_ADD, 1000000000, 1111111111);
	if (result_o != 10'd2111111111)
		$error("***TEST FAILED***");
	#20
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, 1111111111, 1010101010);
	if (result_o != 10'd2121212121)
		$error("***TEST FAILED***");
	#20
	alu_oper_test(`ALU_ADD, -321, 100);
	if (result_o != -10'd221)
		$error("***TEST FAILED***");
	#20
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, -4000000000, -4000000000);
	if (result_o != -10'd8000000000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_ADD");
	alu_oper_test(`ALU_ADD, 0, 1);
	if (result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 1, 1);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 50, 34);
	if (result_o != 10'd16)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 4000000000, 4000000000);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 1000000000, 1111111111);
	if (result_o != -10'd111111111)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 1111111111, 1010101010);
	if (result_o != -10'd101010101)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, -321, 100);
	if (result_o != -10'd421)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, -4000000000, -4000000000);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SUB");
	alu_oper_test(`ALU_SUB, 0, 1);
	if (result_o != -10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_XOR");	
	alu_oper_test(`ALU_XOR, 1, 1);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 50, 34);
	if (result_o != 10'd16)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 4000000000, 4000000000);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 1000000000, 1111111111);
	if (result_o != 10'd2040594375)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 1111111111, 1010101010);
	if (result_o != 10'd2114903765)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 321, 100);
	if (result_o != 10'd293)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 4000000000, 1);
	if (result_o != 10'd4000000001)
		$error("***TEST FAILED***");
	#20
	$display("ALU_XOR");
	alu_oper_test(`ALU_XOR, 0, 1);
	if (result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_OR");	
	alu_oper_test(`ALU_OR, 1, 1);
	if (result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 50, 34);
	if (result_o != 10'd50)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 4000000000, 4000000000);
	if (result_o != 10'd4000000000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 1000000000, 1111111111);
	if (result_o != 10'd2075852743)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 1111111111, 1010101010);
	if (result_o != 10'd2118057943)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 321, 100);
	if (result_o != 10'd357)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 4000000000, 4000000000);
	if (result_o != 10'd4000000000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_OR");
	alu_oper_test(`ALU_OR, 0, 0);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_AND");	
	alu_oper_test(`ALU_AND, 1, 1);
	if (result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 50, 34);
	if (result_o != 10'd34)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 4000000000, 4000000000);
	if (result_o != 10'd4000000000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 1000000000, 1111111111);
	if (result_o != 10'd35258368)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 1111111111, 1010101010);
	if (result_o != 10'd3154178)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 321, 100);
	if (result_o != 10'd64)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 4000000000, 4000000000);
	if (result_o != 10'd4000000000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_AND");
	alu_oper_test(`ALU_AND, 0, 0);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_SRA");	
	alu_oper_test(`ALU_SRA, 1, 1);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 50, 3);
	if (result_o != 10'd6)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 24, 2);
	if (result_o != 10'd6)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 1000000000, 4);
	if (result_o != 10'd62500000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 1111111111, 20);
	if (result_o != 10'd1059)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 321, 10);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 1, 30);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRA");
	alu_oper_test(`ALU_SRA, 0, 0);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_SRL");		
	alu_oper_test(`ALU_SRL, 1, 1);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 50, 3);
	if (result_o != 10'd6)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 24, 2);
	if (result_o != 10'd6)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 1000000000, 4);
	if (result_o != 10'd62500000)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 1111111111, 20);
	if (result_o != 10'd1059)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 321, 10);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 1, 30);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SRL");
	alu_oper_test(`ALU_SRL, 0, 0);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 1, 1);
	if (result_o != 10'd2)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 50, 3);
	if (result_o != 10'd400)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 24, 2);
	if (result_o != 10'd96)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 1000000000, 4);
	if (result_o != 10'd3115098112)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 1111111111, 20);
	if (result_o != 10'd1550843904)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 321, 10);
	if (result_o != 10'd328704)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 1, 30);
	if (result_o != 10'd1073741824)
		$error("***TEST FAILED***");
	#20
	$display("ALU_SLL");		
	alu_oper_test(`ALU_SLL, 0, 0);
	if (result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	

	$display("ALU_LTS");			
	alu_oper_test(`ALU_LTS, 1, 1);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 50, 34);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 4000000000, 4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 1000000000, 1111111111);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 1111111111, 1010101010);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 321, 1000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 4000000000, 4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTS");
	alu_oper_test(`ALU_LTS, 0, 0);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
   
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 1, 1);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 50, 34);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 4000000000, 4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 1000000000, 1111111111);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 1111111111, 1010101010);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, -321, 100);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, -4000000000, -4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_LTU");
	alu_oper_test(`ALU_LTU, 0, 0);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 1, 1);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 50, 34);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 4000000000, 4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 1000000000, 1111111111);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 1111111111, 1010101010);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 321, 100);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 4000000000, 4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GES");
	alu_oper_test(`ALU_GES, 0, 0);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 1, 1);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 50, 34);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 4000000000, 4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 1000000000, 1111111111);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 1111111111, 1010101010);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, -321, 100);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU,4000000000, -4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_GEU");
	alu_oper_test(`ALU_GEU, 0, 0);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 1, 1);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 50, 34);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 4000000000, 4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 1000000000, 1111111111);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 1111111111, 1010101010);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, -321, 100);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, -4000000000, -4000000000);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_EQ");
	alu_oper_test(`ALU_EQ, 0, 0);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	
	
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 1, 1);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 50, 34);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 4000000000, 4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 1000000000, 1111111111);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 1111111111, 1010101010);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, -321, 100);
	if (comparision_result_o != 10'd1)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, -4000000000, -4000000000);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	#20
	$display("ALU_NE");
	alu_oper_test(`ALU_NE, 0, 0);
	if (comparision_result_o != 10'd0)
		$error("***TEST FAILED***");
	$finish;
end

endmodule