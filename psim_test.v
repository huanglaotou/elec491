module psim_test(clk,outclk);
input clk;
output outclk;
assign outclk=clk;
endmodule 

module psim_test_tb();
reg clk;
wire outclk;

psim_test psim_test_1st(.clk(clk),.outclk(outclk));
initial begin
    clk = 1'b1;
    forever #1 clk = ~clk; // generate a clock
  end
endmodule
