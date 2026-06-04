module fifo(clk,rst,rd_en,wr_en,din,empty,full,dout);
parameter width=8,depth=16,addr_bus=5;
input clk,rst,rd_en,wr_en;
input[width-1:0]din;
output reg empty,full;
output reg [width-1:0]dout;
reg [width-1:0]mem[depth-1:0];
reg [addr_bus-1:0]wr_ptr,rd_ptr;
integer i;

always@(posedge clk)
begin
	if(rst)
	begin
		wr_ptr<=5'b0;
		for(i=0;i<16;i=i+1)
		mem[i]=8'b0;
	end
	else if(wr_en==1'b1 && full==1'b0)
	begin
		mem[wr_ptr[3:0]]<=din;
		wr_ptr<=wr_ptr+1;
	end
	else
	begin
		mem[wr_ptr[3:0]]<=mem[wr_ptr[3:0]];
		wr_ptr<=wr_ptr;
	end
end

always@(posedge clk)
begin
	if(rst)
	begin
		rd_ptr<=5'b0;
		dout<=8'b0;
	end
	else if(rd_en==1'b1 && empty==1'b0)
	begin
		dout<=mem[rd_ptr[3:0]];
		rd_ptr<=rd_ptr+1'b1;
	end
	else
	begin
		dout<=dout;
		rd_ptr<=rd_ptr;
	end

assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;

end
endmodule
