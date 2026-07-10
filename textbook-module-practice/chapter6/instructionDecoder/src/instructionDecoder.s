module instructionDecoder(
    input logic [31:0] instr,
    
    output logic [6:0] opcode,
    output logic [4:0] rd,
    output logic [2:0] funct3,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] funct7,
    output logic [31:0] imm_i,
    output logic [31:0] imm_s,
    output logic [31:0] imm_b,
    output logic [31:0] imm_u,
    output logic [31:0] imm_j,
    output logic [7:0] instr_type
);

logic [11:0] imm_i_raw;
logic [11:0] imm_s_raw;
logic [12:0] imm_b_raw;
logic [20:0] imm_j_raw;

//fixed fields
assign opcode = instr[6:0];
assign rd     = instr[11:7];
assign funct3 = instr[14:12];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign funct7 = instr[31:25];

//instruction type case
always_comb begin
    instr_type = "?";

    case (opcode)
        7'b0110011: instr_type = "R";
        7'b0010011, 7'b0000011, 7'b1100111: instr_type = "I";
        7'b0100011: instr_type = "S";
        7'b1100011: instr_type = "B";
        7'b0110111: instr_type = "U";
        7'b1101111: instr_type = "J";
        default:    instr_type = "?";
    endcase
end

//using raw immediates
assign imm_i_raw = instr[31:20];

assign imm_s_raw = {
    instr[31:25],
    instr[11:7]
};

assign imm_b_raw = {
    instr[31],
    instr[7],
    instr[30:25],
    instr[11:8],
    1'b0
};

assign imm_j_raw = {
    instr[31],
    instr[19:12],
    instr[20],
    instr[30:21],
    1'b0
};

// 32-bit immediate outputs
assign imm_i = {{20{imm_i_raw[11]}}, imm_i_raw};
assign imm_s = {{20{imm_s_raw[11]}}, imm_s_raw};
assign imm_b = {{19{imm_b_raw[12]}}, imm_b_raw};
assign imm_u = {instr[31:12], 12'b0};
assign imm_j = {{11{imm_j_raw[20]}}, imm_j_raw};

endmodule

