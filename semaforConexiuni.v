module semaforConexiuni(
    input clk,
    input rst_n,
    input pietoni_btn_i_nord,
    input pietoni_btn_i_sud,
    input pietoni_btn_i_est,
    input pietoni_btn_i_vest,
    input service_i,

    output verde_nord,
    output galben_nord,
    output rosu_nord,
    output verde_pietoni_nord,
    output rosu_pietoni_nord,

    output verde_sud,
    output galben_sud,
    output rosu_sud,
    output verde_pietoni_sud,
    output rosu_pietoni_sud,

    output verde_est,
    output galben_est,
    output rosu_est,
    output verde_pietoni_est,
    output rosu_pietoni_est,

    output verde_vest,
    output galben_vest,
    output rosu_vest,
    output verde_pietoni_vest,
    output rosu_pietoni_vest
);

localparam SECUNDE_VERDE_NORD = 24;
localparam SECUNDE_VERDE_SUD = 28;
localparam SECUNDE_VERDE_EST = 29;
localparam SECUNDE_VERDE_VEST = 25;
localparam FACTOR_DIVIZARE = 1000;

wire done_nord, done_sud, done_est, done_vest;
wire enable_nord, enable_sud, enable_est, enable_vest;
wire clear_nord, clear_sud, clear_est, clear_vest;

wire enable = 1'b1;

logicaControlFSM #(FACTOR_DIVIZARE) CONTROLFSM(
.clk(clk),
.enable(enable),
.rst_n(rst_n),

.done_nord(done_nord),
.done_sud(done_sud),
.done_est(done_est),
.done_vest(done_vest),

.enable_nord(enable_nord),
.enable_sud(enable_sud),
.enable_est(enable_est),
.enable_vest(enable_vest),

.clear_nord(clear_nord),
.clear_sud(clear_sud),
.clear_est(clear_est),
.clear_vest(clear_vest)
);

autoSem #(SECUNDE_VERDE_SUD, FACTOR_DIVIZARE) MODUL_SUD(
.clk(clk),
.enable(enable_sud),
.clear(clear_sud),
.rst_n(rst_n),
.pietoni_btn_i(pietoni_btn_i_sud),
.service_i(service_i),

.done(done_sud),
.rosu(rosu_sud),
.galben(galben_sud),
.verde(verde_sud),
.verde_pietoni(verde_pietoni_sud),
.rosu_pietoni(rosu_pietoni_sud)
);

autoSem #(SECUNDE_VERDE_NORD, FACTOR_DIVIZARE) MODUL_NORD(
.clk(clk),
.enable(enable_nord),
.clear(clear_nord),
.rst_n(rst_n),
.pietoni_btn_i(pietoni_btn_i_nord),
.service_i(service_i),

.done(done_nord),
.rosu(rosu_nord),
.galben(galben_nord),
.verde(verde_nord),
.verde_pietoni(verde_pietoni_nord),
.rosu_pietoni(rosu_pietoni_nord)
);


autoSem #(SECUNDE_VERDE_EST, FACTOR_DIVIZARE) MODUL_EST(
.clk(clk),
.enable(enable_est),
.clear(clear_est),
.rst_n(rst_n),
.pietoni_btn_i(pietoni_btn_i_est),
.service_i(service_i),

.done(done_est),
.rosu(rosu_est),
.galben(galben_est),
.verde(verde_est),
.verde_pietoni(verde_pietoni_est),
.rosu_pietoni(rosu_pietoni_est)
);

autoSem #(SECUNDE_VERDE_VEST, FACTOR_DIVIZARE) MODUL_VEST(
.clk(clk),
.enable(enable_vest),
.clear(clear_vest),
.rst_n(rst_n),
.pietoni_btn_i(pietoni_btn_i_vest),
.service_i(service_i),

.done(done_vest),
.rosu(rosu_vest),
.galben(galben_vest),
.verde(verde_vest),
.verde_pietoni(verde_pietoni_vest),
.rosu_pietoni(rosu_pietoni_vest)
);

endmodule