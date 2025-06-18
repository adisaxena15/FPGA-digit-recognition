`timescale 1ns / 1ps

module top_level (
    input  logic clk_100MHz,
    input  logic btn_photo,
    input  logic vsync,
    input  logic hsync,
    input  logic pclk,
    input  logic [7:0] data,
    input  logic btn_read,

    output logic xclk,
    output logic reset,
    output logic pwdn,
    output logic [7:0] hex_seg_left,
    output logic [3:0] hex_grid_left,
    output logic [7:0] hex_seg_right,
    output logic [3:0] hex_grid_right,
    output logic [15:0] LED
);
    logic [15:0] bram_display;
    logic [9:0] bram_addr;
    logic [15:0] bram_din;
    logic bram_en;
    logic bram_we;

    logic bram_read_select;

    logic clk_24MHz;
    logic clk_locked;
    assign xclk = clk_24MHz;
    assign reset = 1'b1;
    assign pwdn = 1'b0;

    logic [9:0] bram_addr_cam;
    logic [15:0] bram_din_cam;
    logic bram_en_cam;
    logic bram_we_cam;
    logic [15:0] bram_dout;

    logic [9:0] read_addr;
    logic [9:0] non_zero_count;

    logic frame_done;
    logic take_photo;
    logic read_start;

    logic [15:0] latched_pixel;
    logic [15:0] data_display_value;
    logic [3:0] pixel_nibbles[4];
    logic [15:0] count_extend;
    logic [3:0] count_nibbles[4];

    logic [23:0] pclk_counter = 0;
    logic pclk_slow = 0;
    logic photo_taken;

    always_comb begin
        bram_din  = bram_din_cam;
        bram_addr = bram_addr_cam;
        bram_en   = bram_en_cam;
        bram_we   = bram_we_cam;

        if (bram_read_select== 1'b1) begin
            bram_addr = read_addr;
            bram_en   = 1'b1;
            bram_we   = 1'b0;
        end
    end

    assign data_display_value = latched_pixel;
    assign pixel_nibbles[3] = data_display_value[3:0];
    assign pixel_nibbles[2] = data_display_value[7:4];
    assign pixel_nibbles[1] = data_display_value[11:8];
    assign pixel_nibbles[0] = data_display_value[15:12];

    assign count_extend = bram_display;
    assign count_nibbles[3] = count_extend[3:0];
    assign count_nibbles[2] = count_extend[7:4];
    assign count_nibbles[1] = count_extend[11:8];
    assign count_nibbles[0] = count_extend[15:12];

    assign LED[0] = pclk_slow;
    assign LED[1] = frame_done;
    assign LED[3] = bram_read_select;
    assign LED[15:6] = bram_addr;

    always_ff @(posedge pclk) begin
        pclk_counter <= pclk_counter + 1;
        if (pclk_counter == 24'd10_000_000) begin
            pclk_counter <= 0;
            latched_pixel <= bram_din_cam;
            pclk_slow <= ~pclk_slow;
        end
    end

    sync_debounce photo_debounce_1 (
        .clk(clk_100MHz),
        .d(btn_photo),
        .q(take_photo)
    );

    sync_debounce photo_debounce_2 (
        .clk(clk_100MHz),
        .d(btn_read),
        .q(read_start)
    );

    blk_mem_gen_0 image_bram (
        .clka(clk_24MHz),
        .ena(bram_en),
        .wea(bram_we),
        .addra(bram_addr),
        .dina(bram_din),
        .douta(bram_dout)
    );

    clk_wiz_0 clk_gen (
        .clk_out1(clk_24MHz),
        .reset(1'b0),
        .locked(clk_locked),
        .clk_in1(clk_100MHz)
    );

    camera_module cam_inst (
        .data(data),
        .pclk(pclk),
        .hsync(hsync),
        .vsync(vsync),
        .take_photo(take_photo),
        .frame_done(frame_done),
        .bram_addr_cam(bram_addr_cam),
        .bram_din_cam(bram_din_cam),
        .bram_dout(bram_dout),
        .bram_en_cam(bram_en_cam),
        .bram_we_cam(bram_we_cam)
    );

    hex_driver hex_pixel_left (
        .clk(clk_100MHz),
        .reset(1'b0),
        .in(pixel_nibbles),
        .hex_seg(hex_seg_left),
        .hex_grid(hex_grid_left)
    );

    hex_driver hex_pixel_right (
        .clk(clk_100MHz),
        .reset(1'b0),
        .in(count_nibbles),
        .hex_seg(hex_seg_right),
        .hex_grid(hex_grid_right)
    );

    photo_control_fsm photo_fsm (
        .clk(clk_100MHz),
        .take_photo(take_photo),
        .frame_done(frame_done),
        .photo_taken(photo_taken),
        .read_start(read_start),
        .bram_dout(bram_dout),
        .bram_addr_debug(read_addr),
        .non_zero_count(non_zero_count),
        .bram_read_select(bram_read_select),
        .bram_display(bram_display)
    );

endmodule
