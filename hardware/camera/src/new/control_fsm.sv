module photo_control_fsm (
    input logic clk,
    input logic take_photo,
    input logic frame_done,
    output logic photo_taken,
    
    output logic [9:0] bram_addr_clear,
    output logic [15:0] bram_din_clear,
    output logic bram_we_clear,
    output logic bram_en_clear,
    
    input logic read_start,
    input logic [15:0] bram_dout,
    output logic [9:0] bram_addr_debug,
    output logic [9:0] non_zero_count,
    //output logic [1:0] bram_mode,
    output logic [15:0] bram_display,
    
    output logic done_state,
    output logic bram_write_select, // 1 for clear | 0 for write
    output logic bram_read_select //1 for reading | 0 for now
);

    typedef enum logic [2:0] {
        IDLE,
        INIT,
        WAIT_PHOTO,
        CLEAR,
        CAPTURE
    } state_t;

    state_t state = IDLE;
    
    typedef enum logic [2:0] {
        R_IDLE,
        R_READ,
        R_WAIT,
        R_LATCH,
        R_CHECK,
        R_DONE
    } read_state_t;
    
    read_state_t rstate = R_IDLE;
    
    logic [9:0] read_addr;
    logic [9:0] clear_addr;
    
    always_ff @(posedge clk) begin
        case (state)
            IDLE: state <= INIT;

            INIT: begin
                photo_taken <= 0;
                clear_addr <= 0;
                bram_en_clear <= 0;
                bram_we_clear <= 0;
                done_state <= 1'b0;
                bram_din_clear <= 0;
                bram_addr_clear <= 0;
                bram_write_select <= 1'b1;
                state <= WAIT_PHOTO;
            end

            WAIT_PHOTO: begin
                if (take_photo) begin
                    photo_taken <= 1;
                    clear_addr <= 0;
                    bram_write_select <= 1'b0;
                    state <= CLEAR;
                end
            end
            CLEAR: begin
                bram_addr_clear <= clear_addr;
                bram_din_clear <= 16'b0;
                
                if(clear_addr == 10'd783) begin
                    bram_en_clear <= 0;
                    bram_we_clear <= 0;
                    done_state <= 1'b1;
                    bram_write_select <= 1'b1;
                    state <= CAPTURE;
                end else begin
                    bram_en_clear <= 1;
                    bram_we_clear <= 1;
                    clear_addr <= clear_addr + 1;
                end
            end
            CAPTURE: begin
                if (frame_done) begin
                    state <= WAIT_PHOTO;
                end
            end
        endcase
    end
    
  logic [15:0] bram_data_latched;
  logic read_start_prev;
  logic read_start_pulse;
    
    
    always_ff @(posedge clk) begin
        read_start_prev <= read_start;
        read_start_pulse <= read_start & ~read_start_prev;
    end
    
    always_ff @(posedge clk) begin

        case (rstate)
            R_IDLE: begin
                if (read_start_pulse) begin
                    read_addr <= 0;
                    non_zero_count <= 0;
                    bram_read_select <= 1'b1;
                    bram_addr_debug <= 0;
                    bram_data_latched <= 0;
                    bram_display <=0;
                    rstate <= R_READ;
                end
            end
    
            R_READ: begin
                bram_addr_debug <= read_addr;
                rstate <= R_LATCH;
            end
    
            R_WAIT: begin
                if (read_start_pulse) begin
                    rstate <= R_CHECK;
                end
            end
            
            R_LATCH: begin
                bram_data_latched <= bram_dout;
                rstate <= R_WAIT;
            end

           R_CHECK: begin
                   bram_display <= bram_data_latched;
                if (bram_data_latched != 0)
                    non_zero_count <= non_zero_count + 1;
            
                if (read_addr == 10'd783) begin
                    bram_read_select <= 1'b0;
                    rstate <= R_IDLE; end
                else begin
                    read_addr <= read_addr + 1;
                    rstate <= R_READ;
                end
            end
           
        endcase
    end

endmodule