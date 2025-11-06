`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
  logic [ 3:0] Wr;

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

    assign offset = a[1:0];

  always_ff @(*) begin
    raddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    waddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    Datain = wd;
    Wr = 4'b0000;

    if (MemRead) begin
      case (Funct3)
        3'b000: begin //LB
            case(offset)
                2'b00: rd <= {{24{Dataout[7]}}, Dataout[7:0]};
                2'b01: rd <= {{24{Dataout[15]}}, Dataout[15:8]};
                2'b10: rd <= {{24{Dataout[23]}}, Dataout[23:16]};
                2'b11: rd <= {{24{Dataout[31]}}, Dataout[31:24]};
            endcase
        end

        3'b001: begin //LH
            case(offset[1])
                1'b0: rd <= {{16{Dataout[15]}}, Dataout[15:0]};
                1'b1: rd <= {{16{Dataout[31]}}, Dataout[31:16]};
            endcase
        end

        3'b010: begin //LW
            rd <= Dataout;
        end
        3'b100: begin //LBU
            case(offset)
                2'b00: rd <= {{24'b0}, Dataout[7:0]};
                2'b01: rd <= {{24'b0}, Dataout[15:8]};
                2'b10: rd <= {{24'b0}, Dataout[23:16]};
                2'b11: rd <= {{24'b0}, Dataout[31:24]};
            endcase
        end

        default: rd <= Dataout;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b000: begin //SB
          case(offset)
                2'b00: begin 
                  Wr <= 4'b0001;
                  rd <= {{24{Datain[7]}}, Datain[7:0]};
                end
                2'b01: begin
                  Wr <= 4'b0010;
                  rd <= {{24{Datain[15]}}, Datain[15:8]};
                end
                2'b10: begin 
                  Wr <= 4'b0100;
                  rd <= {{24{Datain[23]}}, Datain[23:16]};
                end 
                2'b11: begin
                  Wr <= 4'b1000;
                  rd <= {{24{Datain[31]}}, Datain[31:24]};
                end
          endcase

        end

        3'b001: begin //SH
          
           case(offset[1])
              1'b0: begin
                Wr <= 4'b0011;
                wd <= {{16{Datain[15]}}, Datain[15:0]} ;
              end
              1'b1: begin
                Wr <= 4'b1100;
                wd <= {{16{Datain[31]}}, Datain[31:16]};
              end 

          endcase
        end

        3'b010: begin  //SW
          Wr <= 4'b1111;
          Datain <= wd;
        end
        default: begin
          Wr <= 4'b1111;
          Datain <= wd;
        end
      endcase
    end
  end

endmodule
