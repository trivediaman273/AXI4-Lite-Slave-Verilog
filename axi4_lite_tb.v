module axi4_lite_tb(

    );
    
reg ACLK ,ARESETN ,AWVALID;
reg [31:0] AWADDR;
reg [31:0] WDATA;
reg WVALID;
reg BREADY;
reg [31:0] ARADDR;
reg ARVALID;
reg RREADY;
wire AWREADY,WREADY,ARREADY,BVALID;
wire [1:0] BRESP;
wire RVALID;
wire [31:0] RDATA;
wire [1:0] RRESP;

axi4_lite dut(ACLK , ARESETN ,  AWADDR ,  AWVALID ,
 AWREADY ,  WDATA , WVALID , WREADY ,  BRESP,
 BREADY ,BVALID , ARADDR , ARVALID ,ARREADY,
   RDATA ,RRESP , RVALID ,  RREADY);

initial
begin
{ACLK ,AWVALID ,AWADDR ,WDATA,WVALID,BREADY,ARADDR,ARVALID,RREADY}<=0;
end

always #5 ACLK=~ACLK;

task axi_write;
    input [31:0] addr1;
    input [31:0] data;
begin

    // Send address
    AWADDR  = addr1;
    AWVALID = 1;

    // Send data
    WDATA   = data;
    WVALID  = 1;

    // Wait for slave ready
    wait (AWREADY && WREADY);

    @(posedge ACLK);
    AWVALID = 0;
    WVALID  = 0;

    // Wait for response
    BREADY = 1;
    wait (BVALID);

    @(posedge ACLK);
    BREADY = 0;

end
endtask

task axi_read;
    input  [31:0] addr;
    output [31:0] data;
begin
    ARADDR  = addr;
    ARVALID = 1;

    wait (ARREADY);

    @(posedge ACLK);
    ARVALID = 0;

    RREADY = 1;
    wait (RVALID);

    @(posedge ACLK);   // sample after RVALID
    data = RDATA;

    RREADY = 0;
end
endtask


reg [31:0] read_data;
initial begin
    ARESETN = 0;

    #20;
    ARESETN = 1;
end

initial begin
    wait(ARESETN == 1);
    @(posedge ACLK); 

    // Write to reg0
    axi_write(32'h00, 32'hAAAA1111);

    // Write to reg1
    axi_write(32'h04, 32'hBBBB2222);
    
    

    // Read back reg0
    axi_read(32'h00, read_data);
    $display("READ reg0 = %h", read_data);

    // Read back reg1
    axi_read(32'h04, read_data);
    $display("READ reg1 = %h", read_data);
    
    

    #200;
    $finish;
end



endmodule
