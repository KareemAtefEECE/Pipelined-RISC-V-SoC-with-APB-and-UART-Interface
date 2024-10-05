
module EX_MEM_Reg(
	input clk,rst,RegWriteE,MemWriteE,transEnE,StallM,lui_enE,store_doneE,
	input[1:0] ResultSrcE,MemStrobeE,
	input[31:0] ALUResultE,WriteDataE,
	input[4:0] RdE,
	input[31:0] PCPlus4E,

	output reg RegWriteM,MemWriteM,transEnM,lui_enM,store_doneM,
	output reg[1:0] ResultSrcM,MemStrobeM,
	output reg[31:0] ALUResultM,WriteDataM,PCPlus4M,
	output reg[4:0] RdM
	);


always @(posedge clk or posedge rst) begin
	if (rst) begin
		RegWriteM<=0;
		MemWriteM<=0;
		transEnM<=0;
		ResultSrcM<=0;
		MemStrobeM<=0;
		ALUResultM<=0;
		lui_enM<=0;
		store_doneM<=0;
		WriteDataM<=0;
		RdM<=0;
		PCPlus4M<=0;
	end
	else if(StallM==0) begin
		RegWriteM<=RegWriteE;
		MemWriteM<=MemWriteE;
		transEnM<=transEnE;
		lui_enM<=lui_enE;
		store_doneM<=store_doneE;
		ResultSrcM<=ResultSrcE;
		MemStrobeM<=MemStrobeE;
		ALUResultM<=ALUResultE;
		WriteDataM<=WriteDataE;
		RdM<=RdE;
		PCPlus4M<=PCPlus4E;
	end
end

endmodule