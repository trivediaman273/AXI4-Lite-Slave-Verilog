module axi4_lite(input wire ACLK ,input wire ARESETN , input wire [31:0] AWADDR , input wire AWVALID ,
output reg AWREADY , input wire [31:0] WDATA , input wire WVALID , output reg WREADY , output reg [1:0] BRESP,
input wire BREADY ,output reg BVALID ,input wire [31:0] ARADDR , input wire ARVALID ,output reg ARREADY
, output reg [31:0] RDATA ,output reg [1:0] RRESP , output reg RVALID , input wire RREADY );
    
  

    reg [31:0] reg0, reg1, reg2, reg3;
    reg [31:0] awaddr_reg;
    reg [31:0] wdata_reg;
    reg        awaddr_done;
    reg        wdata_done;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            AWREADY     <= 1'b0;
            WREADY      <= 1'b0;
            BVALID      <= 1'b0;
            BRESP       <= 2'b00;

            ARREADY     <= 1'b0;
            RVALID      <= 1'b0;
            RRESP       <= 2'b00;
            RDATA       <= 32'b0;

            reg0        <= 32'b0;
            reg1        <= 32'b0;
            reg2        <= 32'b0;
            reg3        <= 32'b0;

            awaddr_reg  <= 32'b0;
            wdata_reg   <= 32'b0;
            awaddr_done <= 1'b0;
            wdata_done  <= 1'b0;
        end
        else begin
            // Always ready in this simple version
            AWREADY <= 1'b1;
            WREADY  <= 1'b1;
            ARREADY <= 1'b1;

            // Capture write address
            if (AWVALID) begin
                awaddr_reg  <= AWADDR;
                awaddr_done <= 1'b1;
            end

            // Capture write data
            if (WVALID) begin
                wdata_reg   <= WDATA;
                wdata_done  <= 1'b1;
            end

            // Perform write when both address and data are available
            if (awaddr_done && wdata_done && !BVALID) begin
                case (awaddr_reg[3:2])
                    2'b00: reg0 <= wdata_reg;
                    2'b01: reg1 <= wdata_reg;
                    2'b10: reg2 <= wdata_reg;
                    2'b11: reg3 <= wdata_reg;
                    default: reg0 <= reg0;
                endcase

                BVALID      <= 1'b1;
                BRESP       <= 2'b00;
                awaddr_done <= 1'b0;
                wdata_done  <= 1'b0;
            end

            // Complete write response handshake
            if (BVALID && BREADY) begin
                BVALID <= 1'b0;
            end

            // Read address handshake and data return
            if (ARVALID && ARREADY && !RVALID) begin
                case (ARADDR[3:2])
                    2'b00: RDATA <= reg0;
                    2'b01: RDATA <= reg1;
                    2'b10: RDATA <= reg2;
                    2'b11: RDATA <= reg3;
                    default: RDATA <= 32'b0;
                endcase

                RVALID <= 1'b1;
                RRESP  <= 2'b00;
            end

            // Complete read handshake
            if (RVALID && RREADY) begin
                RVALID <= 1'b0;
            end
        end
    end

endmodule
 //    
