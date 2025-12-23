// Define the base address for the GPIO IP
localparam GPIO_BASE_ADDR = 32'h2000_0000;

// Internal signal to select the GPIO IP
wire gpio_sel;

// Address Decoder Logic: Select GPIO if the CPU address matches the base address
assign gpio_sel = (cpu_addr == GPIO_BASE_ADDR);

// Instantiate the Simple GPIO Output IP
gpio_output u_gpio_output (
    .clk      (clk),          // Connect to SoC System Clock
    .rst_n    (rst_n),        // Connect to SoC System Reset
    
    // Bus Interface
    .sel      (gpio_sel),     // Connect to the decoder signal created above
    .wr_en    (cpu_wr_en),    // Connect to CPU's Write Enable signal
    .wr_data  (cpu_wr_data),  // Connect to CPU's Write Data bus
    .rd_data  (gpio_rd_data), // Data sent back to CPU from GPIO
    
    // External Output
    .gpio_out (soc_gpio_pins) // Connect to top-level pins or internal wires
);

// Select which peripheral's data is sent to the CPU based on the address
always @(*) begin
    if (cpu_addr == GPIO_BASE_ADDR)
        cpu_rd_data = gpio_rd_data; // Read from your new IP
    else if (cpu_addr == UART_BASE_ADDR)
        cpu_rd_data = uart_rd_data; // Read from existing UART
    else
        cpu_rd_data = 32'h0;        // Default/Invalid
end
