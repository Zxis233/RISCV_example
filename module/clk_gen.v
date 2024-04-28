`timescale 1ns / 1ns
module clk_gen (
    clk,
    reset,
    fetch,
    alu_ena,
    clk1,
    clk2,
    clk4
);
    input clk, reset;
    output fetch, alu_ena, clk1, clk2, clk4;
    wire clk, reset;
    reg fetch, alu_ena, clk2, clk4;
    reg [7:0] state;

    parameter S1 = 8'b00000001, S2 = 8'b00000010, S3 = 8'b00000100, S4 = 8'b00001000,
        S5 = 8'b00010000, S6 = 8'b00100000, S7 = 8'b01000000, S8 = 8'b10000000, idle = 8'b00000000;

    assign clk1 = ~clk;

    always @(posedge clk)

        if (reset) begin
            fetch   <= 0;
            alu_ena <= 0;
            state   <= idle;
            clk2    <= 0;
            clk4    <= 1;
        end
        else begin

            case (state)
                S1: begin
                    alu_ena <= 1;
                    state   <= S2;
                    clk2    <= ~clk2;
                end
                S2: begin
                    alu_ena <= 0;
                    state   <= S3;
                    clk2    <= ~clk2;
                    clk4    <= ~clk4;
                end
                S3: begin
                    fetch <= 1;
                    state <= S4;
                    clk2  <= ~clk2;
                end
                S4: begin
                    state <= S5;
                    clk2  <= ~clk2;
                    clk4  <= ~clk4;
                end
                S5: begin
                    state <= S6;
                    clk2  <= ~clk2;
                end
                S6: begin
                    state <= S7;
                    clk2  <= ~clk2;
                    clk4  <= ~clk4;
                end
                S7: begin
                    fetch <= 0;
                    state <= S8;
                    clk2  <= ~clk2;
                end
                S8: begin
                    state <= S1;
                    clk2  <= ~clk2;
                    clk4  <= ~clk4;
                end
                idle:    state <= S1;
                default: state <= idle;
            endcase

        end

endmodule
