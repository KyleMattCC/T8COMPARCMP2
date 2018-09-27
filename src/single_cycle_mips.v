//BUSTY BITS
//Calalan, Sherwin
//Chua, Kyle
//Cruz, Miguel
//Tirona, Paul
`timescale 1ns/1ps
module single_cycle_mips(clk, rst_n, inst_addr, inst, data_addr, data_in, data_out, data_wr);

input wire clk, rst_n;
output reg [31:0] inst_addr;				//Program Counter
input wire [31:0] inst;						//Instruction opcode in binary
output reg [31:0] data_addr, data_out;		//Memory address na paglalagyan ng data; Data na iwriwrite to memory
input wire [31:0] data_in;					//Data na irearead from memory
output reg data_wr;							//Write enable

reg jump;
reg [5:0] opcode;
reg [4:0] indexS;
reg [4:0] indexT;
reg [4:0] indexD;
reg [31:0] imm;
reg [31:0] temp = 32'd0;
reg [31:0] registers [31:0];
integer ctr;
  
initial begin
	inst_addr <= 32'd0;
	data_wr <= 1'b0;
	
	for(ctr=0; ctr<32; ctr++) begin
		registers[ctr] <= 32'd0;
	end
	
	jump = 1'b0;
end

always @ (negedge rst_n) begin	//Reset trigger
	inst_addr <= 32'd0;
	
	for(ctr=0; ctr<32; ctr++) begin
		registers[ctr] <= 32'd0;
	end
	
	data_wr <= 1'b0;
	jump <= 1'b0;
end

always @ (negedge clk) begin	//Increment program counter after every clock cycle
	if(jump == 1'b0) begin
		inst_addr <= inst_addr + 32'd4;
	end
end

always @ (inst_addr) begin 		//Execute when clock is postive edge
	data_wr <= 1'b0;
	#1 opcode[5:0] <= inst[31:26];
	#1 indexS[4:0] <= inst[25:21];
	#1 indexT[4:0] <= inst[20:16];
	#1 indexD[4:0] <= inst[15:11];
	#1 imm = {inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15], inst[15:0]};

	//ADDITION/SUBTRACTION/SLT
	if(opcode == 6'b000000) begin
		opcode = inst[5:0];
		jump <= 1'b0;
		//ADD
		if(opcode == 6'b100000) begin
			registers[indexD] = registers[indexS] + registers[indexT];	
		end
		
		//SUB
		else if(opcode == 6'b100010) begin
			registers[indexD] = registers[indexS] - registers[indexT];
		end
		
		//SLT
		else if(opcode == 6'b101010) begin
			if(registers[indexS] > registers[indexT]) begin							
				registers[indexD] = 32'd1;  //set rd to 32'd1
			end
		
			else begin		
				registers[indexD] = 32'd0; //set rd to 32'd0
			end
		end
	end
	
	//LW
	else if(opcode == 6'b100011) begin
		temp = registers[indexS] + imm;
		data_addr = temp;
		#1 registers[indexT] = data_in;
		jump <= 1'b0;	
	end
	
	//SW
	else if(opcode == 6'b101011) begin
		temp = registers[indexS] + imm;
		data_addr = temp;
		data_out = registers[indexT];	
		#2 data_wr <= 1'b1;
		jump = 1'b0;		
	end
	
	//BEQ
	else if(opcode == 6'b000100) begin	
		if(registers[indexS] == registers[indexT]) begin
			inst_addr <= inst_addr + imm*4 + 32'd4;
			jump <= 1'b1;
		end
		
		else begin
			jump <= 1'b0;
		end		
	end
	
	//BNE
	else if(opcode == 6'b000101) begin
		if(registers[indexS] != registers[indexT]) begin
			inst_addr <= inst_addr + imm*4 + 32'd4;
			jump <= 1'b1;
		end
		
		else begin
			jump <= 1'b0;
		end		
	end	
end

endmodule
