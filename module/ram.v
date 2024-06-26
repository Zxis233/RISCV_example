module ram (
    data,
    addr,
    ena,
    read,
    write
);

    inout [7:0] data;
    input [9:0] addr;
    input ena;
    input read, write;

    reg [7:0] ram[0:10'h3ff];

    assign data = (read && ena) ? ram[addr] : 8'hzz;

    always @(posedge write) begin
        ram[addr] <= data;
    end

endmodule
