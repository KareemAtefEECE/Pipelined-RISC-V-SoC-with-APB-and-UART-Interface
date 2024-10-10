module UART #(
    parameter WIDTH = 32    
)(

    input[WIDTH-1:0] PADDR,PWDATA,
    input[1:0] PSTRB,
    input PSEL_UART,PWRITE,Rd_en,RX_IN,Pstore_done,          
    input  clk,                  
    input  rst,                 
    output [WIDTH-1:0] PRDATA,  
    output rd_empty_rx,

    output  UART_READY,store_finished,
    output UART_LOAD_READY,
    output TX_OUT,
    output[31:0] UART_Regs_out      
);

    wire tx_busy,data_valid,start_tx,rd_empty_tx;         
    wire wr_full_tx,wr_full_rx;   
    wire [WIDTH-1:0] P_DATA_RX,TX_IN_DATA;   
    reg wr_en_reg_rx,wr_en_reg_tx;    
    reg rd_en_reg;                // Registered rd_en signal to handle read enable logic  
          
    reg data_valid_d,pwrite_d,pwrite_d2; 
    reg Rd_en_prev;            // Previous state of PWRITE (for edge detection)
     



   always @(posedge clk or posedge rst) begin
    if (rst) begin
        pwrite_d <= 1'b0;
        wr_en_reg_tx <= 1'b0;
        pwrite_d2 <= 1'b0;
    end else begin
        pwrite_d <= PWRITE;  // Store the previous state of PWRITE
        pwrite_d2 <= pwrite_d;
        // Detect positive edge of PWRITE (0 -> 1 transition)
        if (pwrite_d && !pwrite_d2)
            wr_en_reg_tx <= 1'b1;
        else
            wr_en_reg_tx <= 1'b0;  // Deassert after one clock cycle
    end
end


   SYNC_FIFO_TX fifo_tx (
        .wclk(clk),
        .rclk(clk),
        .wrst(rst),
        .rrst(rst),
        .SLVDATA(PWDATA),
        .SLVADDR(PADDR),
        .TX_IN_DATA(TX_IN_DATA),   
        .wr_full(wr_full_tx),  
        .rd_empty(rd_empty_tx),  
        .SLVWRITE(wr_en_reg_tx^pwrite_d),
        .SLVSTRB(PSTRB),
        .tx_busy(tx_busy),
        .start_tx(start_tx),
        .UART_READY(UART_READY),
        .PSEL_UART(PSEL_UART),
        .SLVstore_done(Pstore_done),
        .store_finished(store_finished)
    );


    UART_TX #(.WIDTH(WIDTH)) tx (
        .P_DATA(TX_IN_DATA),         
        .start_bit(start_tx),        
        .clk(clk),                   
        .rst(rst),                   
        .tx_out(TX_OUT),            
        .busy(tx_busy)               
    );


    SYNC_FIFO_RX fifo_rx (
        .wclk(clk),
        .rclk(clk),
        .wrst(rst),
        .rrst(rst),
        .wr_data(P_DATA_RX),   
        .rd_data(PRDATA),     
        .wr_full(wr_full_rx),     
        .rd_empty(rd_empty_rx),   
        .wr_en(wr_en_reg_rx),     
        .rd_en(Rd_en),         
        .SLVSTRB(PSTRB),
        .UART_LOAD_READY(UART_LOAD_READY),
        .PSEL_UART(PSEL_UART)
    );



    UART_RX #(.WIDTH(WIDTH)) rx (
        .RX_IN(TX_OUT),               
        .clk(clk),                   
        .rst(rst),
        .data_valid(data_valid),    // Data valid when RX receives data                
        .P_DATA(P_DATA_RX)          
    );

    // Generate wr_en write to FIFO_RX when data is valid and no write is ongoing
    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            wr_en_reg_rx <= 0;
            data_valid_d <= 0;
        end else begin
            data_valid_d <= data_valid;  // Delay data_valid by one cycle to ensure data is captured
            if (data_valid && ~data_valid_d && ~wr_full_rx) begin
                wr_en_reg_rx <= 1;  // Assert wr_en when new data is received and FIFO is not full
            end else begin
                wr_en_reg_rx <= 0;  // Deassert wr_en after writing
            end
        end

    end


     UART_Regs reg_file(
         .clk(clk),
         .rst(rst),
         .PADDR(PADDR[3:0]),
         .UART_READY(UART_READY),
         .UART_LOAD_READY(UART_LOAD_READY),
         .store_finished(store_finished),
         .rd_empty_tx(rd_empty_tx),
         .tx_busy(tx_busy),
         .data_valid(data_valid),
         .start_tx(start_tx),
         .rd_empty_rx(rd_empty_rx),
         .wr_full_tx(wr_full_tx),
         .wr_full_rx(wr_full_rx),
         .wr_en_tx(wr_en_reg_tx),
         .wr_en_rx(wr_en_reg_rx),
         .OUT_REG(UART_Regs_out)
        );

endmodule
