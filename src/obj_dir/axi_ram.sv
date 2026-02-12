module axi_ram #(
    parameter int ADDR_W = 32,
    parameter int DATA_W = 32,
    parameter int DEPTH_WORDS = 1024
)(
    input logic clk,

    //AXI-lite slave
    input logic [ADDR_W-1:0] S_AWADDR,
    input logic S_AWVALID,
    input logic S_AWREADY,

    input logic [DATA_W-1:0] S_WDATA,
    input logic [DATA_W/8-1:0] S_WSTRB,
    input logic S_WVALID,
    output logic S_WREADY,

    output logic [1:0] S_BRESP,
    output logic S_BVALID,
    input logic S_BREADY,

    input logic [ADDR_W-1:0] S_ARADDR,
    input logic S_ARVALID,
    output logic S_ARREADY,

    output logic [DATA_W-1:0] S_RDATA,
    output logic [1:0] S_RRESP,
    output logic S_RVALID,
    input logic S_RREADY
)

    logic [DATA_W-1:0] mem [0:DEPTH_WORDS-1];

    //simple "always ready" for address/data channels
    always_ff @(posedge clk) begin
        S_AWREADY <= 1'b1;
        S_WREADY <= 1'b1;
        S_ARREADY <= 1'b1;

        //defaults for responses
        if (S_BVALID && S_BREADY) S_BVALID <= 1'b0;
        if (S_RVALID && S_RREADY) S_RVALID <= 1'b0;

        S_BRESP <= 2'b00; 
        S_RRESP <= 2'b00;

        //WRITE : accept when both AWVALID and WVALID (single-beat simplified)
        if (S_AWVALID && S_WVALID && !S_BVALID) begin
            int unsigned widx;
            widx = S_AWADDR[11:2]; //word index (4-byte aligned, small RAM window)

            //apply byte strobes
            logic [DATA_W-1:0] cur;
            cur = mem[widx];

            for (int b = 0; b < DATA_W/8; b++) begin
                if (S_WSTRB[b]) cur[b*8 +: 8] = S_WDATA[b*8 +: 8];
            end

            mem[widx] <= cur;

            S_BVALID <= 1'b1;

        end

        //READ : accept ARVALID, return RVALID next cycle (simple)
        if (S_ARVALID && !S_RVALID) begin
            int unsigned ridx;
            ridx = S_ARADDR[11:2];
            S_RDATA <= mem[ridx];
            S_RVALID <= 1'b1;

        end
    end
endmodule








