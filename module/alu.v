`timescale 1ns / 1ns
module alu (
    alu_out,
    zero,
    data,
    accum,
    alu_ena,
    opcode,
);
    output [7:0] alu_out;
    output zero;
    input [7:0] data, accum;
    input [2:0] opcode;
    input alu_ena;

    reg [7:0] alu_out;

    parameter 
        HLT  = 3'b000, 
        SKZ  = 3'b001, 
        ADD  = 3'b010, 
        ANDD = 3'b011, 
        XORR = 3'b100, 
        LDA  = 3'b101,
        STO  = 3'b110, 
        JMP  = 3'b111;

    assign zero = !accum;

    always @(posedge alu_ena)
        if (alu_ena) begin  //操作码来自指令寄存器的输出opc_iaddr(15.0)的低3位

            casex (opcode)
                HLT:  alu_out <= accum;
                SKZ:  alu_out <= accum;
                ADD:  alu_out <= data + accum;
                ANDD: alu_out <= data & accum;
                XORR: alu_out <= data ^ accum;
                LDA:  alu_out <= data;
                STO:  alu_out <= accum;
                JMP:  alu_out <= accum;

                default: alu_out <= 8'bxxxx_xxxx;

            endcase
        end

endmodule
