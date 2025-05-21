`timescale 1ns / 1ps
`include "axi_lite_slave.v"

module ex_tb();
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
        $dumpvars(0, ex_tb);

        #10000
        $finish;
    end
    initial begin
        clk = 0;
        rstn <= 0;
        axi_wdata <= 512'b0;
        axi_awaddr <= 0; axi_awprot <= 0;
        axi_awvalid <= 0;
        axi_wstrb <= 0;
        axi_wvalid <= 0;
        axi_bready <= 1;
        axi_arprot <= 0;
        axi_araddr <= 0;
        axi_arvalid <= 0;
        axi_rready <= 0;

        #20
        rstn <= 1;

        #50
        axi_awaddr <= 1;
        axi_awvalid <= 1;

        #5
        axi_awaddr <= 0;
        axi_awvalid <= 0;

        #5
        axi_wvalid <= 1;
        axi_wstrb <= 4'b0010;
        axi_wdata <= 32'h12345678;
        
        #5
        axi_wvalid <= 0;
        axi_wdata <= 0;

        #25
        axi_awaddr <= 2;
        axi_awvalid <= 1;
        #5
        axi_awaddr <= 0;
        axi_awvalid <= 0;
        #5
        axi_wvalid <= 1;
        axi_wstrb <= 4'b0100;
        axi_wdata <= 32'hffaabbcc;
        #5
        axi_wvalid <= 0;
        axi_wdata <= 0;

        #25
        axi_araddr <= 0;
        axi_arvalid <= 1;
        #5
        axi_arvalid <= 0;
        axi_araddr <= 0;
        #5
        axi_rready <= 1;
        #5
        axi_rready <= 0;

    end

    always begin
        #5;
        clk = ~clk;
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
