module UART_TX #(
    parameter WIDTH = 32   
)(
    input  [WIDTH-1:0] P_DATA,  
    input  start_bit,            
    input  clk,                  
    input  rst,                  
    output reg tx_out,          
    output reg busy              
);
    
    reg [WIDTH-1:0] shift_reg;   // Shift register for serializing data
    reg [5:0] bit_counter;       // Counter to track number of bits sent (needs 6 bits to count 0 to 33)
    reg transmitting;            // Flag for tracking whether we are transmitting

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all the registers
            tx_out <= 1'b1;          // Idle state of UART is logic high
            busy <= 1'b0;            // Not busy during reset
            bit_counter <= 0;        // Reset the bit counter
            transmitting <= 1'b0;    // Transmission is not active
        end
        else if (!start_bit && !busy) begin
            // Start transmission on start_bit signal
            tx_out <= 1'b0;          // Send start bit (UART start bit is 0)
            shift_reg <= P_DATA;      // Load 32-bit parallel data into shift register
            busy <= 1'b1;            // Set busy flag
            transmitting <= 1'b1;    // Set transmission active
            bit_counter <= 0;        // Reset the bit counter
        end
        else if (transmitting) begin
            if (bit_counter < WIDTH) begin
                // Send data bits one by one
                tx_out <= shift_reg[0];   // Output the least significant bit
                shift_reg <= shift_reg >> 1; // Shift right for the next bit
                bit_counter <= bit_counter + 1;
            end
            else if (bit_counter == WIDTH) begin
                // Send end bit (stop bit)
                tx_out <= 1'b1;       // Stop bit is logic high in UART
                bit_counter <= bit_counter + 1;
            end
            else if (bit_counter > WIDTH) begin
                // Transmission complete
                busy <= 1'b0;         // Clear busy flag
                transmitting <= 1'b0; // End transmission
            end
        end
    end

endmodule
