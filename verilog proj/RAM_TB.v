module RAM_TB;
parameter ADDER_WIDTH=4;
parameter MEM_WIDTH = 16;
parameter MEM_DEPTH =8;

 [MEM_WIDTH-1:0]    wr_data;
 [ADDER_WIDTH-1:0]  addr;
                    clk,rst;
                    wren;
                    rden;
 [MEM_WIDTH-1:0]    rd_data;
 
 
 RAM  #(.ADDER_WIDTH(ADDER_WIDTH),.MEM_WIDTH(MEM_WIDTH),.MEM_DEPTH(MEM_DEPTH))DUT
 (
 
 .wr_data(wr_data),
 .addr (addr),
 .clk(clk),
 .rst(rst),
 .wren (wren),
 .rden(rden),
 .rd_data(rd_data)
 );


always #5 clk =~clk;
initial 
begin 
//initial values
clk = 1'b0  ;
rst = 1'b1  ;    // rst is deactivated
rden = 1'b0 ;
wren = 1'b0 ;

//Reset the design
#5
rst = 1'b0;    // rst is activated
#5
rst = 1'b1;    // rst is deactivated

//Register Write Operations
#10
wren = 1'b1;
rden = 1'b0 ;
addr = 3'b11;
wr_data = 16'b001011;

#10
wren = 1'b1;
rden = 1'b0 ;
addr = 3'b111;
wr_data = 16'b01;

#10
wren = 1'b1;
rden = 1'b0 ;
addr = 3'b001;
wr_data = 16'b11100;

//Register Read Operations
#10
wren = 1'b0 ;
rden = 1'b1 ;
addr = 3'b0011;
#10
 if(rd_data != 16'b001011)
   $display("READ Operation 1 IS Failed");
 else
   $display("READ Operation 1 IS Passed");
 

#10
wren = 1'b0 ;
rden = 1'b1 ;
addr = 3'b001;
#10
 if(rd_data != 16'b11100)
   $display("READ Operation 2 IS Failed");
 else
   $display("READ Operation 2 IS Passed");


#10
wren = 1'b0 ;
rden = 1'b1 ;
addr = 3'b111;
#10
 if(rd_data != 16'b1)
   $display("READ Operation 3 IS Failed");
 else
   $display("READ Operation 3 IS Passed");


#100

$stop ;



end



endmodule