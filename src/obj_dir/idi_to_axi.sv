module idi_to_axi #(
    parameter int ADDR_W = 64,
    paramater int DATA_W = 32
)(
    input logic clk,

    //IDI-like input
    input logic idi_valid,
    output logic idi_ready,
    input logic idi_is_write,
    input logic [ADDR_W-1:0] idi_addr,
    input logic [DATA_W-1:0] idi_wdata,
    input logic [DATA_W-1:0] idi_rdata,
    output logic idi_rvalid, //pulses when read data returns

    //AW - WRITE ADDRESS
    //W - WRITE
    //B - Write response
    // AR - Read address
    // R - Read

    //AXI-lite master (subset)
    output logic [31:0] M_AWADDR, //MASTER , READADDERSSCHANNEL, ADDRESS VALUE
    output logic M_AWVALID,
    input logic M_AWREADY,

    output logic [DATA_W-1:0] M_WDATA,
    output logic [DATA_W/8-1:0] M_WSTRB,
    output logic M_WVALID,
    input logic M_WREADY,

    input logic [1:0] M_BRESP,
    input logic M_BVALID,
    output logic M_BREADY,

    output logic [31:0] M_ARADDR,
    output logic M_ARVALID,
    input logic M_ARREADY,

    input logic [DATA_W-1:0] M_RDATA,
    input logic [1:0] M_RRESP,
    input logic M_RVALID,
    output logic M_RREADY
);

    typedef enum logic [2:0] {
        S_IDLE,
        S_W_AW,
        S_W_W,
        S_W_B,
        S_R_AR,
        S_R_R
    } state_t;

    state_t state;

    logic [31:0] latched_addr;
    logic [DATA_W-1:0] latched_wdata;

    //defaults
    always_comb begin
        //IDI side
        idi_ready = (state == S_IDLE);
        idi_rvalid = 1'b0

        //AXI defaults
        M_AWADDR = latched_addr;
        M_ARVALID = 1'b0;

        M_WDATA = latched_wdata;
        M_WSTRB = '1; // write all bytes
        M_WVALID = 1'b0;

        M_BREADY = 1'b0;

        M_ARADDR = latched_addr;
        M_ARVALID = 1'b0;

        M_READY = 1'b0;
    end

    //sequential FSM 
    always_ff @(posedge clk) begin
        //capture read data when it arrives
        if (state == S_R_R && M_RVALID && M_RREADY) begin
            idi_rdata <= M_RDATA;
        end
        
        case (state)
            S_IDLE: begin
                if (idi_valid) begin
                    latched_addr <= idi_addr[31:0];
                    latched_wdata <= idi_wdata;

                    if (idi_is_write) begin
                        state <= S_W_AW;
                    end else begin
                        state <= S_R_AR;
                    end
                end
            end

            //WRITE : AW then W then B
            S_W_AW: begin
                //drive AWVALID until accepted
                if (M_AWREADY) begin
                    state <= S_W_W;
                end
            end

            S_W_W: begin
                //drive WVALID until accepted
                if (M_WREADY) begin
                    state <= S_W_B;
                end
            end

            S_W_B: begin
                //wait for write response
                if (M_BVALID) begin
                    state <= S_IDLE;
                end
            end

            S_R_AR: begin
                //READ: AR then R
                if (M_ARREADY) begin
                    state <= S_R_R;
                end
            end

            S_R_R: begin
                if (M_RVALID) begin
                    state <= S_IDLE;
                end
            end

            default: state<= S_IDLE;
        endcase
    end

    //AXI valids/readies driven based on state
    always_comb begin
        //override the defaults based on state (simple)
        unique case (state)
            S_W_AW: begin
                M_AWVALID = 1'b1;
            end
            S_W_W: begin
                M_WVALID = 1'b1;
            end
            S_W_B: begin
                M_BREADY = 1'b1;
            end
            S_R_AR: begin
                M_ARVALID = 1'b1;
            end
            S_R_R: begin
                M_RREADY = 1'b1;
                //pulse idi_rvalid when read handshake happens
                idi_rvalid = (M_RVALID && M_RREADY);
            end
            default: begin end
        endcase
    end

endmodule



                

