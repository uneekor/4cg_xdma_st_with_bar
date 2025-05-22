`timescale 1ns / 1ps
`include "axi_xdma_st_data_gen_yuri_master_stream_v1_0_M00_AXIS.v"

module axi_xdma_st_tb #(parameter NUMBER_OF_OUTPUT_WORDS = 0,
                        parameter C_M_AXIS_TDATA_WIDTH = 128)
                       ();
    reg clk;
    reg rstn;
    reg M_AXIS_TREADY;
    reg [31:0] config_reg0;
    reg [31:0] config_reg1;
    reg [31:0] config_reg2;
    wire M_AXIS_TLAST;
    wire M_AXIS_TVALID;
    wire [15:0] M_AXIS_TSTRB;
    wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA;
    
    initial begin
        $dumpfile("axi_xdma_st_tb.vcd");
        $dumpvars(0, axi_xdma_st_tb);
    end
    initial begin
        clk           <= 0;
        rstn          <= 0;
        config_reg0   <= 0;
        config_reg1   <= 1;
        config_reg2   <= 0;
        M_AXIS_TREADY <= 0;
        #20
        rstn <= 1;
        #20
        M_AXIS_TREADY <= 1;
        #500
        config_reg0 <= 2'b01;
        #500
        config_reg0 <= 2'b10;
        #500
        config_reg0 <= 2'b11;
        #1000
        $finish;
    end
    always begin
        #5
        clk = ~clk;
    end
    
    axi_xdma_st_data_gen_yuri_master_stream_v1_0_M00_AXIS #(
    .NUMBER_OF_OUTPUT_WORDS(NUMBER_OF_OUTPUT_WORDS),
    .C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH)
    ) DUT(
    .M_AXIS_ACLK(clk),
    .M_AXIS_ARESETN(rstn),
    .M_AXIS_TREADY(M_AXIS_TREADY),
    .M_AXIS_TVALID(M_AXIS_TVALID),
    .M_AXIS_TLAST(M_AXIS_TLAST),
    .M_AXIS_TSTRB(M_AXIS_TSTRB),
    .M_AXIS_TDATA(M_AXIS_TDATA),
    .config_reg0(config_reg0),
    .config_reg1(config_reg1),
    .config_reg2(config_reg2)
    );
    
    
endmodule
