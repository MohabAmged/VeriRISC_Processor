`include "Alu.v"
`include "Control_unit.v"
`include "Counter.v"
`include "General_mux.v"
`include "Memory.v"
`include "reg.v"
`include "Tri_state.v"
`default_nettype none
module risc(
    input wire clk,
    input wire rst,
    output wire halt
);

// Parameter instinantiation 
localparam Datawidth     = 8 ;
localparam Addreswidth   = 5 ;
localparam phase_width   = 3 ;
localparam op_width      = 3 ;


// Alu Signals
wire [Datawidth-1:0]alu_out;
wire [Datawidth-1:0]data;
wire zero;


// Accumlator Signals 
wire [Datawidth-1:0]ac_out;
wire ld_ac;


// Driver signals 
wire data_e;


// instruction register signals 
wire [op_width-1:0]opcode;
wire [Addreswidth-1:0]ir_addr;
wire [Datawidth-1:0]ir_bus;
wire ld_ir;


// Program Counter signals 
wire ld_pc;
wire inc_pc;
wire [Addreswidth-1:0]pc_addr;  


// Address Mux signals 
wire [Addreswidth-1:0]addr;
wire sel; 


// memory signals 
wire rd;
wire wr; 

// Counter signals
wire [phase_width-1:0]phase;





// ALU module insitance 
alu #(
    .WIDTH(Datawidth)
 )
alu_inst(
       .in_a(ac_out),
       .in_b(data),
       .a_is_zero(zero),
       .alu_out(alu_out),
       .opcode(opcode)
);


// Accumulator module insitance 
register #(
    .WIDTH(Datawidth)
 )
register_ac(
       .data_in(alu_out),
       .load(ld_ac),
       .clk(clk),
       .rst(rst),
       .data_out(ac_out)

);


// Driver module insitance 
driver #(
    .WIDTH(Datawidth)
 )
driver_inst(
       .data_in(alu_out),
       .data_en(data_e),
       .data_out(data) 
);


// instruction register insitance 
register #(
    .WIDTH(Datawidth)
 )
register_ir(
       .data_in(data),
       .load(ld_ir),
       .clk(clk),
       .rst(rst),
       .data_out({opcode,ir_addr})
);
// assigning op code and ir address
//ssign {opcode,ir_addr}=ir_bus;


// Program Counter insitance 
counter #(
    .WIDTH(Addreswidth)
 )
counter_pc(
       .cnt_in(ir_addr),
       .load(ld_pc),
       .clk(clk),
       .rst(rst),
       .enab(inc_pc),
       .cnt_out(pc_addr)
);


// multiplexer insitance 
multiplexor #(
    .WIDTH(Addreswidth))
address_mux(
       .in0(ir_addr),
       .in1(pc_addr),
       .sel(sel),
       .mux_out(addr) 
);


// Memory insitance 
memory #(
    .AWIDTH(Addreswidth),
    .DWIDTH(Datawidth) )
memory_inst(
       .addr(addr),
       .clk(clk),
       .wr(wr),
       .rd(rd), 
       .data(data)
);


// counter instance 
counter #(
    .WIDTH(phase_width)
 )
counter_clk(
       .cnt_in(3'b0),
       .load(1'b0),
       .clk(clk),
       .rst(rst),
       .enab(!halt),
       .cnt_out(phase)
);


// controller instance 
controller controller_inst 
(
     .zero(zero),
     .phase(phase),
     .opcode(opcode),
     .sel(sel),
     .rd(rd),
     .ld_ir(ld_ir),
     .inc_pc(inc_pc),
     .halt(halt),
     .ld_pc(ld_pc),
     .data_e(data_e),
     .ld_ac(ld_ac),
     .wr(wr)                
);


    
endmodule