module rom (
    data,
    addr,
    read,
    ena
);
    output [7:0] data;
    input [12:0] addr;
    input read, ena;

    reg  [7:0] memory[0:13'h1fff];
    wire [7:0] data;

    assign data = (read && ena) ? memory[addr] : 8'bzzzzzzzz;

endmodule
