module lock_tb();


reg  button0_tb;
reg  button1_tb;
reg  rst_tb;
reg  clk_tb;
wire unlock_tb;

integer i ;
// design instantiation
lock DUT (
.clk(clk_tb),
.rst(rst_tb),
.button0(button0_tb),
.button1(button1_tb),
.unlock(unlock_tb)

);

always #5 clk_tb =~clk_tb;


initial 
begin
    initialize ();
    reset_assert  () ;

    button_push (5'b10100,5'b01011);

    wait (unlock_tb);
    $display("LOCKER IS UNLOCKED AT TIME %d", $time) ;
    $stop;

 
end



task reset_assert;

begin
#2;
rst_tb = 0 ;
#10 ;
rst_tb = 1 ;
end

endtask


task initialize;
begin
i =0 ;
button0_tb = 0 ;
button1_tb = 0;
clk_tb =0;
rst_tb = 1; 

end
endtask



task button_push ;
input reg [4:0] button0;
input reg [4:0] button1;

begin

for (i=0 ; i <5 ;i=i+1)
begin
    @(posedge clk_tb)
button0_tb = button0[i];
button1_tb = button1[i];
end




end











endtask

endmodule