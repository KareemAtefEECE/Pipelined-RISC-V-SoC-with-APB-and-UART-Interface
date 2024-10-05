
// Hazard Unit

module hazard_unit(Rs1E,Rs2E,Rs1D,Rs2D,RdE,RdM,RdW,RegWriteM,RegWriteW,ResultSrc0,PCSrcE,peripheral_load,store_done,store_finished,trans_done,transEn,opcode5,FlushE,FlushD,StallD,StallF,StallM,StallE,StallW,ForwardAE,ForwardBE);

input[4:0] Rs1E,Rs2E,Rs1D,Rs2D,RdE,RdM,RdW;
input[3:0] peripheral_load;
input RegWriteM,RegWriteW,ResultSrc0,PCSrcE,trans_done,transEn,opcode5,store_done,store_finished;
output reg[1:0] ForwardAE,ForwardBE;
output reg FlushE,FlushD,StallD,StallF,StallM,StallE,StallW;
reg lwStall;

always @(*) begin
	//Data Forwarding From Memory Stage
	if((Rs1E==RdM) && RegWriteM && (Rs1E!=0)) ForwardAE=2'b10;

	//Data Forwarding From WB Stage
	else if((Rs1E==RdW) && RegWriteW && (Rs1E!=0)) ForwardAE=2'b01;

	else ForwardAE=2'b00;

	//Data Forwarding From Memory Stage
	if((Rs2E==RdM) && RegWriteM && (Rs2E!=0)) ForwardBE=2'b10;

	//Data Forwarding From WB Stage
	else if((Rs2E==RdW) && RegWriteW && (Rs2E!=0)) ForwardBE=2'b01;

	else ForwardBE=2'b00;

    // Stalling in lw instruction
	lwStall = ((Rs1D==RdE)||(Rs2D==RdE)) && ResultSrc0;

    {FlushE,FlushD,StallD,StallF} = {lwStall|PCSrcE,
    	                             PCSrcE,
    	                            lwStall|(~trans_done&(peripheral_load===2)&(~opcode5|(store_done&~store_finished))&transEn),
    	                            lwStall|(~trans_done&(peripheral_load===2)&(~opcode5|(store_done&~store_finished))&transEn)};

    {StallE,StallM,StallW} = {(~trans_done&(peripheral_load===2)&(~opcode5|(store_done&~store_finished))&transEn),(~trans_done&(peripheral_load===2)&(~opcode5|(store_done&~store_finished))&transEn),(~trans_done&(peripheral_load===2)&(~opcode5|(store_done&~store_finished))&transEn)};
end

endmodule