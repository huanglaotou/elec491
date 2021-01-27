module average_fliter_current(clk_1M,current_in,current_ref,Time_on_current);
//I/O part
input clk_1M;
input [13:0]current_in;
input [13:0]current_ref;
output reg [9:0] Time_on_current=10'd115;
//
reg [4:0] state=5'b11;
reg [7:0] counter=8'b0;
reg [15:0] counter_waiting=16'b0;
//
reg [19:0] current_sum=16'b0;
reg [13:0] current_ave;
//parameter
parameter idle=5'b00;  
parameter record_current_out=5'b01;
parameter deter_change_PWM=5'b10;
parameter waiting=5'b11;  

always @(posedge clk_1M )
	begin
       case(state)
       waiting:                                          // we do not change the PWM until it get closed to the c
       begin
               counter_waiting=counter_waiting+1'b1;
              if(counter_waiting==15'd40)
                begin 
                 counter_waiting=8'b0;    
                state<=idle;
                end
                else 
                state<=waiting;
       end
       idle:                            //initial the data and skip the possible error data
            begin
                current_sum=16'b0;
                counter=counter+1'b1;
                if(counter==8'd3)
                begin 
                 counter=8'b0;    
                state<=record_current_out;
                end
                else 
                state<=idle;
            end
       record_current_out:
       begin
            current_sum=current_sum+current_in;
           counter=counter+1'b1;
                if(counter==8'd9)
                begin 
                 counter=8'b0;    
                state<=deter_change_PWM;
                end
                else 
                state<=record_current_out;
       end     
       deter_change_PWM:
       begin
            current_sum=current_sum+current_in;
            current_ave=current_sum/10;
            if(current_ave<current_ref)
              begin
                  Time_on_current=Time_on_current+1'b1;
              end
            if(current_ave>current_ref)  
              begin
                   Time_on_current=Time_on_current-1'b1;
              end
            if(current_ave==current_ref)  
              begin
                  Time_on_current=Time_on_current;
              end
       state<=idle;
       end
       default:state<=waiting;
       endcase
    end
endmodule   