
module testbench;

wire clk;
reg rst_n;
wire [3:0] rosu, galben, verde;
wire [3:0] verde_pietoni, rosu_pietoni;
reg pietoni_btn_i_nord, pietoni_btn_i_sud, pietoni_btn_i_est, pietoni_btn_i_vest;
reg service_i = 1'b0;

gen_clk_rst #(500) CLK_INST( 
    .clk_o(clk)
);

initial begin
    rst_n = 1'b0;
    #500;
    rst_n = 1'b1;
    #522_000;
    rst_n = 1'b0;
    #20_000;
    rst_n = 1'b1;
end

semaforConexiuni SEMAFOR_INST (
    .clk(clk),
    .rst_n(rst_n),
    .pietoni_btn_i_nord(pietoni_btn_i_nord),
    .pietoni_btn_i_sud(pietoni_btn_i_sud),
    .pietoni_btn_i_est(pietoni_btn_i_est),
    .pietoni_btn_i_vest(pietoni_btn_i_vest),
    .service_i(service_i),

    .verde_nord(verde[0]),
    .galben_nord(galben[0]),
    .rosu_nord(rosu[0]),
    .verde_pietoni_nord(verde_pietoni[0]),
    .rosu_pietoni_nord(rosu_pietoni[0]),

    .verde_sud(verde[1]),
    .galben_sud(galben[1]),
    .rosu_sud(rosu[1]),
    .verde_pietoni_sud(verde_pietoni[1]),
    .rosu_pietoni_sud(rosu_pietoni[1]),

    .verde_est(verde[2]),
    .galben_est(galben[2]),
    .rosu_est(rosu[2]),
    .verde_pietoni_est(verde_pietoni[2]),
    .rosu_pietoni_est(rosu_pietoni[2]),


    .verde_vest(verde[3]),
    .galben_vest(galben[3]),
    .rosu_vest(rosu[3]),
    .verde_pietoni_vest(verde_pietoni[3]),
    .rosu_pietoni_vest(rosu_pietoni[3])

);
assign pietoni_btn_i_nord = 1'b1;
assign pietoni_btn_i_sud = 1'b1;
assign pietoni_btn_i_est = 1'b1;
assign pietoni_btn_i_vest = 1'b1;
initial begin
    
    #450_000;
    service_i = 1'b1;
    #500_00;
    service_i = 1'b0;
end

initial begin
    #1000
    assign pietoni_btn_i_sud = 1'b1;
    #41500
    assign pietoni_btn_i_sud = 1'b0;
end

initial begin
    #78000;
    assign pietoni_btn_i_nord = 1'b1;
    #24500;
    assign pietoni_btn_i_nord = 1'b0;
end

initial begin
    #115_000;
    assign pietoni_btn_i_est = 1'b1;
    #27500;
    assign pietoni_btn_i_est = 1'b0;
end

initial begin
    #160_000;
    assign pietoni_btn_i_vest = 1'b1;
    #28500;
    assign pietoni_btn_i_vest = 1'b0;
end



endmodule
