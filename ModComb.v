`include "./verilog/defines.v"
module ModComb(input 					        clk,reset,sel,
			input      [`DATA_SIZE_ARB-1:0] q,
            input      [`DATA_SIZE_ARB-1:0] NTTin0,NTTin1,
			output reg [`DATA_SIZE_ARB-1:0] out);

// modular sub
wire        [`DATA_SIZE_ARB-1:0] msub,madd;
wire        [`DATA_SIZE_ARB-1:0] mcomb_res;
wire carry,borrow;

//route inputs
wire [`DATA_SIZE_ARB:0] NTTinAdd0, NTTinAdd1, NTTinSub0,NTTinSub1;
assign NTTinAdd0 = (sel) ? q : NTTin0;
assign NTTinAdd1 = (sel) ? msub : NTTin1;
assign NTTinSub0 = (sel) ? NTTin0 : madd;
assign NTTinSub1 = (sel) ? NTTin1 : q;

//for correct extension due to a unity sized datapath for adding
assign extIn0 = NTTin0[`DATA_SIZE_ARB-1];
assign extIn1 = NTTin1[`DATA_SIZE_ARB-1];
assign extq   = q[`DATA_SIZE_ARB-1];

assign {borrow,msub}    = NTTinSub0 - NTTinSub1;
assign {carry,madd}     = NTTinAdd0 + NTTinAdd1;

assign mcomb_res = ((~carry & borrow) | (sel & carry & borrow)) ?  madd[`DATA_SIZE_ARB-1:0] : msub[`DATA_SIZE_ARB-1:0];

always@(posedge clk)begin
    if(reset)begin
        out <= 'b0;
    end
    else begin
        out <= mcomb_res;
    end
end
endmodule