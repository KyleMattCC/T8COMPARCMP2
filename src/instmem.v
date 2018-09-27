//BUSTY BITS
//Calalan, Sherwin
//Chua, Kyle
//Cruz, Miguel
//Tirona, Paul
`timescale 1ns/1ps
module instmem(inst_addr, inst);
input wire [31:0] inst_addr;
output reg [31:0] inst;
reg [7:0] instructions [0:1023];

//Initialize instruction memory
initial begin 
	$readmemh("source1.byte",instructions);
end

//Get instruction
always @ (inst_addr) begin
	inst[31:24] <= instructions[inst_addr];
	inst[23:16] <= instructions[inst_addr+1];
	inst[15:8] <= instructions[inst_addr+2];
	inst[7:0] <= instructions[inst_addr+3];
end
endmodule