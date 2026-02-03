`timescale 1ns / 1ps
module test_MIPS32;
reg clk;
wire [31:0] R1_04,R2_04,R3_04,R4_04,R5_04,R7_04;
pipe_MIPS32 uut (.clock(clk));
assign R1_04 = uut.Regs_04[1];
assign R2_04 = uut.Regs_04[2];
assign R3_04 = uut.Regs_04[3];
assign R4_04 = uut.Regs_04[4];
assign R5_04 = uut.Regs_04[5];
assign R7_04 = uut.Regs_04[7];
initial begin
        clk = 0;
        forever #5 clk = ~clk;
end
integer k_04;
initial begin
uut.PC_04 = 0;
uut.IFIDIR_04=32'h00000000;
uut.IDEXIR_04=32'h00000000;
uut.EXMEMIR_04=32'h00000000;
uut.MEMWBIR_04=32'h00000000;
uut.Regs_04[0] = 32'd0;
for (k_04 = 1; k_04 < 32; k_04 = k_04 + 1)
uut.Regs_04[k_04] = 32'd0;
#1
// 0: add $1,$0,$0 => opcode=0, rs=0, rt=0, rd=1, funct=32 => 0x00208020
uut.IMemory_04[0] = 32'h00208020;
// 1: beq $7,$0, offset=8 => opcode=4, rs=7, rt=0, imm=7 => 0x10E00007
uut.IMemory_04[1] = 32'h10E00007;
// 2: lw $2, 0($3) => opcode=35=100011, rs=3, rt=2, imm=0 => 0x8C620000
uut.IMemory_04[2] = 32'h8C620000;
// 3: lw $4, 0($5) => 0x8CA40000
uut.IMemory_04[3] = 32'h8CA40000;
// 4: mul $2,$2,$4 => R-type: op=0, rs=2, rt=4, rd=2, funct=24 => 0x00441018
uut.IMemory_04[4] = 32'h00441018;
// 5: add $1,$1,$2 => R-type: op=0, rs=1, rt=2, rd=1, funct=32 => 0x00220820
uut.IMemory_04[5] = 32'h00220820;
// 6: subi $7,$7,#1 => opcode=9=001001, rs=7, rt=7, imm=1 => 0x24E70001
uut.IMemory_04[6] = 32'h24E70001;
// 7: addi $3,$3,#4 => opcode=8=001000, rs=3, rt=3, imm=4 => 0x20630004
uut.IMemory_04[7] = 32'h20630004;
// 8: addi $5,$5,#4 => 0x20A50004
uut.IMemory_04[8] = 32'h20A50004;
// 9: j loop => opcode=2=000010, target=1 => => 0x08000001
uut.IMemory_04[9] = 32'h08000001;
// 10: jr $31 => R-type: op=0, rs=31, rt=0, rd=0, funct=8 => 0x03E00008
uut.IMemory_04[10] = 32'h03E00008;
// r3=100, r5=200, r7=9, r31=0
uut.Regs_04[3] = 32'd100;
uut.Regs_04[5] = 32'd200;
uut.Regs_04[7] = 32'd9;
uut.Regs_04[31] = 32'd0;
// vector A
uut.DMemory_04[25] = 32'd0; // M[100]
uut.DMemory_04[26] = 32'd1; // M[104]
uut.DMemory_04[27] = 32'd7; // M[108]
uut.DMemory_04[28] = 32'd5; // M[112]
uut.DMemory_04[29] = 32'd1; // M[116]
uut.DMemory_04[30] = 32'd5; // M[120]
uut.DMemory_04[31] = 32'd0; // M[124]
uut.DMemory_04[32] = 32'd0; // M[128]
uut.DMemory_04[33] = 32'd4; // M[132]
// vector B
uut.DMemory_04[50] = 32'd4; // M[200]
uut.DMemory_04[51] = 32'd5; // M[204]
uut.DMemory_04[52] = 32'd1; // M[208]
uut.DMemory_04[53] = 32'd9; // M[212]
uut.DMemory_04[54] = 32'd5; // M[216]
uut.DMemory_04[55] = 32'd9; // M[220]
uut.DMemory_04[56] = 32'd4; // M[224]
uut.DMemory_04[57] = 32'd4; // M[228]
uut.DMemory_04[58] = 32'd8; // M[232]
#1999;
$finish;
end
initial begin
$dumpfile("test_MIPS32.vcd");
$dumpvars(0, test_MIPS32);
end
endmodule
