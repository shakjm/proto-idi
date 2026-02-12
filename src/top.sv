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

    //IDI AXI Wires
    logic [31:0] awaddr, araddr;
    logic awvalid, awready;
    logic [31:0] wdata_m;
    logic [3:0] wstrb;
    logic wvalid, wready;
    logic [1:0] bresp;
    logic bvalid, bready;
    logic arvalid, arready;
    logic [31:0] rdata_m;
    logic [1:0] rresp;
    logic rvalid, rready;

    logic idi_rvalid; //Not used by top output, but useful later

    idi_to_axi u_txn(
        .clk(clk),

        .idi_valid(valid),
        .idi_ready(ready),
        .idi_is_write(is_write),
        .idi_addr(addr),
        .idi_wdata(wdata),
        .idi_rdata(rdata),
        .idi_rvalid(idi_rvalid),

        .M_AWADDR(awaddr),
        .M_AWVALID(awvalid),
        .M_AWREADY(awready),

        .M_WDATA(wdata_m),
        .M_WSTRB(wstrb),
        .M_WVALID(wvalid),
        .M_WREADY(wready),

        .M_BRESP(brsep),
        .M_BVALID(bvalid),
        .M_BREADY(bready),

        .M_ARADDR(araddr),
        .M_ARVALID(arvalid),
        .M_ARREADY(arready),

        .M_RDATA(rdata_m),
        .M_RRESP(rresp),
        .M_RVALID(rvalid),
        .M_RREADY(rready)
    );

    axi_ram u_ram(
        .clk(clk)

        .S_AWADDR(awaddr),
        .S_AWVALID(awvalid),
        .S_AWREADY(awready),

        .S_WDATA(wdata_m),
        .S_WSTRB(wstrb),
        .S_WVALID(wvalid),
        .S_WREADY(wready),

        .S_BRESP(bresp),
        .S_BVALID(bvalid),
        .S_BREADY(bready),

        .S_ARADDR(araddr),
        .S_ARVALID(arvalid),
        .S_ARREADY(arready),

        .S_RDATA(rdata_m),
        .S_RRESP(rresp),
        .S_RVALID(rvalid),
        .S_RREADY(rready)
    )
endmodule

//idi_sink sink(
//    .clk(clk),
//    .valid(valid),
//    .ready(ready),
//    .is_write(is_write),
//    .addr(addr),
//    .wdata(wdata),
//    .rdata(rdata)
//);



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


