module lock 
(

input wire clk,rst,
input wire  button0,button1,
output reg   unlock
);


//the password is 01011
reg  [2:0] curr_state ,nxt_state;

localparam  [2:0]    idle = 3'b000,
                     s1   = 3'b001,
					 s11  = 3'b010,
					 s011 = 3'b011,
					 s1011= 3'b100;
					 

//state transition always block
always @(posedge clk or negedge rst)
begin 
if(!rst)
curr_state <= idle ;
else 
curr_state <= nxt_state;
end


//next state logic
always @(*) 
begin
case (curr_state)

idle : begin 
if(button0)
nxt_state = idle ;
else if(button1)
nxt_state = s1;
else 
nxt_state = idle ;
end

s1 : begin
if(button0)
nxt_state = idle ;
else if(button1)
nxt_state = s11;
else 
nxt_state = s1 ;
end

s11 :begin 
if(button0)
nxt_state = s011 ;
else if(button1)
nxt_state = idle;
else 
nxt_state = s11 ;
end

s011 : begin 
if(button0)
nxt_state = idle ;
else if(button1)
nxt_state = s1011;
else 
nxt_state = s011 ;

end

s1011 : begin
if(button0)
nxt_state = idle ;
else if(button1)
nxt_state = idle;
else 
nxt_state = s011 ;

end

default : nxt_state = idle ;
endcase
 
end


//output logic=


always @(*)
begin
case (curr_state)
idle : unlock = 0 ;
s1   : unlock = 0 ;
s11  : unlock = 0 ;
s011 : unlock = 0 ;
s1011 : begin
if(button0) 
unlock = 1 ;
else 
unlock = 0 ;  
end

default : unlock = 0;

endcase
end

endmodule