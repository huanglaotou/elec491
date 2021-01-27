module Buck_iL_Loop_top (	clk,
						PWM,
                        PWM2,
                        Vout,
                        V_max_in,
                        V_min_in,
                        current_in,
                        current_ref,
                        V_battery	);
	
	// I/O definitions
    input wire  [15:0]  Vout;
	input wire 			clk;
     input  [11:0] V_max_in;
   input      [11:0] V_min_in;
   //CC mode Input
     input  [13:0] current_in;
   input      [13:0] current_ref;
   input    [11:0]   V_battery;
   //output defi
	output wire 			PWM;
    output wire          PWM2;
  wire      clk_1M_test;
  wire      clk_10M_test;
   wire          [11:0]  V_out_ave;
   wire       [9:0]     Time_on_from_CV;
   wire  [9:0]          Time_on_from_selector;
   wire   [9:0]         Time_on_from_CC;
   wire flag_CC;

  	 clock_divider clock_divider_1M(.clk_ref(clk),.reset(1'b0),.outclkQ(clk_1M_test),.times(8'd250));
     clock_divider clock_divider_10M(.clk_ref(clk),.reset(1'b0),.outclkQ(clk_10M_test),.times(8'd25));
     average_fliter average_fliter_Vout_CC(.clk_1M(clk_1M_test),.V_battery(Vout),.V_ave(V_out_ave),.Time_on(Time_on_from_CV),.V_max_in(V_max_in),.V_min_in(V_min_in));
     average_fliter_current average_fliter_current(.clk_1M(clk_1M_test),.current_in(current_in),.current_ref(current_ref),.Time_on_current(Time_on_from_CC));
     CC_or_CV_selector CC_or_CV_selector(.clk(clk),.V_battery(V_battery),.PWM_to_buck(Time_on_from_selector),.PWM_counter_from_CC(Time_on_from_CC),.PWM_counter_from_CV(Time_on_from_CV),.flag_CC(flag_CC));
     Buck_iL_Loop buck_control_bot(.clk(clk),
						.PWM(PWM),
                        .PWM2(PWM2),
                        .Time_on(Time_on_from_selector));
endmodule

