`include "module/clk_gen.v"
`include "module/accum.v"
`include "module/adr.v"
`include "module/alu.v"
`include "module/machine.v"
`include "module/counter.v"
`include "module/machinectl.v"
`include "module/register.v"
`include "module/datactl.v"

`timescale 1ns / 1ns
module cpu (
    clk,
    reset,
    halt,
    rd,
    wr,
    addr,
    data,
    opcode,
    fetch,
    ir_addr,
    pc_addr
);

    input clk, reset;
    output rd, wr, halt;
    output [12:0] addr;
    output [2:0] opcode;
    output fetch;
    output [12:0] ir_addr, pc_addr;
    inout [7:0] data;

    wire clk, reset, halt;
    wire [ 7:0] data;
    wire [12:0] addr;
    wire rd, wr;
    wire clk1, fetch, alu_ena;
    wire [2:0] opcode;
    wire [12:0] ir_addr, pc_addr;
    wire [7:0] alu_out, accum1;
    wire zero, inc_pc, load_acc, load_pc, load_ir, data_ena, contr_ena;

    clk_gen m_clk_gen (
        .clk    (clk),
        .fetch  (fetch),
        .alu_ena(alu_ena),
        .clk1   (clk1),
        .reset  (reset)
    );

    register m_register (
        .data      (data),
        .ena       (load_ir),
        .rst       (reset),
        .clk1      (clk1),
        .opc_iraddr({opcode, ir_addr})
    );

    accum m_accum (
        .data (alu_out),
        .ena  (load_acc),
        .clk1 (clk1),
        .rst  (reset),
        .accum(accum1)
    );

    alu m_alu (
        .data   (data),
        .accum  (accum1),
        .alu_ena(alu_ena),
        .opcode (opcode),
        .alu_out(alu_out),
        .zero   (zero)
    );

    machinectl m_machinecl (
        .rst  (reset),
        .fetch(fetch),
        .ena  (control_ena)
    );

    machine m_machine (
        .inc_pc     (inc_pc),
        .load_acc   (load_acc),
        .load_pc    (load_pc),
        .rd         (rd),
        .wr         (wr),
        .load_ir    (load_ir),
        .clk1       (clk1),
        .datactl_ena(data_ena),
        .halt       (halt),
        .zero       (zero),
        .ena        (control_ena),
        .opcode     (opcode)
    );

    datactl m_datactl (
        .in      (alu_out),
        .data_ena(data_ena),
        .data    (data)
    );

    adr m_adr (
        .fetch  (fetch),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr),
        .addr   (addr)
    );

    counter m_counter (
        .clock  (inc_pc),
        .rst    (reset),
        .ir_addr(ir_addr),
        .load   (load_pc),
        .pc_addr(pc_addr)
    );

endmodule
