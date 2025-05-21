`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/20/2025 10:11:13 AM
// Design Name:
// Module Name: axi_lite_slave
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module axi_lite_slave (input wire axi_clk,
                       input wire axi_rstn,
                       input wire [5:0] axi_awaddr,
                       input wire [2:0] axi_awprot,
                       input wire axi_awvalid,
                       output wire axi_awready,
                       input wire [31:0] axi_wdata,
                       input wire [3:0] axi_wstrb,
                       input wire axi_wvalid,
                       output wire axi_wready,
                       output wire [1:0] axi_bresp,
                       output wire axi_bvalid,
                       input wire axi_bready,
                       input wire [5:0]axi_araddr,
                       input wire [2:0]axi_arprot,
                       input wire axi_arvalid,
                       output wire axi_arready,
                       output wire [31:0] axi_rdata,
                       output wire [1:0] axi_rresp,
                       output wire axi_rvalid,
                       input wire axi_rready,
                       output wire [31:0]config_reg0,
                       output wire [31:0]config_reg1,
                       output wire [31:0]config_reg2);
    
    reg [511:0] data_reg;
    reg arready_reg;
    reg rvalid_reg;
    reg [31:0] rdata_reg;
    reg awready_reg;
    reg wready_reg;
    reg [5:0] waddr_reg;
    reg bvalid_reg;
    reg [1:0]bresp_reg;
    reg [1:0]rresp_reg;
    
    
    assign axi_rdata   = rdata_reg;
    assign axi_arready = arready_reg;
    assign axi_rvalid  = rvalid_reg;
    assign axi_awready = awready_reg;
    assign axi_wready  = wready_reg;
    assign axi_bvalid  = bvalid_reg;
    assign axi_bresp   = bresp_reg;
    assign axi_rresp   = rresp_reg;
    
    
    assign config_reg0 = data_reg[0 +: 32];
    assign config_reg1 = data_reg[32 +: 32];
    assign config_reg2 = data_reg[64 +: 64];
    wire [31:0] data_write_mask;
    generate
    genvar i;
    for(i = 0; i < 32; i = i+1) begin
        assign data_write_mask[i] = axi_wstrb[i / 8];
    end
    endgenerate
    
    localparam [1:0] READ_IDLE = 2'b00, READ_ADDRESS = 2'b01, READ_DATA = 2'b10 ;
    reg [1:0] read_state;
    
    localparam [1:0] WRITE_IDLE = 2'b00, WRITE_ADDRESS = 2'b01, WRITE_DATA = 2'b10, WRITE_RESPONSE = 2'b11;
    reg [1:0] write_state;
    
    
    // Read 처리
    always @(posedge axi_clk) begin
        if (!axi_rstn) begin
            read_state  <= READ_IDLE;
            rdata_reg   <= 0;
            arready_reg <= 0;
            rresp_reg   <= 2'b00;
            rvalid_reg  <= 0;
        end
        else begin
            case(read_state)
                READ_IDLE: begin
                    read_state  <= READ_ADDRESS;
                    arready_reg <= 1'b1;
                end
                READ_ADDRESS: begin
                    if (axi_arvalid && axi_arready) begin
                        arready_reg <= 1'b0;
                        read_state <= READ_DATA;
                        rvalid_reg <= 1'b1;
                        rdata_reg  <= data_reg[(axi_araddr & 6'b111100 )*8 +: 32];
                    end
                end
                READ_DATA: begin
                    if (axi_rready && axi_rvalid) begin
                        rvalid_reg <= 1'b0;
                        read_state <= READ_IDLE;
                    end
                end
            endcase
        end
    end
    
    // Write 처리
    always @(posedge axi_clk) begin
        if (!axi_rstn) begin
            data_reg    <= 512'b0;
            wready_reg  <= 1'b0;
            awready_reg <= 1'b0;
            waddr_reg   <= 6'b0;
            bresp_reg   <= 2'b00;
            bvalid_reg  <= 1'b0;
            write_state <= WRITE_IDLE;
        end
        else begin
            case(write_state)
                WRITE_IDLE: begin
                    write_state <= WRITE_ADDRESS;
                    awready_reg <= 1'b1;
                end
                WRITE_ADDRESS: begin
                    if (axi_awvalid && axi_awready) begin
                        awready_reg <= 1'b0;
                        waddr_reg   <= axi_awaddr & 6'b111100; // 주소 4Byte 정렬
                        write_state <= WRITE_DATA;
                        wready_reg  <= 1'b1;
                    end
                end
                WRITE_DATA: begin
                    if (axi_wvalid && axi_wready) begin
                        wready_reg <= 1'b0;
                        // wstrb 가 1인 byte만 write
                        data_reg[waddr_reg*8 +: 32] <= (data_write_mask & axi_wdata) | (data_reg[waddr_reg*8 +: 32] & (~data_write_mask));
                        write_state                   <= WRITE_RESPONSE;
                        bvalid_reg                    <= 1'b1;
                    end
                end
                WRITE_RESPONSE: begin
                    if (axi_bready && axi_bvalid) begin
                        bvalid_reg  <= 1'b0;
                        write_state <= WRITE_IDLE;
                    end
                end
            endcase
        end
    end
    
    
endmodule
