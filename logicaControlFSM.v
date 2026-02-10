module logicaControlFSM #(parameter FACTOR_DIVIZARE_AUTO_MODULE = 10)
(
    input clk,
    input enable,
    input rst_n,

    input done_nord,
    input done_sud,
    input done_est,
    input done_vest,

    output enable_nord,
    output enable_sud,
    output enable_est,
    output enable_vest,

    output clear_nord,
    output clear_sud,
    output clear_est,
    output clear_vest
);

localparam S_IDLE = 0;
localparam S_AUTO_NORD = 2;
localparam S_AUTO_SUD = 1;
localparam S_AUTO_EST = 3; 
localparam S_AUTO_VEST = 4; 

reg [2:0]STARE_CURENTA;
reg [2:0]STARE_VIITOARE; 


always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) STARE_CURENTA <= S_IDLE;
    else       STARE_CURENTA <= STARE_VIITOARE;
end


always @(*)  
begin
    case(STARE_CURENTA)
        S_IDLE: if(enable) STARE_VIITOARE <= S_AUTO_SUD;
                else STARE_VIITOARE <= S_IDLE;

        S_AUTO_SUD: if(done_sud) STARE_VIITOARE <= S_AUTO_NORD;
                else STARE_VIITOARE <= S_AUTO_SUD;

        S_AUTO_NORD: if(done_nord) STARE_VIITOARE <= S_AUTO_EST;
                else STARE_VIITOARE <= S_AUTO_NORD;

        S_AUTO_EST: if(done_est) STARE_VIITOARE <= S_AUTO_VEST;
                else STARE_VIITOARE <= S_AUTO_EST;

        S_AUTO_VEST: if(done_vest) STARE_VIITOARE <= S_AUTO_SUD;
                else STARE_VIITOARE <= S_AUTO_VEST;

        default: STARE_VIITOARE <= S_IDLE;
    endcase
end

assign enable_nord = (STARE_CURENTA == S_AUTO_NORD);
assign enable_sud =  (STARE_CURENTA == S_AUTO_SUD);
assign enable_est = (STARE_CURENTA == S_AUTO_EST);
assign enable_vest = (STARE_CURENTA == S_AUTO_VEST);

assign clear_nord = (done_nord);
assign clear_sud = (done_sud);
assign clear_est = (done_est);
assign clear_vest = (done_vest);


endmodule