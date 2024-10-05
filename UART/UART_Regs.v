
module UART_Regs(
    
    input clk,rst,
    input[3:0] PADDR,
    input UART_READY,UART_LOAD_READY,store_finished,rd_empty_tx,tx_busy,data_valid,start_tx,rd_empty_rx,wr_full_tx,wr_full_rx,
    input wr_en_tx,wr_en_rx,rd_en_rx,
    output[31:0] OUT_REG

	);

    reg[1:0] uart_regs[31:0];

  always @(posedge clk or posedge rst) begin
  	if (rst) begin
         uart_regs[0]<=0;
         uart_regs[1]<=0;  		
  	end
  	else begin
  		uart_regs[0]<={UART_READY,UART_LOAD_READY,store_finished,rd_empty_tx,tx_busy,data_valid,start_tx,rd_empty_rx,wr_full_tx,wr_full_rx,
  			wr_en_tx,wr_en_rx,rd_en_rx};
  	end
  end

  assign OUT_REG =(PADDR==8)?uart_regs[0]:(PADDR==12)?uart_regs[1]:0;

  endmodule 