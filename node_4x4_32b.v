module node_4x4_32b #(
    parameter ID = 0
)
(
    input clk,
    input rst,

    input [7:0] in_addr_1,
    input [31:0] in_data_1,
    input in_valid_1,
    output reg to_in_ack_1,
    output reg [7:0] out_addr_1,
    output reg [31:0] out_data_1,
    output reg out_valid_1,
    input from_out_ack_1,

    input [7:0] in_addr_2,
    input [31:0] in_data_2,
    input in_valid_2,
    output reg to_in_ack_2,
    output reg [7:0] out_addr_2,
    output reg [31:0] out_data_2,
    output reg out_valid_2,
    input from_out_ack_2,

    input [7:0] in_addr_3,
    input [31:0] in_data_3,
    input in_valid_3,
    output reg to_in_ack_3,
    output reg [7:0] out_addr_3,
    output reg [31:0] out_data_3,
    output reg out_valid_3,
    input from_out_ack_3,

    input [7:0] in_addr_4,
    input [31:0] in_data_4,
    input in_valid_4,
    output reg to_in_ack_4,
    output reg [7:0] out_addr_4,
    output reg [31:0] out_data_4,
    output reg out_valid_4,
    input from_out_ack_4
);

    reg [1:0] input_sel;

    reg [5:0] col_coord;
    reg [5:0] row_coord;

    reg [31:0] data_buffer;
    reg [7:0] addr_buffer;

    reg [31:0] id_map[15:0];
    initial begin
        id_map[0] = 32'd7; id_map[1] = 32'd8; id_map[2] = 32'd9; id_map[3] = 32'd10;
        id_map[4] = 32'd13; id_map[5] = 32'd14; id_map[6] = 32'd15; id_map[7] = 32'd16;
        id_map[8] = 32'd19; id_map[9] = 32'd20; id_map[10] = 32'd21; id_map[11] = 32'd22;
        id_map[12] = 32'd25; id_map[13] = 32'd26; id_map[14] = 32'd27; id_map[15] = 32'd28;
    end

    reg [5:0] id_x_coord;
    reg [5:0] id_y_coord;

    wire [31:0] E = id_map[3];
    wire [31:0] E_1 = id_map[3] % 6;
    //Initialise
    initial begin
        input_sel <= 0;

        //col_coord <= ID % 4;
        //row_coord <= ID / 4;

        col_coord <= id_map[ID] % 6;
        row_coord <= id_map[ID] / 6;
    end



    //Arbitration
    always @(*) begin
        if ( in_valid_1 && in_valid_2 && in_valid_4 && in_valid_4 ) begin
            input_sel = input_sel + 1;
        end else if ( in_valid_1 == 1 ) begin
            input_sel = 0;
        end else if ( in_valid_2 == 1 ) begin
            input_sel = 1;
        end else if ( in_valid_3 == 1 ) begin
            input_sel = 2;
        end else if ( in_valid_4 == 1 ) begin
            input_sel = 3;
        end else begin
            input_sel = 0;
        end
    end

    //Buffer Load, Set ACK
    always @(posedge clk) begin
        if ( out_valid_1 == 0 && out_valid_2 == 0 && out_valid_3 == 0 && out_valid_4 == 0 ) begin
            if (input_sel == 0 && in_valid_1 == 1) begin
                data_buffer <= in_data_1;
                addr_buffer <= in_addr_1;
                to_in_ack_1 <= 1;
            end else if (input_sel == 1 && in_valid_2 == 1) begin
                data_buffer <= in_data_2;
                addr_buffer <= in_addr_2;
                to_in_ack_2 <= 1;
            end else if (input_sel == 2 && in_valid_3 == 1) begin
                data_buffer <= in_data_3;
                addr_buffer <= in_addr_3;
                to_in_ack_3 <= 1;
            end else if (input_sel == 3 && in_valid_4 == 1) begin
                data_buffer <= in_data_4;
                addr_buffer <= in_addr_4;
                to_in_ack_4 <= 1;
            end
        end
    end


    //ACK reset
    always @(posedge clk) begin
        if (to_in_ack_1) begin
            to_in_ack_1 <= 0;
        end else if (to_in_ack_2) begin
            to_in_ack_2 <= 0;
        end else if (to_in_ack_3) begin
            to_in_ack_3 <= 0;
        end else if (to_in_ack_4) begin
            to_in_ack_4 <= 0;
        end
    end


    //Output assignment
    always @(*) begin
        out_data_1 = 0;
        out_data_2 = 0;
        out_data_3 = 0;
        out_data_4 = 0;

        out_addr_1 = 0;
        out_addr_2 = 0;
        out_addr_3 = 0;
        out_addr_4 = 0;

        out_valid_1 = 0;
        out_valid_2 = 0;
        out_valid_3 = 0;
        out_valid_4 = 0;

        id_x_coord = addr_buffer / 6;
        id_y_coord = addr_buffer % 6;

        if (id_y_coord > col_coord) begin
            out_data_3 = data_buffer;
            out_addr_3 = addr_buffer;
            out_valid_3 = 1;
        end else if (id_y_coord < col_coord) begin
            out_data_1 = data_buffer;
            out_addr_1 = addr_buffer;
            out_valid_1 = 1;
        end else if (id_x_coord > row_coord) begin
            out_data_4 = data_buffer;
            out_addr_4 = addr_buffer;
            out_valid_4 = 1;
        end else if (id_x_coord < row_coord) begin
            out_data_2 = data_buffer;
            out_addr_2 = addr_buffer;
            out_valid_2 = 1;
        end
    end

    //Recieve ACK and reset ou_valid signal
    always @(*) begin
        if (from_out_ack_1) begin
            out_valid_1 = 0;
        end else if (from_out_ack_2) begin
            out_valid_2 = 0;
        end else if (from_out_ack_3) begin
            out_valid_3 = 0;
        end else if (from_out_ack_4) begin
            out_valid_4 = 0;
        end
    end 

    
endmodule