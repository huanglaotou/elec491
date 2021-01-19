module average_fliter(clk_1M,V_battery,V_ave,Time_on,V_max_in,V_min_in);
//inout
input [11:0] V_battery;
input clk_1M;
input [11:0] V_max_in;
input [11:0] V_min_in;
output reg [11:0] V_ave;
output reg [9:0]  Time_on=10'd450;
//
reg [4:0] state=5'b11;
reg [7:0] counter=8'b0;
reg [15:0] counter_waiting=16'b0;
reg [7:0] counter_check=8'b0;

reg [19:0]V_sum=16'b0;
wire [11:0]V_max;
wire [11:0]V_min;
assign V_max=V_max_in;
assign V_min=V_min_in;
//parameter
parameter idle=5'b00;  
parameter record_Vout=5'b01;
parameter deter_change_PWM=5'b10;
parameter waiting=5'b11;                   //the goal of the this state is at beginning we do not take the sample from the ADC until the output voltage get closed to the range
parameter check_correct=5'b111;
always @(posedge clk_1M )
	begin
       case(state)
       waiting:                                          // we do not change the PWM until it get closed to the c
       begin
               counter_waiting=counter_waiting+1'b1;
              if(counter_waiting==15'd250)
                begin 
                 counter_waiting=8'b0;    
                state<=idle;
                end
                else 
                state<=waiting;
       end
       idle:                            //initial the data and skip the possible error data
            begin
                V_sum=16'b0;
                counter=counter+1'b1;
                if(counter==8'd1)
                begin 
                 counter=8'b0;    
                state<=record_Vout;
                end
                else 
                state<=idle;
            end
       record_Vout:
       begin
            V_sum=V_sum+V_battery;
           counter=counter+1'b1;
                if(counter==8'd4)
                begin 
                 counter=8'b0;    
                state<=deter_change_PWM;
                end
                else 
                state<=record_Vout;
       end     
       deter_change_PWM:
       begin
            V_sum=V_sum+V_battery;
            V_ave=V_sum/5;
            if(V_ave<V_min)                 //2.35
            begin
                 Time_on=Time_on+1'b1;
            end
            else if(V_ave>V_max)            //2.55
            begin 
                   Time_on=Time_on-1'b1;
            end
            else if(((V_ave>V_min) && (V_ave<V_max)) || (V_ave==V_max) || (V_ave==V_min))
            begin
                 Time_on=Time_on;
            end
            if(Time_on>10'd460)
            begin
                 Time_on=10'd460;
            end
            state<=idle;
          /*  if(((V_ave>V_min) && (V_ave<V_max)) || (V_ave==V_max) || (V_ave==V_min))
            begin
                 state<=check_correct;
            end*/
       end
        /*check_correct:
        begin
             counter_check=counter_check+1'b1;
                if(counter_check==8'd15)
                begin 
                 counter_check=8'b0;    
                state<=idle;
                end
                else 
                state<=check_correct;
        end    */
       default:state<=idle;
       endcase
    end
endmodule 