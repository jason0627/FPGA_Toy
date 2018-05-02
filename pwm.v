`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module pwm(
	input clk,
	input rst,
	output pwmSignal_left,
	output pwmSignal_right,	
	output [7:0] ledOut,
	input [7:0] action
    );

reg [26:0] ctr_d, ctr_q;    
reg [1:0] direction;
reg [7:0] led_indicate;
reg pwmOut_left, pwmOut_right;

assign ledOut[7:0] = led_indicate[7:0];
assign pwmSignal_left = pwmOut_left;
assign pwmSignal_right = pwmOut_right;

localparam  IDLE = 8'b0011_0000,
			FORWARD = 8'b0011_0001,
			REVERSE = 8'b0011_0010,
			TURN_LEFT = 8'b0011_0011,
			TURN_RIGHT = 8'b0011_0100;

initial begin
	direction = IDLE;
end
		
always @(*) begin

	case(led_indicate)
	
	8'b0001_1000 : begin
		if (ctr_q[19:4]  < 16'd4687) begin
		pwmOut_right = 1'b1;
		pwmOut_left = 1'b1;
		end
		else begin
		pwmOut_right = 1'b0;	
		pwmOut_left = 1'b0;	
		end
		end
	
	8'b0000_0001 : begin
		if (ctr_q[19:4]  < 16'd3125) pwmOut_right = 1'b1;
		else pwmOut_right = 1'b0;
		if (ctr_q[19:4]  < 16'd6250) pwmOut_left = 1'b1;
		else pwmOut_left = 1'b0;
		end

	8'b1000_0000 : begin
		if (ctr_q[19:4]  < 16'd6250) pwmOut_right = 1'b1;
		else pwmOut_right = 1'b0;	
		if (ctr_q[19:4]  < 16'd3125) pwmOut_left = 1'b1;
		else pwmOut_left = 1'b0;		
		end		

	8'b0001_0000 : begin
		if (ctr_q[19:4]  < 16'd3125) begin
		pwmOut_right = 1'b1;
		pwmOut_left = 1'b1;
		end
		else begin
		pwmOut_right = 1'b0;	
		pwmOut_left = 1'b0;			
		end
		end		

	8'b0000_1000 : begin
		if (ctr_q[19:4]  < 16'd6250) begin
		pwmOut_left = 1'b1;
		pwmOut_right = 1'b1;
		end
		else begin
		pwmOut_left = 1'b0;		
		pwmOut_right = 1'b0;				
		end
		end		
		
	8'b0001_1000 : begin
		if (ctr_q[19:4]  < 16'd4687) begin
		pwmOut_right = 1'b1;
		pwmOut_left = 1'b1;
		end
		else begin
		pwmOut_right = 1'b0;		
		pwmOut_left = 1'b0;		
		end
		end	

	endcase

	case(action)
		IDLE : begin
		direction = IDLE;
		led_indicate = 8'b0001_1000;
		end
		
		FORWARD : begin
		direction = FORWARD;
		led_indicate = 8'b0000_0001;
		end
		
		REVERSE : begin
		direction = REVERSE;
		led_indicate = 8'b1000_0000;
		end
		
		TURN_LEFT : begin
		direction = TURN_LEFT;
		led_indicate = 8'b0001_0000;
		end
		
		TURN_RIGHT : begin
		direction = TURN_RIGHT;
		led_indicate = 8'b0000_1000;
		end
		
		default : begin
		direction = IDLE;
		led_indicate = 8'b0001_1000;		
		end
	endcase
	
end

/////////////////////////////////////////////////////
always @(ctr_q) begin
	ctr_d = ctr_q + 1;
end
always @(posedge clk) begin
	if (rst) ctr_q <= 25'b0;
	else ctr_q <= ctr_d;
end
/////////////////////////////////////////////////////
endmodule
