
module ADDRESS_DECODER(
    input[31:0] PADDR,
    input PSEL,PENABLE,
    output reg PSEL_UART,
    output PREADY
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

  assign PREADY = 1;
                                                                                                                                            

    endmodule
