
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "../dut/include/network_define.v"
`include "demoter.sv"
`include "router_if.sv"
`include "packet_transaction.sv"
`include "router_driver.sv"
`include "router_monitor.sv"
`include "router_sequence.sv"
`include "router_sequencer.sv"
`include "mesh_virtual_sequencer.sv"
`include "mesh_virtual_sequence_random.sv"
`include "mesh_virtual_sequence_fuzz.sv"
`include "router_agent.sv"
`include "mesh_scoreboard.sv"
`include "mesh_env.sv"
`include "test_random.sv"
`include "test_fuzz.sv"


module top_tb;

  reg clk;
  
  mesh_rst_if rst_if(clk);

  
  router_if input_if_0_0(clk,rst_if.rst);
  router_if output_if_0_0(clk,rst_if.rst);
  router_if input_if_0_1(clk,rst_if.rst);
  router_if output_if_0_1(clk,rst_if.rst);
  router_if input_if_0_2(clk,rst_if.rst);
  router_if output_if_0_2(clk,rst_if.rst);
  router_if input_if_1_0(clk,rst_if.rst);
  router_if output_if_1_0(clk,rst_if.rst);
  router_if input_if_1_1(clk,rst_if.rst);
  router_if output_if_1_1(clk,rst_if.rst);
  router_if input_if_1_2(clk,rst_if.rst);
  router_if output_if_1_2(clk,rst_if.rst);
  router_if input_if_2_0(clk,rst_if.rst);
  router_if output_if_2_0(clk,rst_if.rst);
  router_if input_if_2_1(clk,rst_if.rst);
  router_if output_if_2_1(clk,rst_if.rst);
  router_if input_if_2_2(clk,rst_if.rst);
  router_if output_if_2_2(clk,rst_if.rst);

  
  mesh mesh(
    .clk(clk),
    .reset_in(rst_if.rst),

    
    .data_in_p_0_0(input_if_0_0.data),
    .valid_in_p_0_0(input_if_0_0.valid),
    .yummy_in_p_0_0(output_if_0_0.yummy),

    .data_out_p_0_0(output_if_0_0.data),
    .valid_out_p_0_0(output_if_0_0.valid),
    .yummy_out_p_0_0(input_if_0_0.yummy),
    .thanks_in_p_0_0(),

    .data_in_p_0_1(input_if_0_1.data),
    .valid_in_p_0_1(input_if_0_1.valid),
    .yummy_in_p_0_1(output_if_0_1.yummy),

    .data_out_p_0_1(output_if_0_1.data),
    .valid_out_p_0_1(output_if_0_1.valid),
    .yummy_out_p_0_1(input_if_0_1.yummy),
    .thanks_in_p_0_1(),

    .data_in_p_0_2(input_if_0_2.data),
    .valid_in_p_0_2(input_if_0_2.valid),
    .yummy_in_p_0_2(output_if_0_2.yummy),

    .data_out_p_0_2(output_if_0_2.data),
    .valid_out_p_0_2(output_if_0_2.valid),
    .yummy_out_p_0_2(input_if_0_2.yummy),
    .thanks_in_p_0_2(),

    .data_in_p_1_0(input_if_1_0.data),
    .valid_in_p_1_0(input_if_1_0.valid),
    .yummy_in_p_1_0(output_if_1_0.yummy),

    .data_out_p_1_0(output_if_1_0.data),
    .valid_out_p_1_0(output_if_1_0.valid),
    .yummy_out_p_1_0(input_if_1_0.yummy),
    .thanks_in_p_1_0(),

    .data_in_p_1_1(input_if_1_1.data),
    .valid_in_p_1_1(input_if_1_1.valid),
    .yummy_in_p_1_1(output_if_1_1.yummy),

    .data_out_p_1_1(output_if_1_1.data),
    .valid_out_p_1_1(output_if_1_1.valid),
    .yummy_out_p_1_1(input_if_1_1.yummy),
    .thanks_in_p_1_1(),

    .data_in_p_1_2(input_if_1_2.data),
    .valid_in_p_1_2(input_if_1_2.valid),
    .yummy_in_p_1_2(output_if_1_2.yummy),

    .data_out_p_1_2(output_if_1_2.data),
    .valid_out_p_1_2(output_if_1_2.valid),
    .yummy_out_p_1_2(input_if_1_2.yummy),
    .thanks_in_p_1_2(),

    .data_in_p_2_0(input_if_2_0.data),
    .valid_in_p_2_0(input_if_2_0.valid),
    .yummy_in_p_2_0(output_if_2_0.yummy),

    .data_out_p_2_0(output_if_2_0.data),
    .valid_out_p_2_0(output_if_2_0.valid),
    .yummy_out_p_2_0(input_if_2_0.yummy),
    .thanks_in_p_2_0(),

    .data_in_p_2_1(input_if_2_1.data),
    .valid_in_p_2_1(input_if_2_1.valid),
    .yummy_in_p_2_1(output_if_2_1.yummy),

    .data_out_p_2_1(output_if_2_1.data),
    .valid_out_p_2_1(output_if_2_1.valid),
    .yummy_out_p_2_1(input_if_2_1.yummy),
    .thanks_in_p_2_1(),

    .data_in_p_2_2(input_if_2_2.data),
    .valid_in_p_2_2(input_if_2_2.valid),
    .yummy_in_p_2_2(output_if_2_2.yummy),

    .data_out_p_2_2(output_if_2_2.data),
    .valid_out_p_2_2(output_if_2_2.valid),
    .yummy_out_p_2_2(input_if_2_2.yummy),
    .thanks_in_p_2_2()

  );

  initial begin
    clk = 0;
    forever begin
        #100 clk = ~clk;
    end
  end
    
  initial begin
    run_test("fuzz_test");
  end
  
  initial begin
    
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_0.drv", "vif", input_if_0_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_0.mon_in", "vif", input_if_0_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_0.mon_out", "vif", output_if_0_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_1.drv", "vif", input_if_0_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_1.mon_in", "vif", input_if_0_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_1.mon_out", "vif", output_if_0_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_2.drv", "vif", input_if_0_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_2.mon_in", "vif", input_if_0_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_0_2.mon_out", "vif", output_if_0_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_0.drv", "vif", input_if_1_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_0.mon_in", "vif", input_if_1_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_0.mon_out", "vif", output_if_1_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_1.drv", "vif", input_if_1_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_1.mon_in", "vif", input_if_1_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_1.mon_out", "vif", output_if_1_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_2.drv", "vif", input_if_1_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_2.mon_in", "vif", input_if_1_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_1_2.mon_out", "vif", output_if_1_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_0.drv", "vif", input_if_2_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_0.mon_in", "vif", input_if_2_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_0.mon_out", "vif", output_if_2_0);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_1.drv", "vif", input_if_2_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_1.mon_in", "vif", input_if_2_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_1.mon_out", "vif", output_if_2_1);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_2.drv", "vif", input_if_2_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_2.mon_in", "vif", input_if_2_2);
    uvm_config_db#(virtual router_if)::set(null, "uvm_test_top.env.agt_2_2.mon_out", "vif", output_if_2_2);

    uvm_config_db#(virtual mesh_rst_if)::set(null, "uvm_test_top", "rst_if", rst_if);
  end


endmodule
    
    
    