module dm (
//ПОБАЙТОВАЯ АДРЕСАЦИЯ!!!!!
	input 				 clk_i, //сихронимпульс
	input 		[31:0] a_i  , //32битный 
	input 		[31:0] wd_i , //32битная шина данных
	input 				 we_i ,
	output wire	[31:0] rd_o //выход- 32битное содержимое 4х последовательных байтовых ячеек памяти (4 байта = 32бита)
	);

reg [31:0] MEM [0:63]; 

assign rd_o = (24'h710000 == a_i[31:8]) ?  MEM[a_i[7:2]] : 32'd0;

//считывание не 1го байта, а 32битного слова -  4 байт (получаю с выхода)
//адрес слова должен быть кратен 4 (количеству входящих байт) - отсюда 2 младших разряда = 0


always @ (posedge clk_i) 
	begin
		if (we_i) //если сигнал разрешения we_i в 1, то по сигналу clk_i записываем данные по адресу a_i
			begin
				MEM[a_i[7:2]] <= wd_i;
			end
	end
	
endmodule