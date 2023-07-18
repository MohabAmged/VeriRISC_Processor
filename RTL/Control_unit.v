module controller
(
  input  wire [2:0] opcode ,
  input  wire [2:0] phase  ,
  input  wire       zero   , // accumulator is zero
  output reg        sel    , // select instruction address to memory
  output reg        rd     , // enable memory output onto data bus
  output reg        ld_ir  , // load instruction register
  output reg        inc_pc , // increment program counter
  output reg        halt   , // halt machine
  output reg        ld_pc  , // load program counter
  output reg        data_e , // enable accumulator output onto data bus
  output reg        ld_ac  , // load accumulator from data bus
  output reg        wr       // write data bus to memory
);

// states 
localparam HLT =0 ;
localparam SKZ =1 ;
localparam ADD =2 ;
localparam AND =3 ;
localparam XOR =4 ;
localparam LDA =5 ;
localparam STO =6 ;
localparam JMP =7 ;
reg ALU_OP , H , J , S , SK ;



always @(*) begin
    
    ALU_OP = (opcode == AND) || (opcode == XOR) || (opcode == ADD) || (opcode == LDA);
    H      = (opcode == HLT);
    J      = (opcode == JMP);
    S      = (opcode == STO);
    SK     = (opcode == SKZ && zero);

end

always @(*) begin
        case (phase)

            3'd0: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=9'b1000_00000;
            3'd1: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=9'b1100_00000;            
            3'd2: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=9'b1110_00000;
            3'd3: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=9'b1110_00000;
            3'd4: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}={3'b000,H,1'b1,4'b0000};
            3'd5: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}={1'b0,ALU_OP,{7{1'b0}}};
            3'd6: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}={1'b0,ALU_OP,2'b00,SK,1'b0,J,1'b0,S};
            3'd7: {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}={1'b0,ALU_OP,3'b000,ALU_OP,J,S,S};            
            default:
                    {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e}=9'b1;
            endcase


        
    
end




endmodule