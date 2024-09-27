module RAM#(parameter ADDER_WIDTH=4, MEM_DEPTH=8,MEM_WIDTH=16)
(
input wire [MEM_WIDTH-1:0] wr_data,
input wire [ADDER_WIDTH-1:0]  addr,
input wire        clk,rst,
input wire        wren,
input wire        rden,
output reg [MEM_WIDTH-1:0] rd_data

);

integer i ;
reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];
always @(posedge clk or posedge rst)
begin
if(rst)
begin
rd_data <= 0 ;
for (i= 0; i < MEM_DEPTH ; i =i+1) begin 
 mem[i] <= 0 ;
end 
end
else 
begin
if (wren && ! rden)
begin
mem[addr] <= wr_data ;
end 

else if (rden && ! wren)
begin
 rd_data <= mem[addr] ;
end
  
end 
end

end

endmodule