`timescale 1ns / 1ps

module ALUController (
    input logic [1:0] ALUOp, 
    input logic [6:0] Funct7,
    input logic [2:0] Funct3,
    output logic [3:0] Operation
);

// LEGENDAS:
// ALUOp 10 = R-Type (Usa Funct7)
// ALUOp 11 = I-Type (IGNORA Funct7, exceto shifts)

  assign Operation[0] = 
      ((ALUOp == 2'b10) && (Funct3 == 3'b110)) || // OR (R-Type)
      ((ALUOp == 2'b11) && (Funct3 == 3'b110)) || // ORI (I-Type - NOVO)
      ((ALUOp == 2'b01) && (Funct3 == 3'b101)) || // BGE
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) || // SRL
      ((ALUOp == 2'b11) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) || // SRLI (I-Type)
      ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) || // XOR
      ((ALUOp == 2'b11) && (Funct3 == 3'b100)) || // XORI (I-Type - NOVO, ignora F7)
      (ALUOp == 2'b11 && Funct3 == 3'b111) || // JAL (Se usarmos lógica de ADD aqui)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRA
      ((ALUOp == 2'b11) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000));  // SRAI

  assign Operation[1] = 
      (ALUOp == 2'b00) || // LW/SW (ADD)
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) || // ADD (R-Type)
      ((ALUOp == 2'b11) && (Funct3 == 3'b000)) || // ADDI (I-Type - NOVO - IGNORA Funct7)
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRA
      ((ALUOp == 2'b11) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRAI
      ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) || // XOR
      ((ALUOp == 2'b11) && (Funct3 == 3'b100)) || // XORI (I-Type)
      ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000));   // SUB

  assign Operation[2] = 
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) || // SRL
      ((ALUOp == 2'b11) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) || // SRLI
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRA
      ((ALUOp == 2'b11) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRAI
      ((ALUOp == 2'b10) && (Funct3 == 3'b001)) || // SLL
      ((ALUOp == 2'b11) && (Funct3 == 3'b001)) || // SLLI
      ((ALUOp == 2'b10) && (Funct3 == 3'b010)) || // SLT
      ((ALUOp == 2'b11) && (Funct3 == 3'b010)) || // SLTI (I-Type - NOVO)
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) || // BLT
      ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000));   // SUB

  assign Operation[3] = 
      (ALUOp == 2'b01 && Funct3 == 3'b000) || // BEQ
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 2'b01) && (Funct3 == 3'b101)) || // BGE
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) || // BLT
      ((ALUOp == 2'b10) && (Funct3 == 3'b010)) || // SLT
      ((ALUOp == 2'b11) && (Funct3 == 3'b010));   // SLTI (I-Type - NOVO)

endmodule
