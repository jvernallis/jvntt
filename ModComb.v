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
case(sel)
1'b0 : begin
    NTTinAdd0 = NTTin0;
    NTTinAdd1 = NTTin1;
    NTTinSub0 = madd;
    NTTinSub1 = q;
end 
1'b1 : begin
    NTTinAdd0 = q;
    NTTinAdd1 = msub;
    NTTinSub0 = NTTin0;
    NTTinSub1 = NTTin1;
end
endcase
//for correct extension due to a unity sized datapath for adding
assign extIn0 = NTTin0[`DATA_SIZE_ARB-1];
assign extIn1 = NTTin1[`DATA_SIZE_ARB-1];
assign extq   = q[`DATA_SIZE_ARB-1];

assign {borrow,msub}    = NTTinSub0 - NTTinSub1;
assign {carry,madd}     = NTTinAdd0 + NTTinAdd1;

assign comb_res = ((~carry & borrow) | (sel & carry & borrow)) ? msub[`DATA_SIZE_ARB-1:0] : madd[`DATA_SIZE_ARB-1:0];

always@(posedge clk){
    if(reset){
        out <= 'b0;
    }
    else{
        out <= comb_res;
    }
}
endmodule