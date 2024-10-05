
module SYNC_FIFO_RX(wclk,rclk,wrst,rrst,wr_data,rd_data,wr_full,rd_empty,wr_en,rd_en,SLVSTRB,UART_LOAD_READY,PSEL_UART);

input wclk,rclk,wrst,rrst,wr_en,rd_en,PSEL_UART;
input[1:0] SLVSTRB;
input[31:0] wr_data;
output wr_full,rd_empty;
output reg UART_LOAD_READY;
output reg[31:0] rd_data;

reg[3:0] rptr,wptr;

reg[31:0] sync_fifo_rx[7:0];

always @(posedge wclk or posedge wrst) begin
	if (wrst) begin
		wptr<=0;
	end
	else if (~wr_full&wr_en) begin
		sync_fifo_rx[wptr]<=wr_data;
		wptr<=wptr+1;
	end
end

always @(posedge rclk or posedge rrst) begin
        
        UART_LOAD_READY<=0;

	if (rrst) begin
        rptr<=0;
        UART_LOAD_READY<=0;
	end
	else if(PSEL_UART) begin
	 if (~rd_empty&rd_en) begin

        case(SLVSTRB)
        2'b01: rd_data<={{24{1'b0}},sync_fifo_rx[rptr][7:0]};
        2'b10: rd_data<={{16{1'b0}},sync_fifo_rx[rptr][15:0]};
		default: rd_data<=sync_fifo_rx[rptr];
		endcase
		rptr<=rptr+1;
		UART_LOAD_READY<=1;
	end
	end
end

assign rd_empty = (wptr==rptr)?1:0;

assign wr_full = ({~wptr[3],wptr[2:0]}===rptr)?1:0;

endmodule