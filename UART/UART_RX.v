module UART_RX #(
    parameter WIDTH = 32    
)(
    input RX_IN,           // Serial input
    input clk,             // Clock signal
    input rst,             // Reset signal
    output reg [WIDTH-1:0] P_DATA,  // Parallel data output
    output reg data_valid  // Data valid signal
);

    reg [5:0] bit_counter;     // Counter to keep track of received bits
    reg [WIDTH-1:0] shift_reg; // Shift register to store received data
    reg receiving;             // Flag to indicate whether data is being received

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all internal signals
            bit_counter <= 0;
            shift_reg <= 0;
            receiving <= 0;
            P_DATA <= 0;
            data_valid <= 0;   // Reset data_valid on reset
        end else begin
            // Start receiving when RX_IN goes low (start bit)
            if (!receiving && RX_IN == 0) begin
                receiving <= 1;
                bit_counter <= 0;
                data_valid <= 0;   // Clear data_valid at start of new reception
            end else if (receiving) begin
                // Shift in the received bits
                shift_reg <= {RX_IN, shift_reg[WIDTH-1:1]};
                bit_counter <= bit_counter + 1;

                // When all bits are received, transfer the data and assert data_valid
                if (bit_counter == WIDTH) begin
                    P_DATA <= shift_reg;
                    receiving <= 0;  // Done receiving
                    data_valid <= 1; // Assert data_valid when full data is received
                end
            end else begin
                // Deassert data_valid after one clock cycle
                data_valid <= 0;
            end
        end
    end
endmodule
