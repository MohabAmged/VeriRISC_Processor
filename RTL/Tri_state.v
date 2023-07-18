module driver #(
    parameter WIDTH=5
) (
    input wire [WIDTH-1:0]data_in,
    input wire data_en,
    output wire [WIDTH-1:0]data_out
);
assign data_out = data_en?data_in: 'b z;
endmodule