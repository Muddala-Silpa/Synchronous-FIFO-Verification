module fifo_tb();
reg clk,rst,rd_en,wr_en;
reg [7:0]din;
wire empty,full;
reg [7:0]mem[16:0];
reg [4:0] wr_ptr,rd_ptr;
wire [7:0]dout;
integer i;

fifo dut(clk,rst,rd_en,wr_en,din,empty,full,dout);

initial
	clk=1'b0;
	always #5 clk=~clk;
	
task initialize;
begin
	{rst,rd_en,wr_en}=3'b100;
	din=8'b0;
end
endtask

task rst_dut;
begin
	@(negedge clk)
	rst=1'b1;
	@(negedge clk)
	rst=1'b0;
end
endtask

task wr_en0;
begin
	@(negedge clk)
	wr_en=1'b0;
end
endtask

task write(input x,input [7:0]y);
begin
	@(negedge clk)
	wr_en=x;
	din=y;
end
endtask

task read;
begin
	@(negedge clk)
	rd_en=1'b1;
end
endtask

initial
begin
	initialize;
	rst_dut;
	for(i=0;i<16;i=i+1)
	write(1'b1,{$random}%256);
	wr_en0;
	for(i=0;i<16;i=i+1)
	read;
	#500 $finish();
end

endmodule
	
