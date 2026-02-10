module idi_sink(
    input logic clk,
    input logic valid,
    output logic ready,
    input logic is_write,
    input logic [63:0] addr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
    //idi_if idi // <-- interface port
);

    always_ff @(posedge clk) begin
        ready <= 1'b1;

    if (valid && ready) begin
        if (is_write) begin
            $display("IDI WRITE addr=%h data=%h", addr, wdata);
        end else begin
            rdata <= 32'h12345678;
            $display("IDI READ addr=%h", addr);
        end
    end
    end
endmodule

