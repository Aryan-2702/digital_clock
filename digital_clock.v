`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2024 19:03:14
// Design Name: 
// Module Name: digital_clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digital_clock(
    input clk,
    input en,
    input rst,
    input hrup,
    input minup,
    output [3:0] s1,//as can go from 0 to 9, so 4 bit array
    output [3:0] s2,
    output [3:0] m1,
    output [3:0] m2,
    output [3:0] h1,
    output [3:0] h2
    );
    //time display
    // h2 h1 : m2 m1
    
    reg[5:0] hour=0, min=0, sec=0; //as max we can go till 60 for mins or sec
    
    integer clkc=0;    //working principle as a state machine of this clock is that there is a integer counter
    localparam onesec=100_000_000; //1sec as its 100MHz clock
    
    
    
    always@(posedge clk)
    begin
    if(rst==1'b1)           //in every risisng edge of clock reset is checked, 
     {hour,min,sec}<=0;     //other wise machine checks minup or hourup to adjust the clock
                            //which is the part below of set clock
    
    //set clock
    else if (minup==1'b1) //minup button is pressed
    if(min==6'd59)
    min<=0;
    else min<=min+1'd1;
    
    else if (hrup==1'b1)
    if(hour==23)
    hour<=0;
    else hour<=hour+1'd1;
     
    //count---------clock operation-------------------------------------------------------
    else if(en==1'b1)
        if(clkc==onesec) //gets to 1sec
            begin
             clkc<=0;
                if(sec==6'd59)
                  begin
                     sec<=0;
                        if (min==6'd59)
                          begin min<=0;
                             if (hour==6'd23)
                                 hour<=0;
                             else
                                hour<=hour+1'd1;
                         end  
                       else
                         min<=min+1'd1;
                  end
                else
                  sec<=sec+1'd1;
             end 
        else    
          clkc<=clkc+1; //clkc keeps on incrementing by one unti it eaches value of 'onsec'
    end
    
    //instantiating the binarytoBCD mudle to convert the nmbers and display on seven segment
    binarytoBCD secs(.binary(sec), .thos(), .huns(), .tens(s2), .ones(s1));
    binarytoBCD mins(.binary(min), .thos(), .huns(), .tens(m2), .ones(m1));
    binarytoBCD hours(.binary(hour), .thos(), .huns(), .tens(h2), .ones(h1));
    
endmodule
