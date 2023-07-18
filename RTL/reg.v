module register #(
    parameter WIDTH =8 
) (
    input wire [WIDTH-1:0]data_in,
    input wire load,
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0]data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out<=0;
    end
    else if (load) begin
        data_out<=data_in;
    end
end

endmodule