module gen_clk_rst#(
    parameter SEMIPERIOADA_CEAS = 500
) (
    output reg clk_o   
);

initial begin
    clk_o <= 0;
    forever #SEMIPERIOADA_CEAS  
        clk_o <= ~clk_o;        
end


endmodule
