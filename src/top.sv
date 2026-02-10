module top(
//logic clk = 0;
//always #5 clk = ~clk;
input logic clk,
input logic valid,
input logic is_write,
input logic [63:0] addr,
input logic [31:0] wdata,
output logic [31:0] rdata,
output logic ready
);
idi_sink sink(
    .clk(clk),
    .valid(valid),
    .ready(ready),
    .is_write(is_write),
    .addr(addr),
    .wdata(wdata),
    .rdata(rdata)
);

//initial begin
    //valid = 0;
    //is_write = 0;
    //addr = 0;
    //wdata = 0;
//
    //#20;
//
    //valid = 1;
    //is_write = 1;
    //addr = 64'h100;
    //wdata = 32'hdeadbeef;
//
    //#10;
    //valid = 0;
//
    //#20;
    //valid = 1;
    //is_write = 0;
    //addr = 64'h100;
//
    //#10;
    //valid = 0;
//
    //#50;
    //$finish;
//end
//endmodule
endmodule


