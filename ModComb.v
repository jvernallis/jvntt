`include "defines.v"
module ModComb(input 					        clk,reset,sel_i,
			input      [`DATA_SIZE_ARB-1:0] q,
            input      [`DATA_SIZE_ARB-1:0] NTTin0_i,NTTin1_i,
			output reg [`DATA_SIZE_ARB-1:0] out);

// modular sub
reg [`DATA_SIZE_ARB-1:0] NTTin0,NTTin1;
reg sel;
wire        [`DATA_SIZE_ARB-1:0] msub,madd;
wire        [`DATA_SIZE_ARB-1:0] mcomb_res;
wire carry,borrow;

//route inputs
wire [`DATA_SIZE_ARB:0] NTTinAdd0, NTTinAdd1, NTTinSub0,NTTinSub1;

assign NTTinAdd0 = (sel) ? q : NTTin0;
assign NTTinAdd1 = (sel) ? msub : NTTin1;
assign NTTinSub0 = (sel) ? NTTin0 : madd;
assign NTTinSub1 = (sel) ? NTTin1 : q;


assign {borrow,msub}    = NTTinSub0 - NTTinSub1;
assign {carry,madd}     = NTTinAdd0 + NTTinAdd1;

assign mcomb_res = ((~carry & borrow) | (sel & carry & borrow)) ?  madd[`DATA_SIZE_ARB-1:0] : msub[`DATA_SIZE_ARB-1:0];

always@(posedge clk)begin
    if(reset)begin
        out <= 'b0;
		  NTTin0 <= 'b0;
		  NTTin1 <= 'b0;
		  sel <= 'b0;
    end
    else begin
        out <= mcomb_res;
		  NTTin0 <= NTTin0_i;
		  NTTin1 <= NTTin1_i;
		  sel <= sel_i;
    end
end
endmodule