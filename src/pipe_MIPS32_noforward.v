`timescale 1ns / 1ps
module pipe_MIPS32_noforward(clock);
input clock;
  
  parameter LW_04    = 6'b100011, // 35
            SW_04    = 6'b101011, // 43
            BEQ_04   = 6'b000100, //  4
            ADDI_04  = 6'b001000, // 8
            SUBI_04  = 6'b001001, // 9
            J_04     = 6'b000010, //  2
            ALUop_04 = 6'b000000, // R-type
            no_op_04 = 32'b000000_00000_00000_00000_00000_000000;
  parameter 
            MUL_04   = 6'b011000, // 24
            ADD_04   = 6'b100000, // 32
            SUB_04   = 6'b100010, // 34
            JR_04    = 6'b001000; // 8 

  reg [31:0] PC_04;
  reg [31:0] Regs_04[0:31], IMemory_04[0:1023], DMemory_04[0:1023];
  reg [31:0] IFIDIR_04;
  reg [31:0] IDEXA_04, IDEXB_04, IDEXIR_04;
  reg [31:0] EXMEMIR_04, EXMEMALUOut_04, EXMEMB_04;
  reg [31:0] MEMWBIR_04, MEMWBValue_04;

  wire [4:0] IDEXrs_04, IDEXrt_04, EXMEMrd_04, MEMWBrd_04;
  wire [5:0] IDEXop_04, EXMEMop_04, MEMWBop_04;

  wire takebranch_04, takejump_04, takejr_04;
  wire [31:0] Ain_04, Bin_04;

  assign IDEXrs_04 = IDEXIR_04[25:21];
  assign IDEXrt_04 = IDEXIR_04[20:16];
  assign IDEXop_04 = IDEXIR_04[31:26];
  assign EXMEMrd_04 = EXMEMIR_04[15:11];
  assign EXMEMop_04 = EXMEMIR_04[31:26];
  assign MEMWBrd_04 = MEMWBIR_04[15:11];
  assign MEMWBop_04 = MEMWBIR_04[31:26];
  assign takebranch_04 = ((IFIDIR_04[31:26]==BEQ_04) &&
                       (Regs_04[IFIDIR_04[25:21]] == Regs_04[IFIDIR_04[20:16]]));
  assign takejump_04 = (IFIDIR_04[31:26]==J_04);
  assign takejr_04   = ((IFIDIR_04[5:0]==JR_04)&&(IFIDIR_04[31:26]==ALUop_04));
  assign Ain_04 = IDEXA_04;  
  assign Bin_04 = IDEXB_04;

  
  always @(posedge clock) begin
 
      if (takejump_04) begin
        IFIDIR_04 <= no_op_04;
        PC_04     <= ({6'b000000, IFIDIR_04[25:0]}<<2);
      end
      else if (takejr_04) begin
        IFIDIR_04 <= no_op_04;
        PC_04     <= Regs_04[31];
      end    
      else if (takebranch_04) begin
        IFIDIR_04 <= no_op_04;
        PC_04     <= PC_04 + 4 + ({{16{IFIDIR_04[15]}},IFIDIR_04[15:0]}<<2);
      end
      else begin
        IFIDIR_04 <= IMemory_04[PC_04>>2];
        PC_04     <= PC_04 + 4;
      end
      
      IDEXA_04 <= Regs_04[IFIDIR_04[25:21]];
      IDEXB_04 <= Regs_04[IFIDIR_04[20:16]];
      IDEXIR_04<= IFIDIR_04;

      if (IDEXop_04==LW_04 || IDEXop_04==SW_04) begin
        EXMEMALUOut_04 <= IDEXA_04 + {{16{IDEXIR_04[15]}}, IDEXIR_04[15:0]};
      end
      else if (IDEXop_04==ADDI_04) begin
        EXMEMALUOut_04 <= IDEXA_04 + {{16{IDEXIR_04[15]}}, IDEXIR_04[15:0]};
      end
      else if (IDEXop_04==SUBI_04) begin
        EXMEMALUOut_04 <= IDEXA_04 - {{16{IDEXIR_04[15]}}, IDEXIR_04[15:0]};
      end
      else if (IDEXop_04==ALUop_04) begin
        case(IDEXIR_04[5:0])
          ADD_04:
             EXMEMALUOut_04 <= Ain_04 + Bin_04;
          SUB_04:
             EXMEMALUOut_04 <= Ain_04 - Bin_04;
          MUL_04:
             EXMEMALUOut_04 <= Ain_04 * Bin_04;
          default: EXMEMALUOut_04 <= 32'hx;
        endcase
      end

      EXMEMIR_04 <= IDEXIR_04; 
      EXMEMB_04  <= IDEXB_04;

        

    if (EXMEMop_04==LW_04) begin
      MEMWBValue_04 <= DMemory_04[EXMEMALUOut_04>>2];
    end else if (EXMEMop_04==SW_04) begin
      DMemory_04[EXMEMALUOut_04>>2] <= EXMEMB_04;
    end else if ((EXMEMop_04==ALUop_04)||(EXMEMop_04==ADDI_04)||(EXMEMop_04==SUBI_04)) begin
      MEMWBValue_04 <= EXMEMALUOut_04;
    end 
    MEMWBIR_04 <= EXMEMIR_04;

    if (MEMWBop_04==LW_04) begin
      if (MEMWBIR_04[20:16]!=0) Regs_04[MEMWBIR_04[20:16]] <= MEMWBValue_04;
    end 
    else if (MEMWBop_04==ALUop_04) begin
      if (MEMWBrd_04!=0) Regs_04[MEMWBrd_04] <= MEMWBValue_04;
    end
    else if ((MEMWBop_04==ADDI_04)||(MEMWBop_04==SUBI_04)) begin
      if (MEMWBIR_04[20:16]!=0) Regs_04[MEMWBIR_04[20:16]] <= MEMWBValue_04;
    end
  end

endmodule
