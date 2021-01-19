module Buck_iL_Loop_top (	clk,
						PWM,
                        PWM2,
                        Vout,
                        V_max_in,
                        V_min_in	);
	
	// I/O definitions
    input wire  [15:0]  Vout;
	input wire 			clk;
	output wire 			PWM;
    output wire          PWM2;
  wire      clk_1M_test;
   wire          [11:0]  V_battery_ave;
   wire       [9:0]     Time_on;
   input  [11:0] V_max_in;
   input      [11:0] V_min_in;  
  	 clock_divider clock_divider_1M(.clk_ref(clk),.reset(1'b0),.outclkQ(clk_1M_test),.times(8'd250));
     average_fliter average_fliter_Vout(.clk_1M(clk_1M_test),.V_battery(Vout),.V_ave(V_battery_ave),.Time_on(Time_on),.V_max_in(V_max_in),.V_min_in(V_min_in));
     Buck_iL_Loop buck_control_bot(.clk(clk),
						.PWM(PWM),
                        .PWM2(PWM2),
                        .Time_on(Time_on));
endmodule

