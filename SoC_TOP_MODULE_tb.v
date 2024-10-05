
module SoC_TOP_MODULE_tb();

reg CLK,RESET,RX_IN;
wire TX_OUT;

SoC_TOP_MODULE DUT(CLK,RESET,RX_IN,TX_OUT);

initial begin
	CLK=0;
	forever
	#5 CLK = ~CLK;
end

initial $readmemh("inst_memory.mem",DUT.rv.Inst_Mem.inst_mem);
initial $readmemh("data_memory.mem",DUT.rv.DAT_MEM.data_mem);
initial $readmemh("reg_file_memory.mem",DUT.rv.RF.reg_file);
initial $readmemh("fifo_tx.mem",DUT.UART.fifo_tx.sync_fifo_tx);
initial $readmemh("fifo_rx.mem",DUT.UART.fifo_rx.sync_fifo_rx);



initial begin
	RESET=1;
	#10
	RESET=0;
  
    #1200
	$stop;
end

endmodule