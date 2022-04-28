module Seven_segment_LED_Display_Controller_Adder(
    input[31:0] registerValue,
    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input buttonPressed,
    
    output reg [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [15:0] displayed_number, displayed_time; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [2:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat         

    debounce_better_version debounce(buttonPressed, clock_100Mhz, button_deb);

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    
   
    always @(negedge button_deb or posedge reset)
    begin
        if(reset==1)
            displayed_number <= 0;
        
        else if (displayed_time !== 0)
            displayed_number <= displayed_number + 1;
    end

    always @(posedge clock_100Mhz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            displayed_time <= 30;
        

        else if(one_second_enable==1 & displayed_time !== 0)
            displayed_time <= displayed_time - 1;
    end
    assign LED_activating_counter = refresh_counter[19:17];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        3'b000: begin
            Anode_Activate = 8'b11110111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = displayed_number/1000;
            // the first digit of the 16-bit number
              end
        3'b001: begin
            Anode_Activate = 8'b11111011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_number % 1000)/100;
            // the second digit of the 16-bit number
              end
        3'b010: begin
            Anode_Activate = 8'b11111101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_number % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        3'b011: begin
            Anode_Activate = 8'b11111110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_number % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        3'b100: begin
            Anode_Activate = 8'b01111111;
            LED_BCD = displayed_time / 1000;
        end
        3'b101: begin
            Anode_Activate = 8'b10111111; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (displayed_time % 1000)/100;
            // the second digit of the 16-bit number
              end
        3'b110: begin
            Anode_Activate = 8'b11011111; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((displayed_time % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        3'b111: begin
            Anode_Activate = 8'b11101111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((displayed_time % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 7'b0000001; // "0"
        endcase
    end
 endmodule