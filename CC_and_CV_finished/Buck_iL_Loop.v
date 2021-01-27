module Buck_iL_Loop (	clk,
						PWM,
                        PWM2,
                        Time_on	);
	
	// I/O definitions
	input wire 			clk;
	output reg 			PWM;
    output reg          PWM2;
    input wire [9:0]    Time_on;           
	
	// Parameters
	//my paramater 
    reg  [9:0]           Time_on_record;
    reg  [9:0]           Time_off_record;
    wire [9:0]           T_on_test;
    assign T_on_test=9'd290;
	reg [4:0]state;
	reg [9:0]counter=10'b0001;
	parameter idle=5'b00;            // it is dead zone 2     for the top GANFET from off to on
    parameter turn_on=5'b01;
    parameter dead_zone=5'b10;      // dead zone 1
    parameter turn_off=5'b11;

	always @(posedge clk )
	begin
		case(state)
		idle: begin
          PWM=1'b0;
          PWM2=1'b0;
          Time_on_record=Time_on;
          Time_off_record=9'd500-Time_on_record-9'd30;
		  if(counter==(10'd15))
            begin
                PWM=1'b1;
                PWM2=1'b0;
                counter=7'b01;
                state<=turn_on;
            end
            else begin
                counter=counter+1'b1;
                state<=idle;
            end
		end
		 turn_on:
        begin
             PWM=1'b1;
             PWM2=1'b0;
            if(counter==Time_on_record)          //we should reduce the time  for the dead zones
            begin
                PWM=1'b0;
                PWM2=1'b0;
                counter=7'b01;
                state<=dead_zone;
            end
            else begin
                counter=counter+1'b1;
                state<=turn_on;
            end
        end 
         dead_zone:                                          // dead zone for turning off the top GANFET and turn on the middle GANFET
            begin 
        PWM=1'b0;
        PWM2=1'b0;
            if(counter==(7'd15))
            begin
                PWM=1'b0;
                PWM2=1'b1;
                  counter=7'b01;
                state<=turn_off;
            end
            else begin
                counter=counter+1'b1;
                state<=dead_zone;
            end
        end
		 turn_off:
        begin
             PWM=1'b0;
             PWM2=1'b1;
            if(counter==Time_off_record)          //we should reduce the time  for the dead zones
            begin
                PWM=1'b0;
                PWM2=1'b0;
                counter=7'b01;
                state<=idle;
            end
            else begin
                counter=counter+1'b1;
                state<=turn_off;
            end
        end 
		default:begin 
            state<=idle;
        end
		endcase 
	end
endmodule

