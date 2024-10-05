
module SYNC_FIFO_TX(wclk,rclk,wrst,rrst,SLVDATA,SLVADDR,TX_IN_DATA,wr_full,rd_empty,SLVWRITE,SLVSTRB,tx_busy,start_tx,UART_READY,PSEL_UART,SLVstore_done,store_finished);

input wclk,rclk,wrst,rrst,SLVWRITE,PSEL_UART,tx_busy,SLVstore_done;
input[1:0] SLVSTRB;
input[31:0] SLVDATA,SLVADDR;
output wr_full,rd_empty,store_finished;
output reg UART_READY,start_tx;
output reg[31:0] TX_IN_DATA;

reg[3:0] rptr,wptr;

reg[31:0] sync_fifo_tx[7:0];

always @(posedge wclk or posedge wrst) begin

    UART_READY<=0;
    start_tx<=1;

	if (wrst) begin
		wptr<=0;
		UART_READY<=0;
		start_tx<=1;
	end
	else if (~wr_full&SLVWRITE&PSEL_UART&(SLVADDR[3:0]==4)) begin

	    case(SLVSTRB)
	    2'b01: sync_fifo_tx[wptr]<={{24{1'b0}},SLVDATA[7:0]};
	    2'b10: sync_fifo_tx[wptr]<={{16{1'b0}},SLVDATA[15:0]};
		default: sync_fifo_tx[wptr]<=SLVDATA;
		endcase
		wptr<=wptr+1;
		UART_READY<=1;

	end
end

always @(posedge rclk or posedge rrst) begin
       
       start_tx<=1;
	if (rrst) begin
        rptr<=0;
        start_tx<=1;
	end
	else if (~tx_busy&~rd_empty) begin
           TX_IN_DATA<=sync_fifo_tx[rptr];
		   rptr<=rptr+1;
		   start_tx<=0;
	end
	end


assign rd_empty = (wptr==rptr)?1:0;

assign wr_full = ({~wptr[3],wptr[2:0]}===rptr)?1:0;

assign store_finished = SLVstore_done?1:0;

endmodule