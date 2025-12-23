module gpio_output (
    input  wire        clk,        // System Clock
    input  wire        rst_n,      // Active Low Reset
    
    // Simple CPU Bus Interface
    input  wire        sel,        // Chip Select (from Address Decoder)
    input  wire        wr_en,      // Write Enable
    input  wire [31:0] wr_data,    // Data from CPU
    output wire [31:0] rd_data,    // Data to CPU
    
    // External Output
    output wire [31:0] gpio_out    // Physical Output Pins
);

    // [cite: 17, 32] One 32-bit register storage
    reg [31:0] gpio_reg;

    // [cite: 33, 36] Write logic: Follows synchronous design principles
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_reg <= 32'h0000_0000; // Reset state
        end else if (sel && wr_en) begin
            gpio_reg <= wr_data;       // Update register with CPU data
        end
    end

    // [cite: 19, 35] Readback logic: Returns the last written value
    assign rd_data = (sel && !wr_en) ? gpio_reg : 32'h0000_0000;

    // [cite: 18] Driving the output signal
    assign gpio_out = gpio_reg;

endmodule
