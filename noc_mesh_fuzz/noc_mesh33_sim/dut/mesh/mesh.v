
`include "dynamic_node_top_wrap.v"




module mesh (
    input clk,
    input reset_in,

    input [`DATA_WIDTH-1:0] data_in_p_0_0,
    input  valid_in_p_0_0,
    input  yummy_in_p_0_0,
    output [`DATA_WIDTH-1:0] data_out_p_0_0,
    output  valid_out_p_0_0,
    output  yummy_out_p_0_0,
    output thanks_in_p_0_0,

    input [`DATA_WIDTH-1:0] data_in_p_0_1,
    input  valid_in_p_0_1,
    input  yummy_in_p_0_1,
    output [`DATA_WIDTH-1:0] data_out_p_0_1,
    output  valid_out_p_0_1,
    output  yummy_out_p_0_1,
    output thanks_in_p_0_1,

    input [`DATA_WIDTH-1:0] data_in_p_0_2,
    input  valid_in_p_0_2,
    input  yummy_in_p_0_2,
    output [`DATA_WIDTH-1:0] data_out_p_0_2,
    output  valid_out_p_0_2,
    output  yummy_out_p_0_2,
    output thanks_in_p_0_2,

    input [`DATA_WIDTH-1:0] data_in_p_1_0,
    input  valid_in_p_1_0,
    input  yummy_in_p_1_0,
    output [`DATA_WIDTH-1:0] data_out_p_1_0,
    output  valid_out_p_1_0,
    output  yummy_out_p_1_0,
    output thanks_in_p_1_0,

    input [`DATA_WIDTH-1:0] data_in_p_1_1,
    input  valid_in_p_1_1,
    input  yummy_in_p_1_1,
    output [`DATA_WIDTH-1:0] data_out_p_1_1,
    output  valid_out_p_1_1,
    output  yummy_out_p_1_1,
    output thanks_in_p_1_1,

    input [`DATA_WIDTH-1:0] data_in_p_1_2,
    input  valid_in_p_1_2,
    input  yummy_in_p_1_2,
    output [`DATA_WIDTH-1:0] data_out_p_1_2,
    output  valid_out_p_1_2,
    output  yummy_out_p_1_2,
    output thanks_in_p_1_2,

    input [`DATA_WIDTH-1:0] data_in_p_2_0,
    input  valid_in_p_2_0,
    input  yummy_in_p_2_0,
    output [`DATA_WIDTH-1:0] data_out_p_2_0,
    output  valid_out_p_2_0,
    output  yummy_out_p_2_0,
    output thanks_in_p_2_0,

    input [`DATA_WIDTH-1:0] data_in_p_2_1,
    input  valid_in_p_2_1,
    input  yummy_in_p_2_1,
    output [`DATA_WIDTH-1:0] data_out_p_2_1,
    output  valid_out_p_2_1,
    output  yummy_out_p_2_1,
    output thanks_in_p_2_1,

    input [`DATA_WIDTH-1:0] data_in_p_2_2,
    input  valid_in_p_2_2,
    input  yummy_in_p_2_2,
    output [`DATA_WIDTH-1:0] data_out_p_2_2,
    output  valid_out_p_2_2,
    output  yummy_out_p_2_2,
    output thanks_in_p_2_2


);

    wire [`DATA_WIDTH-1:0] data_out_n_0_0;
    wire [`DATA_WIDTH-1:0] data_out_e_0_0;
    wire [`DATA_WIDTH-1:0] data_out_s_0_0;
    wire [`DATA_WIDTH-1:0] data_out_w_0_0;

    wire valid_out_n_0_0;
    wire valid_out_e_0_0;
    wire valid_out_s_0_0;
    wire valid_out_w_0_0;

    wire yummy_out_n_0_0;
    wire yummy_out_e_0_0;
    wire yummy_out_s_0_0;
    wire yummy_out_w_0_0;

    wire [`DATA_WIDTH-1:0] data_out_n_0_1;
    wire [`DATA_WIDTH-1:0] data_out_e_0_1;
    wire [`DATA_WIDTH-1:0] data_out_s_0_1;
    wire [`DATA_WIDTH-1:0] data_out_w_0_1;

    wire valid_out_n_0_1;
    wire valid_out_e_0_1;
    wire valid_out_s_0_1;
    wire valid_out_w_0_1;

    wire yummy_out_n_0_1;
    wire yummy_out_e_0_1;
    wire yummy_out_s_0_1;
    wire yummy_out_w_0_1;

    wire [`DATA_WIDTH-1:0] data_out_n_0_2;
    wire [`DATA_WIDTH-1:0] data_out_e_0_2;
    wire [`DATA_WIDTH-1:0] data_out_s_0_2;
    wire [`DATA_WIDTH-1:0] data_out_w_0_2;

    wire valid_out_n_0_2;
    wire valid_out_e_0_2;
    wire valid_out_s_0_2;
    wire valid_out_w_0_2;

    wire yummy_out_n_0_2;
    wire yummy_out_e_0_2;
    wire yummy_out_s_0_2;
    wire yummy_out_w_0_2;

    wire [`DATA_WIDTH-1:0] data_out_n_1_0;
    wire [`DATA_WIDTH-1:0] data_out_e_1_0;
    wire [`DATA_WIDTH-1:0] data_out_s_1_0;
    wire [`DATA_WIDTH-1:0] data_out_w_1_0;

    wire valid_out_n_1_0;
    wire valid_out_e_1_0;
    wire valid_out_s_1_0;
    wire valid_out_w_1_0;

    wire yummy_out_n_1_0;
    wire yummy_out_e_1_0;
    wire yummy_out_s_1_0;
    wire yummy_out_w_1_0;

    wire [`DATA_WIDTH-1:0] data_out_n_1_1;
    wire [`DATA_WIDTH-1:0] data_out_e_1_1;
    wire [`DATA_WIDTH-1:0] data_out_s_1_1;
    wire [`DATA_WIDTH-1:0] data_out_w_1_1;

    wire valid_out_n_1_1;
    wire valid_out_e_1_1;
    wire valid_out_s_1_1;
    wire valid_out_w_1_1;

    wire yummy_out_n_1_1;
    wire yummy_out_e_1_1;
    wire yummy_out_s_1_1;
    wire yummy_out_w_1_1;

    wire [`DATA_WIDTH-1:0] data_out_n_1_2;
    wire [`DATA_WIDTH-1:0] data_out_e_1_2;
    wire [`DATA_WIDTH-1:0] data_out_s_1_2;
    wire [`DATA_WIDTH-1:0] data_out_w_1_2;

    wire valid_out_n_1_2;
    wire valid_out_e_1_2;
    wire valid_out_s_1_2;
    wire valid_out_w_1_2;

    wire yummy_out_n_1_2;
    wire yummy_out_e_1_2;
    wire yummy_out_s_1_2;
    wire yummy_out_w_1_2;

    wire [`DATA_WIDTH-1:0] data_out_n_2_0;
    wire [`DATA_WIDTH-1:0] data_out_e_2_0;
    wire [`DATA_WIDTH-1:0] data_out_s_2_0;
    wire [`DATA_WIDTH-1:0] data_out_w_2_0;

    wire valid_out_n_2_0;
    wire valid_out_e_2_0;
    wire valid_out_s_2_0;
    wire valid_out_w_2_0;

    wire yummy_out_n_2_0;
    wire yummy_out_e_2_0;
    wire yummy_out_s_2_0;
    wire yummy_out_w_2_0;

    wire [`DATA_WIDTH-1:0] data_out_n_2_1;
    wire [`DATA_WIDTH-1:0] data_out_e_2_1;
    wire [`DATA_WIDTH-1:0] data_out_s_2_1;
    wire [`DATA_WIDTH-1:0] data_out_w_2_1;

    wire valid_out_n_2_1;
    wire valid_out_e_2_1;
    wire valid_out_s_2_1;
    wire valid_out_w_2_1;

    wire yummy_out_n_2_1;
    wire yummy_out_e_2_1;
    wire yummy_out_s_2_1;
    wire yummy_out_w_2_1;

    wire [`DATA_WIDTH-1:0] data_out_n_2_2;
    wire [`DATA_WIDTH-1:0] data_out_e_2_2;
    wire [`DATA_WIDTH-1:0] data_out_s_2_2;
    wire [`DATA_WIDTH-1:0] data_out_w_2_2;

    wire valid_out_n_2_2;
    wire valid_out_e_2_2;
    wire valid_out_s_2_2;
    wire valid_out_w_2_2;

    wire yummy_out_n_2_2;
    wire yummy_out_e_2_2;
    wire yummy_out_s_2_2;
    wire yummy_out_w_2_2;


    dynamic_node_top_wrap router_0_0(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd0),
        .myLocY(8'd0),
        .myChipID(14'd0),

        .dataIn_N(`DATA_WIDTH'b0),
        .yummyIn_N(1'b0),
        .validIn_N(1'b0),
        .dataOut_N(),
        .yummyOut_N(),
        .validOut_N(),

        .dataIn_S(data_out_n_0_1),
        .yummyIn_S(yummy_out_n_0_1),
        .validIn_S(valid_out_n_0_1),
        .dataOut_S(data_out_s_0_0),
        .yummyOut_S(yummy_out_s_0_0),
        .validOut_S(valid_out_s_0_0),

        .dataIn_W(`DATA_WIDTH'b0),
        .yummyIn_W(1'b0),
        .validIn_W(1'b0),
        .dataOut_W(),
        .yummyOut_W(),
        .validOut_W(),

        .dataIn_E(data_out_w_1_0),
        .yummyIn_E(yummy_out_w_1_0),
        .validIn_E(valid_out_w_1_0),
        .dataOut_E(data_out_e_0_0),
        .yummyOut_E(yummy_out_e_0_0),
        .validOut_E(valid_out_e_0_0),

        .dataIn_P(data_in_p_0_0),
        .yummyIn_P(yummy_in_p_0_0),
        .validIn_P(valid_in_p_0_0),
        .dataOut_P(data_out_p_0_0),
        .yummyOut_P(yummy_out_p_0_0),
        .validOut_P(valid_out_p_0_0),

        .thanksIn_P(thanks_in_p_0_0)

    );

    dynamic_node_top_wrap router_0_1(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd0),
        .myLocY(8'd1),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_0_0),
        .yummyIn_N(yummy_out_s_0_0),
        .validIn_N(valid_out_s_0_0),
        .dataOut_N(data_out_n_0_1),
        .yummyOut_N(yummy_out_n_0_1),
        .validOut_N(valid_out_n_0_1),

        .dataIn_S(data_out_n_0_2),
        .yummyIn_S(yummy_out_n_0_2),
        .validIn_S(valid_out_n_0_2),
        .dataOut_S(data_out_s_0_1),
        .yummyOut_S(yummy_out_s_0_1),
        .validOut_S(valid_out_s_0_1),

        .dataIn_W(`DATA_WIDTH'b0),
        .yummyIn_W(1'b0),
        .validIn_W(1'b0),
        .dataOut_W(),
        .yummyOut_W(),
        .validOut_W(),

        .dataIn_E(data_out_w_1_1),
        .yummyIn_E(yummy_out_w_1_1),
        .validIn_E(valid_out_w_1_1),
        .dataOut_E(data_out_e_0_1),
        .yummyOut_E(yummy_out_e_0_1),
        .validOut_E(valid_out_e_0_1),

        .dataIn_P(data_in_p_0_1),
        .yummyIn_P(yummy_in_p_0_1),
        .validIn_P(valid_in_p_0_1),
        .dataOut_P(data_out_p_0_1),
        .yummyOut_P(yummy_out_p_0_1),
        .validOut_P(valid_out_p_0_1),

        .thanksIn_P(thanks_in_p_0_1)

    );

    dynamic_node_top_wrap router_0_2(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd0),
        .myLocY(8'd2),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_0_1),
        .yummyIn_N(yummy_out_s_0_1),
        .validIn_N(valid_out_s_0_1),
        .dataOut_N(data_out_n_0_2),
        .yummyOut_N(yummy_out_n_0_2),
        .validOut_N(valid_out_n_0_2),

        .dataIn_S(`DATA_WIDTH'b0),
        .yummyIn_S(1'b0),
        .validIn_S(1'b0),
        .dataOut_S(),
        .yummyOut_S(),
        .validOut_S(),

        .dataIn_W(`DATA_WIDTH'b0),
        .yummyIn_W(1'b0),
        .validIn_W(1'b0),
        .dataOut_W(),
        .yummyOut_W(),
        .validOut_W(),

        .dataIn_E(data_out_w_1_2),
        .yummyIn_E(yummy_out_w_1_2),
        .validIn_E(valid_out_w_1_2),
        .dataOut_E(data_out_e_0_2),
        .yummyOut_E(yummy_out_e_0_2),
        .validOut_E(valid_out_e_0_2),

        .dataIn_P(data_in_p_0_2),
        .yummyIn_P(yummy_in_p_0_2),
        .validIn_P(valid_in_p_0_2),
        .dataOut_P(data_out_p_0_2),
        .yummyOut_P(yummy_out_p_0_2),
        .validOut_P(valid_out_p_0_2),

        .thanksIn_P(thanks_in_p_0_2)

    );

    dynamic_node_top_wrap router_1_0(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd1),
        .myLocY(8'd0),
        .myChipID(14'd0),

        .dataIn_N(`DATA_WIDTH'b0),
        .yummyIn_N(1'b0),
        .validIn_N(1'b0),
        .dataOut_N(),
        .yummyOut_N(),
        .validOut_N(),

        .dataIn_S(data_out_n_1_1),
        .yummyIn_S(yummy_out_n_1_1),
        .validIn_S(valid_out_n_1_1),
        .dataOut_S(data_out_s_1_0),
        .yummyOut_S(yummy_out_s_1_0),
        .validOut_S(valid_out_s_1_0),

        .dataIn_W(data_out_e_0_0),
        .yummyIn_W(yummy_out_e_0_0),
        .validIn_W(valid_out_e_0_0),
        .dataOut_W(data_out_w_1_0),
        .yummyOut_W(yummy_out_w_1_0),
        .validOut_W(valid_out_w_1_0),

        .dataIn_E(data_out_w_2_0),
        .yummyIn_E(yummy_out_w_2_0),
        .validIn_E(valid_out_w_2_0),
        .dataOut_E(data_out_e_1_0),
        .yummyOut_E(yummy_out_e_1_0),
        .validOut_E(valid_out_e_1_0),

        .dataIn_P(data_in_p_1_0),
        .yummyIn_P(yummy_in_p_1_0),
        .validIn_P(valid_in_p_1_0),
        .dataOut_P(data_out_p_1_0),
        .yummyOut_P(yummy_out_p_1_0),
        .validOut_P(valid_out_p_1_0),

        .thanksIn_P(thanks_in_p_1_0)

    );

    dynamic_node_top_wrap router_1_1(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd1),
        .myLocY(8'd1),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_1_0),
        .yummyIn_N(yummy_out_s_1_0),
        .validIn_N(valid_out_s_1_0),
        .dataOut_N(data_out_n_1_1),
        .yummyOut_N(yummy_out_n_1_1),
        .validOut_N(valid_out_n_1_1),

        .dataIn_S(data_out_n_1_2),
        .yummyIn_S(yummy_out_n_1_2),
        .validIn_S(valid_out_n_1_2),
        .dataOut_S(data_out_s_1_1),
        .yummyOut_S(yummy_out_s_1_1),
        .validOut_S(valid_out_s_1_1),

        .dataIn_W(data_out_e_0_1),
        .yummyIn_W(yummy_out_e_0_1),
        .validIn_W(valid_out_e_0_1),
        .dataOut_W(data_out_w_1_1),
        .yummyOut_W(yummy_out_w_1_1),
        .validOut_W(valid_out_w_1_1),

        .dataIn_E(data_out_w_2_1),
        .yummyIn_E(yummy_out_w_2_1),
        .validIn_E(valid_out_w_2_1),
        .dataOut_E(data_out_e_1_1),
        .yummyOut_E(yummy_out_e_1_1),
        .validOut_E(valid_out_e_1_1),

        .dataIn_P(data_in_p_1_1),
        .yummyIn_P(yummy_in_p_1_1),
        .validIn_P(valid_in_p_1_1),
        .dataOut_P(data_out_p_1_1),
        .yummyOut_P(yummy_out_p_1_1),
        .validOut_P(valid_out_p_1_1),

        .thanksIn_P(thanks_in_p_1_1)

    );

    dynamic_node_top_wrap router_1_2(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd1),
        .myLocY(8'd2),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_1_1),
        .yummyIn_N(yummy_out_s_1_1),
        .validIn_N(valid_out_s_1_1),
        .dataOut_N(data_out_n_1_2),
        .yummyOut_N(yummy_out_n_1_2),
        .validOut_N(valid_out_n_1_2),

        .dataIn_S(`DATA_WIDTH'b0),
        .yummyIn_S(1'b0),
        .validIn_S(1'b0),
        .dataOut_S(),
        .yummyOut_S(),
        .validOut_S(),

        .dataIn_W(data_out_e_0_2),
        .yummyIn_W(yummy_out_e_0_2),
        .validIn_W(valid_out_e_0_2),
        .dataOut_W(data_out_w_1_2),
        .yummyOut_W(yummy_out_w_1_2),
        .validOut_W(valid_out_w_1_2),

        .dataIn_E(data_out_w_2_2),
        .yummyIn_E(yummy_out_w_2_2),
        .validIn_E(valid_out_w_2_2),
        .dataOut_E(data_out_e_1_2),
        .yummyOut_E(yummy_out_e_1_2),
        .validOut_E(valid_out_e_1_2),

        .dataIn_P(data_in_p_1_2),
        .yummyIn_P(yummy_in_p_1_2),
        .validIn_P(valid_in_p_1_2),
        .dataOut_P(data_out_p_1_2),
        .yummyOut_P(yummy_out_p_1_2),
        .validOut_P(valid_out_p_1_2),

        .thanksIn_P(thanks_in_p_1_2)

    );

    dynamic_node_top_wrap router_2_0(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd2),
        .myLocY(8'd0),
        .myChipID(14'd0),

        .dataIn_N(`DATA_WIDTH'b0),
        .yummyIn_N(1'b0),
        .validIn_N(1'b0),
        .dataOut_N(),
        .yummyOut_N(),
        .validOut_N(),

        .dataIn_S(data_out_n_2_1),
        .yummyIn_S(yummy_out_n_2_1),
        .validIn_S(valid_out_n_2_1),
        .dataOut_S(data_out_s_2_0),
        .yummyOut_S(yummy_out_s_2_0),
        .validOut_S(valid_out_s_2_0),

        .dataIn_W(data_out_e_1_0),
        .yummyIn_W(yummy_out_e_1_0),
        .validIn_W(valid_out_e_1_0),
        .dataOut_W(data_out_w_2_0),
        .yummyOut_W(yummy_out_w_2_0),
        .validOut_W(valid_out_w_2_0),

        .dataIn_E(`DATA_WIDTH'b0),
        .yummyIn_E(1'b0),
        .validIn_E(1'b0),
        .dataOut_E(),
        .yummyOut_E(),
        .validOut_E(),

        .dataIn_P(data_in_p_2_0),
        .yummyIn_P(yummy_in_p_2_0),
        .validIn_P(valid_in_p_2_0),
        .dataOut_P(data_out_p_2_0),
        .yummyOut_P(yummy_out_p_2_0),
        .validOut_P(valid_out_p_2_0),

        .thanksIn_P(thanks_in_p_2_0)

    );

    dynamic_node_top_wrap router_2_1(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd2),
        .myLocY(8'd1),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_2_0),
        .yummyIn_N(yummy_out_s_2_0),
        .validIn_N(valid_out_s_2_0),
        .dataOut_N(data_out_n_2_1),
        .yummyOut_N(yummy_out_n_2_1),
        .validOut_N(valid_out_n_2_1),

        .dataIn_S(data_out_n_2_2),
        .yummyIn_S(yummy_out_n_2_2),
        .validIn_S(valid_out_n_2_2),
        .dataOut_S(data_out_s_2_1),
        .yummyOut_S(yummy_out_s_2_1),
        .validOut_S(valid_out_s_2_1),

        .dataIn_W(data_out_e_1_1),
        .yummyIn_W(yummy_out_e_1_1),
        .validIn_W(valid_out_e_1_1),
        .dataOut_W(data_out_w_2_1),
        .yummyOut_W(yummy_out_w_2_1),
        .validOut_W(valid_out_w_2_1),

        .dataIn_E(`DATA_WIDTH'b0),
        .yummyIn_E(1'b0),
        .validIn_E(1'b0),
        .dataOut_E(),
        .yummyOut_E(),
        .validOut_E(),

        .dataIn_P(data_in_p_2_1),
        .yummyIn_P(yummy_in_p_2_1),
        .validIn_P(valid_in_p_2_1),
        .dataOut_P(data_out_p_2_1),
        .yummyOut_P(yummy_out_p_2_1),
        .validOut_P(valid_out_p_2_1),

        .thanksIn_P(thanks_in_p_2_1)

    );

    dynamic_node_top_wrap router_2_2(
        .clk(clk),
        .reset_in(reset_in),

        .myLocX(8'd2),
        .myLocY(8'd2),
        .myChipID(14'd0),

        .dataIn_N(data_out_s_2_1),
        .yummyIn_N(yummy_out_s_2_1),
        .validIn_N(valid_out_s_2_1),
        .dataOut_N(data_out_n_2_2),
        .yummyOut_N(yummy_out_n_2_2),
        .validOut_N(valid_out_n_2_2),

        .dataIn_S(`DATA_WIDTH'b0),
        .yummyIn_S(1'b0),
        .validIn_S(1'b0),
        .dataOut_S(),
        .yummyOut_S(),
        .validOut_S(),

        .dataIn_W(data_out_e_1_2),
        .yummyIn_W(yummy_out_e_1_2),
        .validIn_W(valid_out_e_1_2),
        .dataOut_W(data_out_w_2_2),
        .yummyOut_W(yummy_out_w_2_2),
        .validOut_W(valid_out_w_2_2),

        .dataIn_E(`DATA_WIDTH'b0),
        .yummyIn_E(1'b0),
        .validIn_E(1'b0),
        .dataOut_E(),
        .yummyOut_E(),
        .validOut_E(),

        .dataIn_P(data_in_p_2_2),
        .yummyIn_P(yummy_in_p_2_2),
        .validIn_P(valid_in_p_2_2),
        .dataOut_P(data_out_p_2_2),
        .yummyOut_P(yummy_out_p_2_2),
        .validOut_P(valid_out_p_2_2),

        .thanksIn_P(thanks_in_p_2_2)

    );


    reg [3:0] sending_status_0_0;
    reg [3:0] sending_status_0_1;
    reg [3:0] sending_status_1_0;
    reg [3:0] sending_status_1_1;
    reg [3:0] sending_status_2_0;
    reg [3:0] sending_status_2_1;

    wire begin_send_0_0;
    wire begin_send_0_1;
    wire begin_send_1_0;
    wire begin_send_1_1;
    wire begin_send_2_0;
    wire begin_send_2_1;

    wire [`XY_WIDTH-1:0] dst_x_0_0;
    wire [`XY_WIDTH-1:0] dst_y_0_0;
    wire [`XY_WIDTH-1:0] dst_x_0_1;
    wire [`XY_WIDTH-1:0] dst_y_0_1;
    wire [`XY_WIDTH-1:0] dst_x_1_0;
    wire [`XY_WIDTH-1:0] dst_y_1_0;
    wire [`XY_WIDTH-1:0] dst_x_1_1;
    wire [`XY_WIDTH-1:0] dst_y_1_1;

    assign begin_send_0_0 = data_in_p_0_0[`HEADER_LEFT-1:0] == 0 & valid_in_p_0_0;
    assign begin_send_0_1 = data_in_p_0_1[`HEADER_LEFT-1:0] == 0 & valid_in_p_0_1;
    assign begin_send_1_0 = data_in_p_1_0[`HEADER_LEFT-1:0] == 0 & valid_in_p_1_0;
    assign begin_send_1_1 = data_in_p_1_1[`HEADER_LEFT-1:0] == 0 & valid_in_p_1_1;
    assign begin_send_2_0 = data_in_p_2_0[`HEADER_LEFT-1:0] == 0 & valid_in_p_2_0;
    assign begin_send_2_1 = data_in_p_2_1[`HEADER_LEFT-1:0] == 0 & valid_in_p_2_1;

    assign dst_x_0_0 = data_in_p_0_0[`DATA_WIDTH-`CHIP_ID_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH];
    assign dst_y_0_0 = data_in_p_0_0[`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH];
    assign dst_x_0_1 = data_in_p_0_1[`DATA_WIDTH-`CHIP_ID_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH];
    assign dst_y_0_1 = data_in_p_0_1[`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH];
    assign dst_x_1_0 = data_in_p_1_0[`DATA_WIDTH-`CHIP_ID_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH];
    assign dst_y_1_0 = data_in_p_1_0[`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH];
    assign dst_x_1_1 = data_in_p_1_1[`DATA_WIDTH-`CHIP_ID_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH];
    assign dst_y_1_1 = data_in_p_1_1[`DATA_WIDTH-`CHIP_ID_WIDTH-`XY_WIDTH-1:`DATA_WIDTH-`CHIP_ID_WIDTH-2*`XY_WIDTH];

    always@(*) begin
        if(!begin_send_0_0) sending_status_0_0 = 0;
        else begin
            // if(dst_x_0_0==0 & dst_y_0_0==0) sending_status_0_0 = 1;
            if(dst_x_0_0==0 & dst_y_0_0==1) sending_status_0_0 = 1;
            if(dst_x_0_0==0 & dst_y_0_0==2) sending_status_0_0 = 2;
            if(dst_x_0_0==1 & dst_y_0_0==0) sending_status_0_0 = 3;
            if(dst_x_0_0==1 & dst_y_0_0==1) sending_status_0_0 = 4;
            if(dst_x_0_0==1 & dst_y_0_0==2) sending_status_0_0 = 5;
            if(dst_x_0_0==2 & dst_y_0_0==0) sending_status_0_0 = 6;
            if(dst_x_0_0==2 & dst_y_0_0==1) sending_status_0_0 = 7;
            if(dst_x_0_0==2 & dst_y_0_0==2) sending_status_0_0 = 8;
        end
    end

    always@(*) begin
        if(!begin_send_0_1) sending_status_0_1 = 0;
        else begin
            if(dst_x_0_1==0 & dst_y_0_1==0) sending_status_0_1 = 1;
            // if(dst_x_0_1==0 & dst_y_0_1==1) sending_status_0_1 = 1;
            if(dst_x_0_1==0 & dst_y_0_1==2) sending_status_0_1 = 2;
            if(dst_x_0_1==1 & dst_y_0_1==0) sending_status_0_1 = 3;
            if(dst_x_0_1==1 & dst_y_0_1==1) sending_status_0_1 = 4;
            if(dst_x_0_1==1 & dst_y_0_1==2) sending_status_0_1 = 5;
            if(dst_x_0_1==2 & dst_y_0_1==0) sending_status_0_1 = 6;
            if(dst_x_0_1==2 & dst_y_0_1==1) sending_status_0_1 = 7;
            if(dst_x_0_1==2 & dst_y_0_1==2) sending_status_0_1 = 8;
        end
    end

    always@(*) begin
        if(!begin_send_1_0) sending_status_1_0 = 0;
        else begin
            if(dst_x_1_0==0 & dst_y_1_0==0) sending_status_1_0 = 1;
            if(dst_x_1_0==0 & dst_y_1_0==1) sending_status_1_0 = 2;
            if(dst_x_1_0==0 & dst_y_1_0==2) sending_status_1_0 = 3;
            // if(dst_x_1_0==1 & dst_y_1_0==0) sending_status_1_0 = 3;
            if(dst_x_1_0==1 & dst_y_1_0==1) sending_status_1_0 = 4;
            if(dst_x_1_0==1 & dst_y_1_0==2) sending_status_1_0 = 5;
            if(dst_x_1_0==2 & dst_y_1_0==0) sending_status_1_0 = 6;
            if(dst_x_1_0==2 & dst_y_1_0==1) sending_status_1_0 = 7;
            if(dst_x_1_0==2 & dst_y_1_0==2) sending_status_1_0 = 8;
        end
    end

    always@(*) begin
        if(!begin_send_1_1) sending_status_1_1 = 0;
        else begin
            if(dst_x_1_1==0 & dst_y_1_1==0) sending_status_1_1 = 1;
            if(dst_x_1_1==0 & dst_y_1_1==1) sending_status_1_1 = 2;
            if(dst_x_1_1==0 & dst_y_1_1==2) sending_status_1_1 = 3;
            if(dst_x_1_1==1 & dst_y_1_1==0) sending_status_1_1 = 4;
            // if(dst_x_1_1==1 & dst_y_1_1==1) sending_status_1_1 = 4;
            if(dst_x_1_1==1 & dst_y_1_1==2) sending_status_1_1 = 5;
            if(dst_x_1_1==2 & dst_y_1_1==0) sending_status_1_1 = 6;
            if(dst_x_1_1==2 & dst_y_1_1==1) sending_status_1_1 = 7;
            if(dst_x_1_1==2 & dst_y_1_1==2) sending_status_1_1 = 8;
        end
    end

    covergroup mesh_leftup4_cover @ (posedge clk);
        cp0: coverpoint sending_status_0_0 {
        bins cp0_b[]={[0:8]};
        }
        cp1: coverpoint sending_status_0_1 {
        bins cp1_b[]={[0:8]};
        }
        cp2: coverpoint sending_status_1_0 {
        bins cp2_b[]={[0:8]};
        }
        cp3: coverpoint sending_status_1_1 {
        bins cp3_b[]={[0:8]};
        }
        cross_all: cross cp0, cp1, cp2, cp3;
    endgroup
    // mesh_leftup4_cover cp_mesh_cover_1 = new();

    wire [4:0] buffer_left_0_0;
    wire [4:0] buffer_left_0_1;
    wire [4:0] buffer_left_1_0;
    wire [4:0] buffer_left_1_1;
    assign buffer_left_0_0 = router_0_0.dynamic_node_top.proc_input.NIB.elements_in_array_f;
    assign buffer_left_0_1 = router_0_1.dynamic_node_top.proc_input.NIB.elements_in_array_f;
    assign buffer_left_1_0 = router_1_0.dynamic_node_top.proc_input.NIB.elements_in_array_f;
    assign buffer_left_1_1 = router_1_1.dynamic_node_top.proc_input.NIB.elements_in_array_f;

    // proc port start to send at different buffer left
    // covergroup mesh_leftup4_buffer_cover @ (posedge clk);
    //     cp0: coverpoint buffer_left_0_0 iff(begin_send_0_0) {
    //         bins zero = {0};
    //         bins one = {1};
    //         bins two = {2};
    //         bins r_3_4 = {[3:4]};
    //         bins r_5_8 = {[5:8]};
    //         bins r_9_15 = {[9:15]};
    //         bins max = {16};
    //     }
    //     cp1: coverpoint buffer_left_0_1 iff(begin_send_0_1) {
    //         bins zero = {0};
    //         bins one = {1};
    //         bins two = {2};
    //         bins r_3_4 = {[3:4]};
    //         bins r_5_8 = {[5:8]};
    //         bins r_9_15 = {[9:15]};
    //         bins max = {16};
    //     }
    //     cp2: coverpoint buffer_left_1_0 iff(begin_send_1_0) {
    //         bins zero = {0};
    //         bins one = {1};
    //         bins two = {2};
    //         bins r_3_4 = {[3:4]};
    //         bins r_5_8 = {[5:8]};
    //         bins r_9_15 = {[9:15]};
    //         bins max = {16};
    //     }
    //     cp3: coverpoint buffer_left_1_1 iff(begin_send_1_1) {
    //         bins zero = {0};
    //         bins one = {1};
    //         bins two = {2};
    //         bins r_3_4 = {[3:4]};
    //         bins r_5_8 = {[5:8]};
    //         bins r_9_15 = {[9:15]};
    //         bins max = {16};
    //     }
    //     cross_all: cross cp0, cp1, cp2, cp3;
    // endgroup

    covergroup mesh_leftup4_buffer_cover @ (posedge clk);
        cp0: coverpoint buffer_left_0_0{
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins r_3_4 = {[3:4]};
            bins r_5_8 = {[5:8]};
            bins r_9_15 = {[9:15]};
            bins max = {16};
        }
        cp1: coverpoint buffer_left_0_1{
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins r_3_4 = {[3:4]};
            bins r_5_8 = {[5:8]};
            bins r_9_15 = {[9:15]};
            bins max = {16};
        }
        cp2: coverpoint buffer_left_1_0{
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins r_3_4 = {[3:4]};
            bins r_5_8 = {[5:8]};
            bins r_9_15 = {[9:15]};
            bins max = {16};
        }
        cp3: coverpoint buffer_left_1_1{
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins r_3_4 = {[3:4]};
            bins r_5_8 = {[5:8]};
            bins r_9_15 = {[9:15]};
            bins max = {16};
        }
        cross_all: cross cp0, cp1, cp2, cp3;
    endgroup

    mesh_leftup4_buffer_cover cp_mesh_cover_2 = new();

endmodule

