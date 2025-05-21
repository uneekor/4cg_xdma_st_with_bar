
`timescale 1 ns / 1 ps

	module axi_xdma_st_data_gen_yuri #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 128, // AXI-Stream  bus-width 
        parameter integer NUMBER_OF_OUTPUT_WORDS = 64 	// number of words in one axi-stream packet. '0' means packet never end.
	)
	(
		// Users to add ports here


        //Address Write Channel
        input wire [5:0] axi_awaddr,
        input wire [2:0] axi_awprot,
        input wire axi_awvalid,
        output wire axi_awready,
        
        //Write Channel
        input wire [31:0] axi_wdata,
        input wire [3:0] axi_wstrb,
        input wire axi_wvalid,
        output wire axi_wready,
        
        //Write Response channel
        output wire [1:0] axi_bresp,
        output wire axi_bvalid,
        input wire axi_bready,
        
        //Address Read Channel
        input wire [5:0]axi_araddr,
        input wire [2:0]axi_arprot,
        input wire axi_arvalid,
        output wire axi_arready,
        
        //Read Channel
        output wire  [31:0] axi_rdata,
        output wire [1:0] axi_rresp,
        output wire axi_rvalid,
        input wire axi_rready,

        
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
	
    wire [31:0] config_reg0;
    wire [31:0] config_reg1;
    wire [31:0] config_reg2;
    
// Instantiation of Axi Bus Interface M00_AXIS
	axi_xdma_st_data_gen_yuri_master_stream_v1_0_M00_AXIS # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.NUMBER_OF_OUTPUT_WORDS(NUMBER_OF_OUTPUT_WORDS)
	) axi_xdma_st_data_gen_yuri_master_stream_v1_0_M00_AXIS_inst (
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TREADY(m00_axis_tready), 

		//Config Reg Input
        .config_reg0(config_reg0),
        .config_reg1(config_reg1), 
        .config_reg2(config_reg2)
	);

	// Add user logic here

    axi_lite_slave axi_lite_slave_inst (
		//Clock, Reset
		.axi_clk(m00_axis_aclk),
		.axi_rstn(m00_axis_aresetn),

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
	// User logic ends

	endmodule
