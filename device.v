module device (
	input 					clk_i,
	input 		[9:0]		sw_i ,
	input						reset,
	//output 		[6:0]		hex1_o,
	//output 		[6:0]		hex2_o,
	//output 		[6:0]		hex3_o,
	//output 		[6:0]		hex4_o,
	output wire		[31:0]	hex_dec,
	output wire		[31:0]	operation,
	output wire		[31:0]	operand_1,
	output wire		[31:0]	operand_2
);

wire	[31:0] 	instruction	;
wire 	[31:0] 	alu_result	;
wire 	[31:0] 	oper_1		;
wire 	[31:0] 	oper_2		;
wire 			comp_res	;
//wire	[15:0]	hex_dec		;
reg 	[31:0]	write_data	;
reg 	[31:0]	prog_counter;



assign hex_dec = oper_1;
assign operand_1 = oper_1;
assign operand_2 = oper_2;
assign operation = instruction;
initial prog_counter <= 31'h0;


rf regfile(
	.clk_i	(clk_i			   ),
	.a1_i	(instruction[22:18]),  //биты инструкции, над которыми выполняется операция
	.a2_i	(instruction[17:13]),
	.a3_i	(instruction[12:8] ), // в этих битах в инструкции - адрес, по которому будет произведена запись в регистровый файл
//чтобы операнды из гегистрового файла поступали на входы АЛУ - нужжны выходы портов и входы алу
	.wd3_i	(write_data		   ),
	.we3_i	(instruction[29]   ),
	.reset	(reset			   ),
	.rd1_o	(oper_1			   ),
	.rd2_o	(oper_2			   )
);

instruction_memory instr(
	.a_i		(prog_counter),
	.rd_o		(instruction )
	);

miriscv_alu alu(
	.operator_i 			(instruction[26:23]  ), //биты инструкции, которые кодируют операцию для ранее разработанного алу
	.operand_a_i			(oper_1				 ),
	.operand_b_i			(oper_2				 ),
	.result_o				(alu_result			 ),
	.comparision_result_o	(comp_res			 )
);


always @ (posedge clk_i)
	begin
		if (reset) prog_counter <= 31'b0;
		else if (instruction[31])
			prog_counter <= prog_counter + (instruction[7:0] << 2);
		else if (instruction[30])
					begin
						if (comp_res == 1)
							prog_counter <= prog_counter + (instruction[7:0] << 2);
						else
							prog_counter <= prog_counter + 32'd4;
					end
		else
			prog_counter <= prog_counter + 32'd4;
	end

always @ ( * )
	begin
		case (instruction[28:27]) //по этим битам инструкций определяем источник данных, котрые будут записаны
			2'b00 : write_data[31:0] = {{24{instruction[7]}},instruction[7:0]}; 
			2'b01	: write_data[31:0] = sw_i[9:0];
			2'b10 : write_data[31:0] = alu_result;
			default : write_data[31:0] = 32'd0;
		endcase
	end
endmodule