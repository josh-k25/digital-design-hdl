module mealyVendingMachine(
    input logic clk,
    input logic reset,
    input logic nickel,
    input logic dime,
    output logic dispense
);

    typedef enum logic [1:0] {S0, S1, S2} 
statetype;
    statetype state, nextstate;

always_ff @(posedge clk, posedge reset) begin
    if (reset) state <= S0;
    else state <= nextstate;
end

always_comb begin
    nextstate = state;
    dispense = 1'b0;
    
    case (state)
        S0: begin
            if (nickel) 
            nextstate = S1;
            else if (dime) nextstate = S2;
            end

        S1: begin
            if (nickel) 
                nextstate = S2;
            else if (dime) begin
                dispense = 1'b1;  
                nextstate = S0;
                end
            end

        S2: begin
            if (nickel || dime) 
            dispense = 1'b1;
            nextstate = S0;
            end
        

        default: begin
            nextstate = S0;
            dispense = 1'b1;
            end
    endcase
end

endmodule