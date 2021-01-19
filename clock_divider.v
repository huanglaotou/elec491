module clock_divider(clk_ref,reset,outclkQ,times);           //
input [7:0] times;
input clk_ref;//clk_50M
input reset; //reset bot
output reg outclkQ=1;   //output singnal
reg[7:0]counter=8'd1;  //for the initial condition
reg flag=1;
reg auto_reset=0;
always@(posedge clk_ref )
begin          //begin for the always
  if(reset)                            // the reset bot
  begin
      counter=8'd1;
        auto_reset=0;
outclkQ=1'b0;
   end


else begin
     if (counter<times)begin                       
              counter=counter+8'd1;
       end
      else if(counter==times) begin
              outclkQ=~outclkQ;
             counter=8'd1;
            end
       end
end             //end for the always

              //begin for the always
endmodule     
        
