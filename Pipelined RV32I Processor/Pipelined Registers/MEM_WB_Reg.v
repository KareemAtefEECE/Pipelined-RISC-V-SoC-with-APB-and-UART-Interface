
module MEM_WB_Reg(
	input clk,rst,RegWriteM,MemWriteM,transEnM,StallW,lui_enM,store_doneM,
	input[1:0] ResultSrcM,MemStrobeM,
	input[3:0] peripheral_load,
	input[4:0] RdM,
	input[31:0] ALUResultM,ReadDataM,PCPlus4M,WriteDataM,

	output reg RegWriteW,Wr_En,transEn,lui_enW,store_doneW,
	output reg[1:0] ResultSrcW,MemStrobeW,
	output reg[4:0] RdW,
	output reg[31:0] ALUResultW,ReadDataW,PCPlus4W,WriteDataW
	);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		RegWriteW<=0;
		Wr_En<=0;
		transEn<=0;
		ResultSrcW<=0;
		MemStrobeW<=0;
		lui_enW<=0;
		store_doneW<=0;
		RdW<=0;
		ALUResultW<=0;
		WriteDataW<=0;
		ReadDataW<=0;
		PCPlus4W<=0;
	end
	else if(StallW==0) begin
		RegWriteW<=RegWriteM;
		Wr_En<=MemWriteM;
		if(peripheral_load==2) transEn<=transEnM;
		else transEn<=0;
		ResultSrcW<=ResultSrcM;
		lui_enW<=lui_enM;
		store_doneW<=store_doneM;
		MemStrobeW<=MemStrobeM;
		RdW<=RdM;
		ALUResultW<=ALUResultM;
		WriteDataW<=WriteDataM;
		ReadDataW<=ReadDataM;
		PCPlus4W<=PCPlus4M;
	end
end

endmodule