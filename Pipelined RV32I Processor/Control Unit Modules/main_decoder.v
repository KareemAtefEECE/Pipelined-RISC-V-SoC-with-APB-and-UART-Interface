

// Main Decoder

module main_decoder(opcode,funct3,Branch,Jump,ResultSrc,MemWrite,ALUSrc,ImmSrc,MemStrobe,RegWrite,ALUOp,transEn,lui_en,store_done);

input[6:0] opcode;
input[2:0] funct3;
output reg Branch,Jump,MemWrite,ALUSrc,RegWrite,transEn,lui_en,store_done;
output reg[1:0] ResultSrc,ALUOp,MemStrobe;
output reg[2:0] ImmSrc;

// LB,SB -> MemStrobe=01
// LH,SH -> MemStrobe=10
// LW,SW -> MemStrobe=11

always @(*) begin
   
    MemStrobe = 0;
    transEn = 0;
    lui_en = 0;
    store_done = 0;
	case(opcode)
    7'b0000011:begin
        {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b1_000_1_0_01_0_00_0; // Load
        case(funct3)
        0: MemStrobe = 2'b01;
        1: MemStrobe = 2'b10;
        default: MemStrobe = 2'b11;
        endcase
        transEn = 1;
    end
    7'b0100011:begin
        {RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b0_001_1_1_xx_0_00_0; // Store
         case(funct3)
        0: MemStrobe = 2'b01;
        1: MemStrobe = 2'b10;
        default: MemStrobe = 2'b11;
        endcase
        transEn = 1;
        store_done = 1;
    end
    7'b0110011:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b1_xxx_0_0_00_0_10_0; //R-type
    7'b1100011:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b0_010_0_0_xx_1_01_0; //beq
    7'b0010011:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b1_000_1_0_00_0_10_0; //I-type alu
    7'b1101111:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 12'b1_011_x_0_10_0_xx_1; //jal
    7'b0110111:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump,lui_en} = 13'b1_100_1_0_00_0_11_0_1; //lui
    default:{RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,Jump} = 0;
    endcase
end

endmodule