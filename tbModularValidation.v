`timescale 1ns / 1ps
`include "defines.v"

module tb_ModularValidation();

    reg clk;
    reg reset;
    reg sel;
    reg [`DATA_SIZE_ARB-1:0] q;
    reg [`DATA_SIZE_ARB-1:0] in0, in1;

    wire [`DATA_SIZE_ARB-1:0] out_comb, out_add, out_sub;

    always #5 clk = (clk === 1'b0);

    ModComb dut_comb (.clk(clk), .reset(reset), .sel(sel), .q(q), .NTTin0(in0), .NTTin1(in1), .out(out_comb));
    ModAdd  ref_add  (.clk(clk), .reset(reset), .q(q), .NTTin0(in0), .NTTin1(in1), .out(out_add));
    ModSub  ref_sub  (.clk(clk), .reset(reset), .q(q), .NTTin0(in0), .NTTin1(in1), .out(out_sub));

    integer i;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,tb_ModularValidation);

        clk = 0;
        reset = 1;
        sel = 0;
        q = 'd251; 
        in0 = 0;
        in1 = 0;

        repeat(2) @(posedge clk);
        reset = 0;

        $display("--- Starting 32-Point Random Validation ---");
        $display("Time | Sel | In0 | In1 | Comb Out | Expected");
        $display("----------------------------------------------");

        for (i = 0; i < 32; i = i + 1) begin
            #5 clk = (clk === 1'b1);
            // Generate Random Inputs
            sel = $urandom_range(0,1);           // Randomly choose Add (0) or Sub (1)
            in0 = $urandom_range(0, 16383); 
            in1 = $urandom_range(0, 16383);

            #5 clk = (clk === 1'b0);
            #5 clk = (clk === 1'b1);

            // Validate against the appropriate reference module
            if (sel == 1'b0) begin
                if (out_comb !== out_add) begin
                    $display("%t | FAIL | %d | %d | %d | (Expected Add: %d)", $time, $signed(in0), $signed(in1), $signed(out_comb), $signed(out_add));
                end else begin
                    $display("%t | PASS | %d | %d | %d | (Add)", $time, $signed(in0), $signed(in1), $signed(out_comb));
                end
            end else begin
                if (out_comb !== out_sub) begin
                    $display("%t | FAIL | %d | %d | %d | (Expected Sub: %d)", $time, $signed(in0), $signed(in1), $signed(out_comb), $signed(out_sub));
                end else begin
                    $display("%t | PASS | %d | %d | %d | (Sub)", $time, $signed(in0), $signed(in1), $signed(out_comb));
                end
            end
            #5 clk = (clk === 1'b0);
        end

        #20 $finish;
    end

endmodule