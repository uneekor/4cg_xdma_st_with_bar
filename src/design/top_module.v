`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 09:16:04 AM
// Design Name: 
// Module Name: top_module
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


module top_module (
    output wire [7:0]led,
    input wire sys_clk_200M_clk_p,
    input wire sys_clk_200M_clk_n,
    input wire [0:0]pcie_clk_clk_p,
    input wire [0:0]pcie_clk_clk_n,
    input wire [1:0]pcie_7x_mgt_rtl_0_rxn,
    input wire [1:0]pcie_7x_mgt_rtl_0_rxp,
    output wire [1:0]pcie_7x_mgt_rtl_0_txn,
    output wire [1:0]pcie_7x_mgt_rtl_0_txp,
    input wire pcie_rstn
    );
    

    wire c2h_led;
    wire h2c_led;
    assign led[0] = pcie_rstn;
    assign led[1] = c2h_led;
    assign led[2] = h2c_led;
    
    wire sys_clk_200M;


    IBUFDS IBUFDS_sysclk_200 (
    .I(sys_clk_200M_clk_p),
    .IB(sys_clk_200M_clk_n),
    .O(sys_clk_200M)
    );

  design_1_wrapper design_1_wrapper_i
       (
        .c2h_led(c2h_led),
        .h2c_led(h2c_led),
        .pcie_7x_mgt_rtl_0_rxn(pcie_7x_mgt_rtl_0_rxn),
        .pcie_7x_mgt_rtl_0_rxp(pcie_7x_mgt_rtl_0_rxp),
        .pcie_7x_mgt_rtl_0_txn(pcie_7x_mgt_rtl_0_txn),
        .pcie_7x_mgt_rtl_0_txp(pcie_7x_mgt_rtl_0_txp),
        .pcie_clk_clk_n(pcie_clk_clk_n),
        .pcie_clk_clk_p(pcie_clk_clk_p),
        .pcie_rstn(pcie_rstn),
        .sys_clk_200M(sys_clk_200M));
 
endmodule
