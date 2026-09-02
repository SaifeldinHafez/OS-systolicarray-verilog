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