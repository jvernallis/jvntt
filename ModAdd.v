`include "./verilog/defines.v"
module ModAdd(input 					        clk,reset,
			input      [`DATA_SIZE_ARB-1:0] q,
            input      [`DATA_SIZE_ARB-1:0] NTTin0,NTTin1,
			output reg [`DATA_SIZE_ARB-1:0] out);

wire        [`DATA_SIZE_ARB  :0] madd;
wire signed [`DATA_SIZE_ARB+1:0] madd_q;
wire        [`DATA_SIZE_ARB-1:0] madd_res;

assign madd     = NTTin0 + NTTin1;
assign madd_q   = madd - q;
assign madd_res = (madd_q[`DATA_SIZE_ARB+1] == 1'b0) ? madd_q[`DATA_SIZE_ARB-1:0] : madd[`DATA_SIZE_ARB-1:0];

always@(posedge clk)begin
    if(reset)begin
        out <= 'b0;
    end
    else begin
        out <= madd_res;
    end
end
endmodule