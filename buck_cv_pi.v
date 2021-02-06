module buck_cv_pi(clk_sample,Vout_from_buck,Time_on);
// i/O
input clk_sample;
input [15:0] Vout_from_buck;
output reg [9:0] Time_on=10'd200;
// register
reg [40:0] Vout_before_divider;        // the number we get is after divider(/2) ,so we need to recover it;
reg [15:0] ref_voltage=16'd5000;   // this is mV
reg [40:0] V_error=0;             //voltage error between ref and input voltage
reg [40:0] V_desire=0;             //desire voltage from PI                         v_desire/V_err=PI
reg [40:0] V_error_p=0;              //the last error voltage
reg [40:0] V_desire_p=0;             // the last desire voltage
// parameter( i will do this later)
always@(posedge clk_sample)
begin
    Vout_before_divider=Vout_from_buck*2;
    V_error=ref_voltage-Vout_before_divider; //take the error
    V_desire=8000*V_error-8000*V_error_p+20*V_desire_p+(750000*(V_error+V_error_p))/1000000;  //pi control calculate    2*V_desire-2*V_desire[n-1]=10*Verror-10*Verror[n-1]+75000*10^-6*(Verror+Verror[n-1])
    V_desire=V_desire/20;
    V_error_p=V_error;
    V_desire_p=V_desire;
    Time_on=(V_desire*500)/12000;         //PWM=(V_desire/V_in(which is 12000 mV))*500
end
endmodule

