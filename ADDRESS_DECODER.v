
module ADDRESS_DECODER(
    input[31:0] PADDR,PWDATA,UART_DATA,
    input[1:0] PSTRB,
    input PSEL,PENABLE,PWRITE,UART_READY,UART_LOAD_READY,Pstore_done,
    output[31:0] SLVADDR,SLVWDATA,PRDATA,
    output[1:0] SLVSTRB,
    output reg PSEL_UART,
    output SLVWRITE,PREADY,LOAD_READY,SLVstore_done
	);


    // Peripherals Adresses Range
    // Bridge Base Address : 0x2000
    // UART Offset Address : 0x0000
    // 2nd Peripheral Offset Address : 0x0200
    // 3nd Peripheral Offset Address : 0x0400
    // so on....

    always @(*) begin
          
          if(PADDR[31:16]==16'h2000) begin

           case(PADDR[11:8])

             // UART Range
             4'b0000: PSEL_UART = PSEL;

             //other peripherals...

             default: PSEL_UART = 0;
             endcase

             end

             else PSEL_UART = 0;

    end

assign {SLVADDR,SLVWDATA,PRDATA,SLVSTRB,SLVWRITE,PREADY,LOAD_READY,SLVstore_done} = PENABLE?{PADDR,PWDATA,UART_DATA,PSTRB,PWRITE,UART_READY,UART_LOAD_READY,Pstore_done}
                                                                       :{32'b0, 32'b0, 32'b0, 2'b0, 1'b0, 1'b0, 1'b0, 1'b0};                                                                     

    endmodule