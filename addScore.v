
module add_score(button, light, buttonPressed);

input button;
// input clk, reset;
output light; 
output [31:0] buttonPressed;

//lights up an LED when button is pressed
// and buttonPressed(light, button, 1'b1);

//when the button is pressed, we want to call the addi instruction (address = 8)
wire currentState;
reg buttonChange;
dffe_ref button_change(currentState, button, clk, 1'b1, clr);



 always @(negedge clk) begin
     //state going from high to low
     if ((currentState !== button) & (button == 1))
         buttonChange <= 1;
     else
         buttonChange <= 0;
 end


and sensed(light, button, 1'b1);

assign buttonPressed = button ? 32'd1 : 32'd0; 
endmodule