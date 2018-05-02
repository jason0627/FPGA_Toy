module mojo_top(
    input clk,              	// 50MHz clock input
    input rst_n,			// Input from reset button (active low)
    input cclk,			// cclk input from AVR, high when AVR is ready
    output[7:0]led,			// Outputs to the 8 onboard LEDs
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    
    input button,
    input uart_rx,
    output uart_tx,
	output pwm_motor_left,
	output pwm_motor_right
    );
wire [7:0] uart_data;
wire rst = ~rst_n; // make reset active high
reg [7:0] motor;
reg new_data;
// reg [7:0] uart_data_d, uart_data_q;

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

serial_tx my_serial_tx (
	.clk(clk),
	.rst(rst),
	.tx(uart_tx),
	.data(8'b0010_1110),    // 0x2E == . 출력
	.send(~button)
);

serial_rx my_serial_rx (
	.clk(clk),
	.rst(rst),
	.rx(uart_rx),
	.data(uart_data),
	.new_data(uart_new)
);

pwm my_pwm (
	.clk(clk),
	.rst(rst),
	.pwmSignal_left(pwm_motor_left),
	.pwmSignal_right(pwm_motor_right),	
	.ledOut(led),
	.action(motor)
);

always @(*) begin
	if(uart_new) motor = uart_data;
end

endmodule
