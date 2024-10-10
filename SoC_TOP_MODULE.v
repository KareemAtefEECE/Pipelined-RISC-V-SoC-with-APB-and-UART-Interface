


module SoC_TOP_MODULE#(
    parameter WIDTH = 32    
)(
    input CLK,RESET,RX_IN,
    output TX_OUT
    );


wire[31:0] to_cpu_data,ADDR,WriteDataW,PADDR,PWDATA,PRDATA,UART_DATA,rd_data,UART_Regs_out;
wire[1:0] MemStrobeW,PSTRB;
wire Wr_En,transEn,opcode5,store_done,store_finished,Pstore_done,trans_done,PSEL,PENABLE,PWRITE,PREADY,LOAD_READY,PSEL_UART,UART_READY,UART_LOAD_READY,rd_empty;

RV32I rv(CLK,RESET,to_cpu_data,ADDR,WriteDataW,MemStrobeW,Wr_En,transEn,trans_done,store_done,store_finished);

APB_Master APB_Master(
     CLK,RESET,Wr_En,transEn,1,UART_LOAD_READY,store_done,
     MemStrobeW,
     ADDR,WriteDataW,PRDATA,
      to_cpu_data,
     PADDR,
     PSEL,PENABLE,PWRITE,trans_done,Pstore_done,
     PWDATA,
     PSTRB
    );

ADDRESS_DECODER ADDRESS_DECODER(
     PADDR,
     PSEL,PENABLE,
     PSEL_UART,PREADY
    );

UART #(.WIDTH(WIDTH)) UART(
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PSTRB(PSTRB),
    .PSEL_UART(PSEL_UART),
    .PWRITE(PWRITE),
    .Rd_en(transEn),
    .RX_IN(RX_IN), 
    .Pstore_done(Pstore_done),          
    .clk(CLK),                  
    .rst(RESET),                 
    .PRDATA(PRDATA),  
    .rd_empty_rx(rd_empty),
    .UART_READY(UART_READY),
    .store_finished(store_finished),
    .UART_LOAD_READY(UART_LOAD_READY),
    .TX_OUT(TX_OUT),
    .UART_Regs_out(UART_Regs_out)
    );

endmodule
