`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2024 18:35:58
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
    input clk,
    input sw,   //switch[0] to enabble the clock
    input btnC, //to reset
    input btnU, //for hour increment
    input btnR, // min increment
    output [6:0] seg,
    output [3:0] an,
    output [7:0] led //display seconds
    );
    
    wire [3:0] s1,s2,m1,m2,h1,h2;
    reg hrup, minup;
    
    wire btnCclr, btnUclr, btnRclr;
    reg btnCclr_prev, btnUclr_prev, btnRclr_prev; // to store previous values
    
    //instatntating the debounce
    
    debounce dbC (clk,btnC,btnCclr);
    debounce dbU (clk,btnU,btnUclr);    //Hour up
    debounce dbR (clk,btnR,btnRclr);    //min up
    
    sevenseg_driver seg7 (clk, 1'b0, h2,h1,m2,m1,an,seg); //h2,h1,m2,m1 four bits data input to seg module-> HH:MM 
    digital_clock clock(clk,sw,btnCclr,hrup,minup,s1,s2,m1,m2,h1,h2); //s1----h2 are outputs of this
    
    //for hrup and min up by pushbuttons
    always@(posedge clk)
    begin
    btnUclr_prev <= btnUclr;
    btnRclr_prev <= btnRclr;
    if (btnUclr_prev == 1'b0 && btnUclr ==1'b1)
        hrup<=1'b1;
     else hrup<=0;
    //hrup button is zero and clr button is high then hrup is pressed
    
    if (btnRclr_prev == 1'b0 && btnRclr ==1'b1)
        minup<=1'b1;
     else minup<=0;
    //minup button is zero and clr button is high then minup is pressed
    end
    
    assign led [7:0] = {s2,s1};
    
    
endmodule
