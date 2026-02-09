module ModSub(input 					        clk,reset,
			input      [`DATA_SIZE_ARB-1:0] q,
            input      [`DATA_SIZE_ARB-1:0] NTTin0,NTTin1,
			output reg [`DATA_SIZE_ARB-1:0] out);

// modular sub
wire        [`DATA_SIZE_ARB  :0] msub;
wire signed [`DATA_SIZE_ARB+1:0] msub_q;
wire        [`DATA_SIZE_ARB-1:0] msub_res;

assign msub     = NTTin0 - NTTin1;
assign msub_q   = msub + q;
assign msub_res = (msub[`DATA_SIZE_ARB] == 1'b0) ? msub[`DATA_SIZE_ARB-1:0] : msub_q[`DATA_SIZE_ARB-1:0];

always@(posedge clk){
    if(reset){
        out <= 'b0;
    }
    else{
        out <= msub_res;
    }
}
endmodule