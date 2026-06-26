module mooreTurnstile(
    input logic clk,
    input logic reset,
    input logic coin,
    input logic push,
    output logic unlocked,
    output logic alarm
);

    typedef enum logic [1:0] {S0, S1, S2}
statetype;
    statetype state, nextstate;

    always_ff @(posedge clk, posedge reset)
        if (reset) state <= S0;
        else state <= nextstate;

always_comb begin
    case (state)
        S0: begin
            if (coin)
                nextstate = S1;
            else if (push)
                nextstate = S2;
        end

        S1: begin
            if (coin)
                nextstate = S1;
            else if (push)
                nextstate = S0;
        end

        S2: begin
            if (clk)
                nextstate = S0;
        end

    default: nextstate = S0;
    endcase
end

always_comb begin
    unlocked = 1'b0;
    alarm = 1'b0;

    case (state)
        S0: begin
            unlocked = 1'b0;
            alarm = 1'b0;
        end 
        
        S1: begin
            unlocked = 1'b1;
            alarm = 1'b0;
        end
        
        S2: begin
            unlocked = 1'b0;
            alarm = 1'b1;
        end

        default: begin
            unlocked = 1'b0;
            alarm = 1'b0;
        end 
    endcase
end   

endmodule