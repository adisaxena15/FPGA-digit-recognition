module final_project_tb(); //even though the testbench doesn't create any hardware, it still needs to be a module

timeunit 10ns;  // This is the amount of time represented by #1 
timeprecision 1ns;


logic clk;
logic btn_photo;
logic vsync, hsync, pclk;
logic [7:0] data;
logic [7:0] hex_seg;
logic [3:0] hex_grid;

logic clk_100MHz;
logic xclk;
logic reset;
logic pwdn;

top_level dut (
    .clk_100MHz(clk_100MHz),
    .btn_photo(btn_photo),
    .vsync(vsync),
    .hsync(hsync),
    .pclk(pclk),
    .data(data),
    .xclk(xclk),
    .reset(reset),
    .pwdn(pwdn),
    .hex_seg(hex_seg),
    .hex_grid(hex_grid)
);

initial begin
    clk = 1;
    clk_100MHz = 1'b1;
end

always #1 clk = ~clk;
always #1 clk_100MHz = ~clk_100MHz;
always #2 pclk = ~pclk;

initial begin
    btn_photo = 0;
    vsync = 0;
    hsync = 0;
    pclk = 0;
    data = 0;

    #20;
    btn_photo = 1;  // simulate pressing the button
    #20;
    btn_photo = 0;

    // simulate 10 pixels of data (5 pixels × 2 bytes per pixel)
    repeat (10) begin
        hsync = 1;
        data = 8'h55; @(posedge pclk);
        data = 8'hAA; @(posedge pclk);
    end
    hsync = 0;

    // simulate end of frame
    #20;
    vsync = 1;
    #20;
    vsync = 0;

    #100;
    $finish();
end

endmodule
