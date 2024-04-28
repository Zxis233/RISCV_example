`timescale 1ns / 1ns
module machinectl (
    ena,
    fetch,
    rst,
);

    input fetch, rst;
    output ena;

    reg ena;
    reg state;

    always @(posedge fetch,posedge rst) begin
        if (rst) ena <= 0;
        else if (fetch) ena <= 1;
    end

endmodule
