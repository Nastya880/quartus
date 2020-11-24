module rf (
	input 					clk_i,
	input 		[4:0] 	a1_i , //address - 5 битный адрес одного из 32х адресуемых регистра. 
	input 		[4:0] 	a2_i ,
	input 		[4:0] 	a3_i , //остальное - 3 порт для записи
	input 		[31:0]	wd3_i, //write data
	input 					we3_i, //write enable
	input						reset,
	output 	[31:0]	rd1_o, //Read Data - 32битный выход для первого порта чтения регистрового файла
	output	[31:0]	rd2_o //то же, что и rd1_o, только для второго порта
	);

integer i;	
//создать память из 32 32битных ячеек
reg [31:0] RAM [0:31]; //адресуемая память (память с произвольным доступом) 
//2 порта для чтения и 1 для записи 

assign rd1_o = (a1_i != 32'd0) ?  RAM[a1_i] : 32'd0; //подключение выхода к ячейке
assign rd2_o = (a2_i != 32'd0) ?  RAM[a2_i] : 32'd0;

initial $readmemb ("C:/altera/13.0sp1/laba/rf_data.txt", RAM); //инициализация подготовленными данными

always @ (posedge clk_i) //запись данных wd3_i в ячейку

	begin
		if (we3_i) //если сигнал в 1, то по фронту clk по адресу a3_i будут записаны данные со входа wd3_i
			begin
				if (a3_i != 5'd0) RAM[a3_i] <= wd3_i;
			end
		if (reset) //сигнал для сброса содержимого всех регистров в 0
			begin
				for (i = 0; i < 32; i = i + 1) 
					begin
						RAM[i] <= 32'd0;
					end
			end
	end
	
	
endmodule