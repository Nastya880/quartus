`include "./miriscv_defines.v"

//уже есть АЛУ, регистровый файл и память
//программа из инструкций
//использую другие названия инструкций (не те, которые в лабе приведены - все комментирую)

module op_decoder(
input 	[31:0] fetched_instr_i, 
output 	[1:0]  ex_op_a_sel_o, // мультиплексор на выбор первого операнда
output 	[2:0]  ex_op_b_sel_o, // мультиплексор на выбор второго операнда
output 	[5:0]  alu_op_o, // операция алу
output 			 mem_req_o, // запрос на доступ чтения памяти
output 			 mem_we_o, // сигнал разрешения записи в память (== 0 - читаем)
output 	[2:0]  mem_size_o, // сигнал для выбора размера слова при чтении-записи
output 			 gpr_we_a_o, // разрешение записи в рег файл
output 			 wb_src_sel_o, // мультиплексор выбор данных для записи в рег файл
output 			 illegal_instr_o, // некоррект инстр
output 			 branch_o, // условный переход
output 			 jal_o,  // безусловный переход
output 			 jalr_o // безусловный переход
);

wire  [1:0] last_opcode_bits;
wire  [4:0]  opcode;
wire  [6:0]  funct7;
wire  [2:0]  funct3;
reg   [4:0]  rs1;
reg   [4:0]  rs2;
reg   [4:0]  rd;

assign last_opcode_bits = fetched_instr_i[1:0];
assign opcode = fetched_instr_i[6:2];
assign funct7 = fetched_instr_i[31:25];
assign funct3 = fetched_instr_i[14:12];

always @ ( * ) begin
    mem_req_o       <= 1'b0; //доступ к памяти закрыт
    mem_we_o        <= 1'b0;
    gpr_we_a_o      <= 1'b0; // запись в регфайл закрыта
    ex_op_a_sel_o   <= 2'd0;
    ex_op_b_sel_o   <= 3'd0;
    branch_o        <= 1'b0;
    jal_o           <= 1'b0;
    jalr_o          <= 1'b0;
    illegal_instr_o <= 1'b0;
    case (opcode)
        `OP_OPCODE  : begin
            ex_op_a_sel_o <= 2'd0;
            ex_op_b_sel_o <= 3'd0;
            gpr_we_a_o    <= 1'b1;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу в регфайл
            case ({funct7, funct3})
                10'b0000000_000 : alu_op_o <= `ALU_ADD;
                10'b0100000_000 : alu_op_o <= `ALU_SUB;
                10'b0000000_001 : alu_op_o <= `ALU_SLL;
                10'b0000000_010 : alu_op_o <= `ALU_SLT;
                10'b0000000_011 : alu_op_o <= `ALU_SLTU;
                10'b0000000_100 : alu_op_o <= `ALU_XOR;
                10'b0000000_101 : alu_op_o <= `ALU_SRL;
                10'b0100000_101 : alu_op_o <= `ALU_SRA;
                10'b0000000_110 : alu_op_o <= `ALU_OR;
                10'b0000000_111 : alu_op_o <= `ALU_AND;
                default: illegal_instr_o <= 1'b1;
            endcase
        end ;
        `OP_IMM_OPCODE  : begin
            ex_op_a_sel_o <= 2'd0;
            ex_op_b_sel_o <= 3'd1;
            gpr_we_a_o    <= 1'b1;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
            case (funct3)
                3'b000 : alu_op_o <= `ALU_ADD;
                3'b010 : alu_op_o <= `ALU_SLT;
                3'b011 : alu_op_o <= `ALU_SLTU;
                3'b100 : alu_op_o <= `ALU_XOR;
                3'b110 : alu_op_o <= `ALU_OR;
                3'b111 : alu_op_o <= `ALU_AND;
                3'b001 : alu_op_o <= `ALU_SLL;
                3'b101 : case (funct7)
                            7'b0000000 : alu_op_o <= `ALU_SRL; 
                            7'b0100000 : alu_op_o <= `ALU_SRA;
                            default: illegal_instr_o <= 1'b1;
                        endcase 
                default: illegal_instr_o <= 1'b1;
            endcase
        end;
        `LOAD_OPCODE  : begin
            alu_op_o      <= `ALU_ADD;
            ex_op_a_sel_o <= 2'd0;
            ex_op_b_sel_o <= 3'd1;
            //mem_req_o     <= 1'b1; // разрешаем доступ к памяти
            mem_we_o      <= 1'b0; //читаем данные из памяти
            wb_src_sel_o  <= 1'b1; //записывем данные из памяти
            gpr_we_a_o    <= 1'b1; 
            ca se (funct3)
            //LB
                3'b000 : mem_size_o  <= `LDST_B;
            //LH
                3'b001 : mem_size_o  <= `LDST_H;
            //LW
                3'b010 : mem_size_o  <= `LDST_W;
            //LBU
                3'b100 : mem_size_o  <= `LDST_BU;
            //LHU
                3'b101 : mem_size_o  <= `LDST_HU;
                default: illegal_instr_o <= 1'b1;
            endcase
        end;
        `STORE_OPCODE  : begin
            alu_op_o      <= `ALU_ADD;
            ex_op_a_sel_o <= 2'd0;
            ex_op_b_sel_o <= 3'd3;
            mem_we_o      <= 1'b1;
            gpr_we_a_o    <= 1'b0;
            case (funct3)
                3'b000  : mem_size_o  <= `LDST_B;
                3'b001  : mem_size_o  <= `LDST_H;
                3'b010  : mem_size_o  <= `LDST_BW;
                default: illegal_instr_o <= 1'b1;
            endcase
        end;
        `BRANCH_OPCODE  : begin
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
            branch_o      <= 1'b1;
            case (funct3)
                //BEQ
                3'b000 : alu_op_o <= `ALU_EQ;
                //BNE
                3'b001 : alu_op_o <= `ALU_NE;
                //BLT
                3'b100 : alu_op_o <= `ALU_LTS;
                //BGE
                3'b101 : alu_op_o <= `ALU_GES;
                //BLTU
                3'b110 : alu_op_o <= `ALU_LTU;
                //BGEU
                3'b111 : alu_op_o <= `ALU_GEU;
                default: illegal_instr_o <= 1'b1;
            endcase 
        end;
        `JAL_OPCODE  : begin
            ex_op_a_sel_o <= 2'd1;
            ex_op_b_sel_o <= 3'd4;
            alu_op_o      <= `ALU_ADD;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
            jal_o         <= 1'b1;  
        end;
        `JALR_OPCODE  : 
            ex_op_a_sel_o <= 2'd1;
            ex_op_b_sel_o <= 3'd4;
            alu_op_o      <= `ALU_ADD;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
            jalr_o <= 1'b1;
        `LUI_OPCODE  : begin
            ex_op_a_sel_o <= 2'd2;
            ex_op_b_sel_o <= 3'd2;
            gpr_we_a_o    <= 1'b1;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
        end ;
        `AUIPC_OPCODE  : begin
            ex_op_a_sel_o <= 2'd1;
            ex_op_b_sel_o <= 3'd2;
            wb_src_sel_o  <= 1'b0; //записываем данные с алу
            gpr_we_a_o    <= 1'b1;
        end;
        `SYSTEM_OPCODE  : ;
        default: illegal_instr_o <= 1'b1;
    endcase
end


endmodule