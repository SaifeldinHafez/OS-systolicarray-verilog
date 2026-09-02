`default_nettype none
module PE(
    input wire clk,
    input  wire rst_n,
    input wire signed [7:0] weight_in,
    input wire signed [7:0] activation_in,
    output reg signed [7:0] weight_out,
    output reg signed [7:0] activation_out,
    output wire signed [31:0] result
);

    reg signed [31:0] current_partial_sum;
    wire signed [31:0] new_partial_sum;

    assign new_partial_sum = current_partial_sum + (weight_in * activation_in);

    always @(posedge clk) begin
        if (~rst_n) begin
            current_partial_sum <= 0;
            weight_out <= 0;
            activation_out <= 0;
        end
        else begin 
            current_partial_sum <= new_partial_sum;
            weight_out <= weight_in;
            activation_out <= activation_in;
        end 
    end

    assign result = current_partial_sum;

endmodule

module array(
    input wire clk,
    input wire rst_n,

    input wire signed [7:0] weight_in_0,
    input wire signed [7:0] weight_in_1,

    input wire signed [7:0] activation_in_0,
    input wire signed [7:0] activation_in_1,
    
    output wire signed [31:0] result0,
    output wire signed [31:0] result1,
    output wire signed [31:0] result2,
    output wire signed [31:0] result3
);

    wire signed [7:0] pe0_r, pe0_d, pe1_r, pe1_d, pe2_r, pe2_d, pe3_r, pe3_d;

    PE pe0(
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(weight_in_0),
        .activation_in(activation_in_0),
        .weight_out(pe0_d),
        .activation_out(pe0_r),
        .result(result0)
    );

    PE pe1(
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(weight_in_1),
        .activation_in(pe0_r),
        .weight_out(pe1_d),
        .activation_out(pe1_r),
        .result(result1)
    );

    PE pe2(
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(pe0_d),
        .activation_in(activation_in_1),
        .weight_out(pe2_d),
        .activation_out(pe2_r),
        .result(result2)
    );

    PE pe3(
        .clk(clk),
        .rst_n(rst_n),
        .weight_in(pe1_d),
        .activation_in(pe2_r),
        .weight_out(pe3_d),
        .activation_out(pe3_r),
        .result(result3)
    );

endmodule

module array_tb;

    reg clk;
    reg rst_n;

    reg signed [7:0] weight_in_0;
    reg signed [7:0] weight_in_1;

    reg signed [7:0] activation_in_0;
    reg signed [7:0] activation_in_1;
    
    wire signed [31:0] result0;
    wire signed [31:0] result1;
    wire signed [31:0] result2;
    wire signed [31:0] result3;
    
    array u_array(
        .clk             	(clk              ),
        .rst_n           	(rst_n            ),
        .weight_in_0     	(weight_in_0      ),
        .weight_in_1     	(weight_in_1      ),
        .activation_in_0 	(activation_in_0  ),
        .activation_in_1 	(activation_in_1  ),
        .result0         	(result0          ),
        .result1         	(result1          ),
        .result2         	(result2          ),
        .result3         	(result3          )
    );
    
    parameter PERIOD = 20; 

    always #(PERIOD/2) clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;

        #20;
        rst_n = 1;

        weight_in_0     = 3; weight_in_1     = 0;
        activation_in_0 = 4; activation_in_1 = 0;

        #20;

        weight_in_0     = 8; weight_in_1     = 3;
        activation_in_0 = 4; activation_in_1 = 3;

        #20;

        weight_in_0     = 0; weight_in_1     = 6;
        activation_in_0 = 0; activation_in_1 = 9;

        #20;

        weight_in_0     = 0; weight_in_1     = 0;
        activation_in_0 = 0; activation_in_1 = 0;

        #200;
        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, array_tb);
    end

endmodule