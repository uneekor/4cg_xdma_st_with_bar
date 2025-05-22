`timescale 1ns / 1ps
`include "axi_lite_slave.v"

module axi_lite_slave_tb();
    reg clk;
    reg rstn;
    
    reg [5:0] axi_awaddr;
    reg [2:0] axi_awprot;
    reg axi_awvalid;
    wire axi_awready;
    reg [31:0] axi_wdata;
    reg [3:0] axi_wstrb;
    reg axi_wvalid;
    wire axi_wready;
    wire [1:0] axi_bresp;
    wire axi_bvalid;
    reg axi_bready;
    reg [5:0]axi_araddr;
    reg [2:0]axi_arprot;
    reg axi_arvalid;
    wire axi_arready;
    wire [31:0] axi_rdata;
    wire [1:0] axi_rresp;
    wire axi_rvalid;
    reg axi_rready;
    wire [31:0]config_reg0;
    wire [31:0]config_reg1;
    wire [31:0]config_reg2;
    
    initial begin
        $dumpfile("axi_test_tb.vcd");
        $dumpvars(0, axi_lite_slave_tb);
        #4000
        $finish;
    end
    initial begin
        clk = 0;
        rstn        <= 0;
        axi_wdata   <= 512'b0;
        axi_awaddr  <= 0; axi_awprot  <= 0;
        axi_awvalid <= 0;
        axi_wstrb   <= 0;
        axi_wvalid  <= 0;
        axi_bready  <= 1;
        axi_arprot  <= 0;
        axi_araddr  <= 0;
        axi_arvalid <= 0;
        axi_rready  <= 0;
        
        #20
        rstn <= 1;
        
    end
    
    always begin
        #5;
        clk <= ~clk;
    end
    localparam AXI_W_IDLE = 2'b00,
    AXI_W_ADDR = 2'b01,
    AXI_W_DATA = 2'b10;
    reg [1:0] axi_w_state;
    
    // LSFR Random
    reg [31:0] q;
    initial begin
        q <= 32'hdeadbeef; // Seed
    end
    wire feedback = q[31] ^ q[6] ^ q[5] ^ q[1];
    always begin
        #1
        q <= {q[30:0], feedback};
    end

    integer write_cnt = 0;
    wire write_test_done;
    assign write_test_done = write_cnt == 16 && axi_w_state == AXI_W_IDLE;
    
    always @(posedge clk) begin
        if (!rstn) begin
            axi_w_state <= AXI_W_IDLE;
        end
        else begin
            case(axi_w_state)
                AXI_W_IDLE: begin
                    if (write_cnt < 16) begin
                        write_cnt   <= write_cnt+1;
                        axi_awaddr  <= write_cnt * 4;
                        axi_w_state <= AXI_W_ADDR;
                        axi_awvalid <= 1;
                    end
                end
                AXI_W_ADDR: begin
                    if (axi_awready && axi_awvalid) begin
                        axi_awvalid <= 0;
                        axi_awaddr  <= 0;
                        
                        axi_wdata   <= q;
                        axi_wstrb   <= 4'b1111;
                        axi_wvalid  <= 1;
                        axi_w_state <= AXI_W_DATA;
                    end
                end
                AXI_W_DATA: begin
                    if (axi_wready && axi_wvalid) begin
                        axi_wvalid  <= 0;
                        axi_w_state <= AXI_W_IDLE;
                    end
                end
            endcase
        end
    end
    
    localparam AXI_R_IDLE = 2'b00,
    AXI_R_ADDR = 2'b01,
    AXI_R_DATA = 2'b10;
    reg [1:0] axi_r_state;
    integer read_cnt = 0;
    always @(posedge clk) begin
        if (!rstn) begin
            axi_r_state <= AXI_R_IDLE;
        end
        else begin
            case(axi_r_state)
                AXI_R_IDLE: begin
                    if (read_cnt < 16 && write_test_done) begin
                        axi_r_state <= AXI_R_ADDR;
                        read_cnt    <= read_cnt+1;
                        axi_araddr  <= read_cnt * 4;
                        axi_arvalid <= 1;
                    end
                end
                AXI_R_ADDR: begin
                    if (axi_arready && axi_arvalid) begin
                        axi_arvalid <= 0;
                        axi_araddr  <= 0;
                        
                        axi_rready  <= 1;
                        axi_r_state <= AXI_R_DATA;
                    end
                end
                AXI_R_DATA: begin
                    if (axi_rvalid) begin
                        axi_rready  <= 0;
                        axi_r_state <= AXI_R_IDLE;
                    end
                end
            endcase
        end
    end
    
    
    axi_lite_slave axi_lite_slave_inst (
    //Clock, Reset
    .axi_clk(clk),
    .axi_rstn(rstn),
    
    //Address Write Channel
    .axi_awaddr(axi_awaddr),
    .axi_awprot(axi_awprot),
    .axi_awvalid(axi_awvalid),
    .axi_awready(axi_awready),
    
    //Write Channel
    .axi_wdata(axi_wdata),
    .axi_wstrb(axi_wstrb),
    .axi_wvalid(axi_wvalid),
    .axi_wready(axi_wready),
    
    //Write Response channel
    .axi_bresp(axi_bresp),
    .axi_bvalid(axi_bvalid),
    .axi_bready(axi_bready),
    
    //Address Read Channel
    .axi_araddr(axi_araddr),
    .axi_arprot(axi_arprot),
    .axi_arvalid(axi_arvalid),
    .axi_arready(axi_arready),
    
    //Read Channel
    .axi_rdata(axi_rdata),
    .axi_rresp(axi_rresp),
    .axi_rvalid(axi_rvalid),
    .axi_rready(axi_rready),
    
    //Config Reg Output
    .config_reg0(config_reg0),
    .config_reg1(config_reg1),
    .config_reg2(config_reg2)
    );
    
endmodule
