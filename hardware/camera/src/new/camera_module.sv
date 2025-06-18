module camera_module (
    input  logic [7:0] data,
    input  logic vsync,
    input  logic hsync,
    input  logic pclk,
    input  logic take_photo,

    output logic [9:0] bram_addr_cam,
    output logic [15:0] bram_din_cam,
    input  logic [15:0] bram_dout,
    output logic bram_en_cam,
    output logic bram_we_cam,
    output logic frame_done
    //output logic [9:0] drawX_max
);

    localparam OUT_W = 28;
    localparam OUT_H = 28;
    
    logic p_state;
    logic [15:0] populated_data;
    logic photo_active;
    
    logic [9:0] drawX, drawY; //0 to 639 and 0 to 479
    logic [4:0] sectionX, sectionY; //0 to 27
    logic [9:0] pixel_addr;
    
    logic [15:0] old_avg;
    logic [9:0] count;
    logic [15:0] new_avg;
    
    logic take_photo_prev;
    logic [9:0] pixel_count [0:783];
    always_ff @(posedge pclk or posedge vsync) begin
    if(vsync) begin
        photo_active <= take_photo;
    end
    end
    
    /*
    logic [9:0] drawX_max_internal;

    always_ff @(posedge pclk) begin
        if (photo_active && drawX > drawX_max_internal) begin
            drawX_max_internal <= drawX;
        end
    end
    
    assign drawX_max = drawX_max_internal;
    */

    always_ff @(posedge pclk or posedge vsync) begin
        if(vsync) begin
        //reset all variables
            p_state <=0;
            drawX <= 0;
            drawY <= 0;
            //frame_done <=0;
        end
        
        else if (hsync && photo_active) begin
            if(p_state == 0) begin
                populated_data[7:0] <= data;
                p_state <= 1;
            end
            else begin
                populated_data[15:8] <= data;
                p_state <=0;
                
                sectionX <= drawX>>5;
                sectionY <= drawY>>4;
                
                pixel_addr <= (drawY >> 4) *OUT_W + (drawX >> 5);
                
                old_avg <= bram_dout;
                count <= pixel_count[pixel_addr];
                new_avg = ((old_avg *count) + populated_data) / (count+1);
                
                bram_addr_cam <= pixel_addr;
                bram_din_cam <= new_avg;
                bram_en_cam <= 1;
                bram_we_cam <= 1;
                pixel_count[pixel_addr] <= count+1;
                
                //boundary conditions
                if(drawX == 400 && drawY == 400) begin
                    frame_done <= 1;
                end
                
                if(drawX == 639 && drawY!=479) begin
                    drawX <=0;
                    sectionX<= 0;
                    drawY <= drawY + 1;
                    sectionY <= sectionY + 1;
                end
                else if((drawX+1) % 22 == 0) begin
                    drawX <= drawX + 1;
                    sectionX <= sectionX + 1;
                end else begin
                    drawX <= drawX + 1;
                    end
            end
        end else begin
        bram_en_cam <= 0;
        bram_we_cam <= 0;
    end
end
endmodule