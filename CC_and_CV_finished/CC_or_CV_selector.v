module CC_or_CV_selector(clk,V_battery,PWM_to_buck,PWM_counter_from_CC,PWM_counter_from_CV,flag_CC);
//inout
input [11:0] V_battery;
input clk;
input [9:0]PWM_counter_from_CC;
input [9:0]PWM_counter_from_CV;
output reg [9:0] PWM_to_buck;
output reg flag_CC;

//parameter
parameter V_4=12'd1024;
always @(posedge clk )
begin
    if(V_battery<V_4)
    begin
     PWM_to_buck=PWM_counter_from_CC;
     flag_CC=1'b1;
    end
    else
    begin 
      PWM_to_buck=PWM_counter_from_CV;
      flag_CC=1'b0;
    end  
end
endmodule 
