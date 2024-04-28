`timescale 1ns / 1ns
module register (
    opc_iraddr,
    data,
    ena,
    clk1,
    rst
);

    output [15:0] opc_iraddr;
    input [7:0] data;
    input ena, clk1, rst;
    reg [15:0] opc_iraddr;
    reg        state;

    always @(posedge clk1) begin
        if (rst) begin
            opc_iraddr <= 16'b0000000000000000;
            state      <= 1'b0;
        end

        else begin
            if (ena)  // 如果加载指令寄存器信号load ir到来
                begin  //分两个时钟，每次8位加载指令寄存器

                casex (state)  //先高字节，后低字节
                    1'b0: begin
                        opc_iraddr[15:8] = data;
                        state <= 1;
                    end
                    1'b1: begin
                        opc_iraddr[7:0] = data;
                        state <= 0;
                    end
                    default: begin
                        opc_iraddr[15:0] = 16'bxxxxxxxxxxxxxxxx;
                        state <= 1'bx;
                    end
                endcase
            end

            else state <= 1'b0;

        end
    end
endmodule
