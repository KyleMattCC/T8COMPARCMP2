//BUSTY BITS
//Calalan, Sherwin
//Chua, Kyle
//Cruz, Miguel
//Tirona, Paul
`timescale 1ns/1ps
module datamem(clk, data_addr, data_wr, data_in, data_out);
input wire clk;
input wire [31:0] data_addr, data_out;
input wire data_wr;
output reg [31:0] data_in;
reg [7:0] memory [0:1023];

//Initialize data memory
initial begin 
	$readmemh("datamem.txt",memory);
end

//Read
always @ (data_addr) begin
	data_in[31:24] <= memory[data_addr];
	data_in[23:16] <= memory[data_addr+1];
	data_in[15:8] <= memory[data_addr+2];
	data_in[7:0] <= memory[data_addr+3];
end

//Write
always @ (posedge clk) begin
	if(data_wr == 1'b1) begin
		memory[data_addr] <= data_out[31:24];
		memory[data_addr+1] <= data_out[23:16];
		memory[data_addr+2] <= data_out[15:8];
		memory[data_addr+3] <= data_out[7:0];
	end
end
endmodule
		