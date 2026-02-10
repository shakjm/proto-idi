interface idi_if(input logic clk);
    logic valid;
    logic ready;
    logic is_write;
    logic [63:0] addr;
    logic [31:0] wdtata;
    logic [31:0] rdata;
endinterface

