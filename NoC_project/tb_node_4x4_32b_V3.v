`include "node_4x4_32b.v"

module tb_node_4x4_32b;
    
    reg clk;

    parameter NUM_of_NODES = 16;
    parameter NUM_INOUT = 4;
    parameter NUM_of_LINES = 4;
    parameter NUM_of_NODES_per_LINE = NUM_of_NODES / NUM_of_LINES;
    parameter DATA_WIDTH = 32;
    parameter ADDRESS_WIDTH = 5;

    reg [ADDRESS_WIDTH - 1:0] in_addr_1_0 = 0;
    reg [DATA_WIDTH -1:0] in_data_1_0 = 0;
    reg in_valid_1_0 = 0;

    wire [ADDRESS_WIDTH - 1:0] in_addr [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire [DATA_WIDTH - 1 : 0] in_data [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire in_valid [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire to_in_ack [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire [ADDRESS_WIDTH - 1:0] out_addr [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire [DATA_WIDTH - 1 : 0] out_data [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire out_valid [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];
    wire from_out_ack [NUM_of_LINES - 1: 0] [NUM_of_NODES_per_LINE - 1 : 0] [NUM_INOUT - 1 : 0];


    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,tb_node_4x4_32b);
    end

    initial begin
        clk = 1;

        in_addr_1_0 = 0;
        in_data_1_0 = 0;
        in_valid_1_0 = 0;

        #10;
        in_addr_1_0 = 4;
        in_data_1_0 = 4;
        in_valid_1_0 = 1;

        #10;
        in_addr_1_0 = 0;
        in_data_1_0 = 0;
        in_valid_1_0 = 0;

        #30 $finish;
    end

    always begin
        #5 clk = ~clk;
    end


    //always @(*) begin
    assign in_addr[0][0][0] = in_addr_1_0;
    assign in_data[0][0][0] = in_data_1_0;
    assign in_valid[0][0][0] = in_valid_1_0;
    //end
    
    genvar i;
    genvar j;
    
    generate
        //Number of Node Lines
        //for 32*4*16 = 2048, inceremnt, for 4 lines, by 512
        for (i = 0; i < NUM_of_LINES; i = i + 1 ) begin
            for (j = 0; j < NUM_of_NODES_per_LINE; j = j + 1) begin // DEBUGGING, chnage back to prev value

                //wire [31:0] id; // Change wire or reg depending on your use case
                localparam id = i * NUM_of_NODES_per_LINE + j;
                
                
                // First line will have upper ports (port 2) connect to free wires
                if ( i == 0) begin
                    // first node/left node (port 1) will connect connect to free wires
                    if ( j == 0 ) begin
                        
                        node_4x4_32b #(.ID( id )) NoC_Node (
                            .clk(clk),

                            .in_addr_1( in_addr[ i ] [ j ] [ 0 ] ),
                            .in_data_1( in_data[ i ] [ j ] [ 0 ] ),
                            .in_valid_1( in_valid[ i ] [ j ] [ 0 ] ),
                            .to_in_ack_1( to_in_ack[ i ] [ j ] [ 0 ] ),
                            .out_addr_1(out_addr[ i ] [ j ] [ 0 ] ),
                            .out_data_1(out_data[ i ] [ j ] [ 0 ]),
                            .out_valid_1( out_valid[ i ] [ j ] [ 0 ] ),
                            .from_out_ack_1( from_out_ack[ i ] [ j ] [ 0 ] ),

                            .in_addr_2( in_addr[ i ] [ j ] [ 1 ] ),
                            .in_data_2( in_data[ i ] [ j ] [ 1 ] ),
                            .in_valid_2( in_valid[ i ] [ j ] [ 1 ] ),
                            .to_in_ack_2( to_in_ack[ i ] [ j ] [ 1 ] ),
                            .out_addr_2(out_addr[ i ] [ j ] [ 1 ] ),
                            .out_data_2(out_data[ i ] [ j ] [ 1 ]),
                            .out_valid_2( out_valid[ i ] [ j ] [ 1 ] ),
                            .from_out_ack_2( from_out_ack[ i ] [ j ] [ 1 ] ),

                            .in_addr_3( in_addr[ i ] [ j ] [ 2 ] ),
                            .in_data_3( in_data[ i ] [ j ] [ 2 ] ),
                            .in_valid_3( in_valid[ i ] [ j ] [ 2 ] ),
                            .to_in_ack_3( to_in_ack[ i ] [ j ] [ 2 ] ),
                            .out_addr_3(out_addr[ i ] [ j ] [ 2 ] ),
                            .out_data_3(out_data[ i ] [ j ] [ 2 ]),
                            .out_valid_3( out_valid[ i ] [ j ] [ 2 ] ),
                            .from_out_ack_3( from_out_ack[ i ] [ j ] [ 2 ] ),

                            .in_addr_4( in_addr[ i ] [ j ] [ 3 ] ),
                            .in_data_4( in_data[ i ] [ j ] [ 3 ] ),
                            .in_valid_4( in_valid[ i ] [ j ] [ 3 ] ),
                            .to_in_ack_4( to_in_ack[ i ] [ j ] [ 3 ] ),
                            .out_addr_4(out_addr[ i ] [ j ] [ 3 ] ),
                            .out_data_4(out_data[ i ] [ j ] [ 3 ]),
                            .out_valid_4( out_valid[ i ] [ j ] [ 3 ] ),
                            .from_out_ack_4( from_out_ack[ i ] [ j ] [ 3 ] )
                        );
                    // The rest nodes will have the first/left ports (port 1) connect to the output port (port 3) of the node to the left
                    end else begin
                        node_4x4_32b #( .ID( id ) ) NoC_Node
                        (
                            .clk(clk),

                            .in_addr_1( out_addr[ i ] [ j-1 ] [ 2 ] ),
                            .in_data_1( out_data[ i ] [ j-1 ] [ 2 ] ),
                            .in_valid_1( out_valid[ i ] [ j-1 ] [ 2 ] ),
                            .to_in_ack_1( from_out_ack[ i ] [ j-1 ] [ 2 ] ),
                            .out_addr_1(out_addr[ i ] [ j ] [ 0 ] ),
                            .out_data_1(out_data[ i ] [ j ] [ 0 ]),
                            .out_valid_1( out_valid[ i ] [ j ] [ 0 ] ),
                            .from_out_ack_1( from_out_ack[ i ] [ j ] [ 0 ] ),

                            .in_addr_2( in_addr[ i ] [ j ] [ 1 ] ),
                            .in_data_2( in_data[ i ] [ j ] [ 1 ] ),
                            .in_valid_2( in_valid[ i ] [ j ] [ 1 ] ),
                            .to_in_ack_2( to_in_ack[ i ] [ j ] [ 1 ] ),
                            .out_addr_2(out_addr[ i ] [ j ] [ 1 ] ),
                            .out_data_2(out_data[ i ] [ j ] [ 1 ]),
                            .out_valid_2( out_valid[ i ] [ j ] [ 1 ] ),
                            .from_out_ack_2( from_out_ack[ i ] [ j ] [ 1 ] ),

                            .in_addr_3( in_addr[ i ] [ j ] [ 2 ] ),
                            .in_data_3( in_data[ i ] [ j ] [ 2 ] ),
                            .in_valid_3( in_valid[ i ] [ j ] [ 2 ] ),
                            .to_in_ack_3( to_in_ack[ i ] [ j ] [ 2 ] ),
                            .out_addr_3(out_addr[ i ] [ j ] [ 2 ] ),
                            .out_data_3(out_data[ i ] [ j ] [ 2 ]),
                            .out_valid_3( out_valid[ i ] [ j ] [ 2 ] ),
                            .from_out_ack_3( from_out_ack[ i ] [ j ] [ 2 ] ),

                            .in_addr_4( in_addr[ i ] [ j ] [ 3 ] ),
                            .in_data_4( in_data[ i ] [ j ] [ 3 ] ),
                            .in_valid_4( in_valid[ i ] [ j ] [ 3 ] ),
                            .to_in_ack_4( to_in_ack[ i ] [ j ] [ 3 ] ),
                            .out_addr_4(out_addr[ i ] [ j ] [ 3 ] ),
                            .out_data_4(out_data[ i ] [ j ] [ 3 ]),
                            .out_valid_4( out_valid[ i ] [ j ] [ 3 ] ),
                            .from_out_ack_4( from_out_ack[ i ] [ j ] [ 3 ] )
                        );
                    end
                
                end/* else begin
                    //FILL IN THE REST OF THE MESH LINES
                end*/
                    

                //id = id + 1;
            end
        end
    endgenerate

/*
    genvar i;

    integer i_adr;
    integer j_adr;
    real _i_adr;
    real _j_adr;
    integer scale_factor = 10; // Scale factor to work with fixed-point arithmetic
    integer scaled_divisor = scale_factor * 6.4; // Equivalent to 64

    integer i_sing;
    integer j_sing;

    integer id = 0;

    generate
        //Number of Node Lines
        //for 32*4*16 = 2048, inceremnt, for 4 lines, by 512
        for (i = 0; i < (NUM_of_NODES * NUM_INOUT * 32); i = i + (NUM_of_NODES * NUM_INOUT * 32)/NUM_of_LINES ) begin
            for (j = 0; j <(NUM_of_NODES * NUM_INOUT * 32)/NUM_of_LINES; j = j + (NUM_of_NODES * NUM_INOUT * 32)/NUM_of_LINES/NUM_INOUT) begin

                _i_adr = i * scale_factor / scaled_divisor;
                _j_adr = j * scale_factor / scaled_divisor;
                i_adr = _i_adr;
                j_adr = _j_adr;

                i_sing = i / 32;
                j_sing = j / 32;

                node_4x4_32b #( .ID( [ id ] ) ) Node_
                (
                    .clk(clk),

                    .in_addr_1( in_addr[ i_adr + j_adr + ADRESS_WIDTH-1 : i_adr + j_adr ] ),
                    .in_data_1( in_data[ i + j + DATA_WIDTH-1 : i + j ] ),
                    .in_valid_1( in_valid[ i_sing + j_sing + 1 : i_sing + j_sing ] ),
                    .to_in_ack_1( to_in_ack[i_sing + j_sing + 1 : i_sing + j_sing] ),
                    .out_addr_1(out_addr[ i_adr + j_adr + ADRESS_WIDTH-1 : i_adr + j_adr ] ),
                    .out_data_1(out_data[ i + j + DATA_WIDTH-1 : i + j  ]),
                    .out_valid_1( out_valid[ i_sing + j_sing + 1 : i_sing + j_sing ] ),
                    .from_out_ack_1( from_out_ack[ i_sing + j_sing + 1 : i_sing + j_sing ] ),

                    .in_addr_2( in_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 1*ADRESS_WIDTH : i_adr + j_adr  + 1*ADRESS_WIDTH ] ),
                    .in_data_2( in_data[ i + j + DATA_WIDTH-1  + 1*DATA_WIDTH : i + j  + 1*DATA_WIDTH ] ),
                    .in_valid_2( in_valid[ i_sing + j_sing + 1  + 1 : i_sing + j_sing  + 1 ] ),
                    .to_in_ack_2( to_in_ack[i_sing + j_sing + 1  + 1 : i_sing + j_sing  + 1 ] ),
                    .out_addr_2(out_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 1*ADRESS_WIDTH : i_adr + j_adr  + 1*ADRESS_WIDTH ] ),
                    .out_data_2(out_data[ i + j + DATA_WIDTH-1  + 1*DATA_WIDTH : i + j  + 1*DATA_WIDTH ]),
                    .out_valid_2( out_valid[ i_sing + j_sing + 1  + 1 : i_sing + j_sing  + 1 ] ),
                    .from_out_ack_2( from_out_ack[ i_sing + j_sing + 1  + 1 : i_sing + j_sing  + 1 ] ),

                    .in_addr_3( in_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 2*ADRESS_WIDTH : i_adr + j_adr  + 2*ADRESS_WIDTH ] ),
                    .in_data_3( in_data[ i + j + DATA_WIDTH-1  + 2*DATA_WIDTH : i + j  + 2*DATA_WIDTH ] ),
                    .in_valid_3( in_valid[ i_sing + j_sing + 1  + 2 : i_sing + j_sing  + 2 ] ),
                    .to_in_ack_3( to_in_ack[i_sing + j_sing + 1  + 2 : i_sing + j_sing  + 2 ] ),
                    .out_addr_3(out_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 2*ADRESS_WIDTH : i_adr + j_adr  + 2*ADRESS_WIDTH ] ),
                    .out_data_3(out_data[ i + j + DATA_WIDTH-1  + 2*DATA_WIDTH : i + j  + 2*DATA_WIDTH ]),
                    .out_valid_3( out_valid[ i_sing + j_sing + 1  + 2 : i_sing + j_sing  + 2 ] ),
                    .from_out_ack_3( from_out_ack[ i_sing + j_sing + 1  + 2 : i_sing + j_sing  + 2 ] ),

                    .in_addr_4( in_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 3*ADRESS_WIDTH : i_adr + j_adr  + 3*ADRESS_WIDTH ] ),
                    .in_data_4( in_data[ i + j + DATA_WIDTH-1  + 3*DATA_WIDTH : i + j  + 3*DATA_WIDTH ] ),
                    .in_valid_4( in_valid[ i_sing + j_sing + 1  + 3 : i_sing + j_sing  + 3 ] ),
                    .to_in_ack_4( to_in_ack[i_sing + j_sing + 1  + 3 : i_sing + j_sing  + 3 ] ),
                    .out_addr_4(out_addr[ i_adr + j_adr + ADRESS_WIDTH-1  + 3*ADRESS_WIDTH : i_adr + j_adr  + 3*ADRESS_WIDTH ] ),
                    .out_data_4(out_data[ i + j + DATA_WIDTH-1  + 3*DATA_WIDTH : i + j  + 3*DATA_WIDTH ]),
                    .out_valid_4( out_valid[ i_sing + j_sing + 1  + 3 : i_sing + j_sing  + 3 ] ),
                    .from_out_ack_4( from_out_ack[ i_sing + j_sing + 1  + 3 : i_sing + j_sing  + 3 ] )
                );


                id = id + 1;
            end
        end
    endgenerate
*/
endmodule
