module memory #(
    parameter DWIDTH =8,
    parameter AWIDTH =5
) (
    input wire [AWIDTH-1:0]addr,
    input wire clk,
    input wire wr,
    input wire rd,
    inout wire [DWIDTH-1:0]data
);
       
reg [DWIDTH-1:0] array[2**AWIDTH-1:0]; 
// Continous assigning output 
assign data=rd?array[addr]:'bz;
always @(posedge clk) begin
    if (wr) 
        array[addr]=data;
end



endmodule