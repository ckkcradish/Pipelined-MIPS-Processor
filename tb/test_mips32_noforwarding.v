`timescale 1ns / 1ps
module test_mips32_noforwarding;
reg clk;
wire [31:0] R1_04,R2_04,R3_04,R4_04,R5_04,R7_04;
pipe_MIPS32_noforward uut (.clock(clk));
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
// Index 1 (Addr 4): beq $7,$0, 14
uut.IMemory_04[1] = 32'h10E0000E; // <-- Offset is now 14 (0xE)
// Index 2 (Addr 8): lw $2, 0($3)
uut.IMemory_04[2] = 32'h8C620000;
// Index 3 (Addr 12): NOP
uut.IMemory_04[3] = 32'b0;
// Index 4 (Addr 20): lw $4, 0($5)
uut.IMemory_04[4] = 32'h8CA40000;
// Index 5 (Addr 16): NOP
uut.IMemory_04[5] = 32'b0;
// Index 6 (Addr 24): NOP
uut.IMemory_04[6] = 32'b0;
// Index 7 (Addr 28): NOP
uut.IMemory_04[7] = 32'b0;
// Index 8 (Addr 32): mul $2,$2,$4
uut.IMemory_04[8] = 32'h00441018;
// Index 9 (Addr 36): NOP
uut.IMemory_04[9] = 32'b0;
// Index 10 (Addr 40): NOP
uut.IMemory_04[10] = 32'b0;
// Index 11 (Addr 44): NOP
uut.IMemory_04[11] = 32'b0;
// Index 12 (Addr 48): add $1,$1,$2
uut.IMemory_04[12] = 32'h00220820;
// Index 13 (Addr 52): subi $7,$7,#1
uut.IMemory_04[13] = 32'h24E70001;
// Index 14 (Addr 56): addi $3,$3,#4
uut.IMemory_04[14] = 32'h20630004;
// Index 15 (Addr 60): addi $5,$5,#4
uut.IMemory_04[15] = 32'h20A50004;
// Index 16 (Addr 64): j 1
uut.IMemory_04[16] = 32'h08000001;
// Index 17 (Addr 68): jr $31
uut.IMemory_04[17] = 32'h03E00008;
// r3=100, r5=200, r7=9, r31=0
uut.Regs_04[3] = 32'd100;
uut.Regs_04[5] = 32'd200;
uut.Regs_04[7] = 32'd9;
uut.Regs_04[31] = 32'd0;
uut.DMemory_04[25] = 32'd0; // M[100]
uut.DMemory_04[26] = 32'd1; // M[104]
uut.DMemory_04[27] = 32'd7; // M[108]
uut.DMemory_04[28] = 32'd5; // M[112]
uut.DMemory_04[29] = 32'd1; // M[116]
uut.DMemory_04[30] = 32'd5; // M[120]
uut.DMemory_04[31] = 32'd0; // M[124]
uut.DMemory_04[32] = 32'd0; // M[128]
uut.DMemory_04[33] = 32'd4; // M[132]
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
$dumpfile("test_mips32_noforwarding.vcd");
$dumpvars(0, test_mips32_noforwarding);
end
endmodule
