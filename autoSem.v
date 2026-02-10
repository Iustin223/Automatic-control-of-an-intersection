
module autoSem #(parameter SECUNDE_VERDE = 10,
                 parameter FACTOR_DIVIZARE_AUTO_MODULE = 10)
(
    input clk,
    input enable,
    input clear,
    input rst_n,
    input pietoni_btn_i,
    input service_i,

    output done,
    output rosu,
    output galben,
    output verde,
    output verde_pietoni,
    output rosu_pietoni
);

reg [1:0] counter_galben;
reg [5:0] counter_verde;
reg [4:0] counter_pietoni_verde;
reg [4:0] counter_pietoni_intermitent;

localparam S_IDLE = 0;
localparam S_VERDE = 1;
localparam S_GALBEN = 2;
localparam S_PIETONI_VERDE = 3;
localparam S_PIETONI_INTERMITENT = 4;
localparam S_SERVICE = 5;
localparam S_DONE = 6; 

localparam SECUNDE_GALBEN = 2;


wire enable_div_fr;
wire puls_div;

reg [2:0]STARE_CURENTA;
reg [2:0]STARE_VIITOARE;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) STARE_CURENTA <= S_IDLE;
    else       STARE_CURENTA <= STARE_VIITOARE;
end

always @(*) begin
    case(STARE_CURENTA)
        S_IDLE: if(service_i) STARE_VIITOARE <= S_SERVICE;
                else if(enable) STARE_VIITOARE <= S_VERDE;
                else STARE_VIITOARE <= S_IDLE;

        S_VERDE:if(service_i) STARE_VIITOARE <= S_SERVICE;
                else if(counter_verde == SECUNDE_VERDE-1) STARE_VIITOARE <= S_GALBEN;
                else STARE_VIITOARE <= S_VERDE;

        S_GALBEN: begin
            if(service_i) STARE_VIITOARE <= S_SERVICE;
            else if(counter_galben == SECUNDE_GALBEN - 1) begin
                if(pietoni_btn_i)
                    STARE_VIITOARE <= S_PIETONI_VERDE;
                else
                    STARE_VIITOARE <= S_DONE;
            end else STARE_VIITOARE <= S_GALBEN;
        end

        S_PIETONI_VERDE:if(service_i) STARE_VIITOARE <= S_SERVICE; 
                        else if(counter_pietoni_verde == 12-1) STARE_VIITOARE <= S_PIETONI_INTERMITENT;
                        else STARE_VIITOARE <= S_PIETONI_VERDE;
        
        S_PIETONI_INTERMITENT:if(service_i) STARE_VIITOARE <= S_SERVICE;
                              else if(counter_pietoni_intermitent == 6-1) STARE_VIITOARE <= S_DONE;
                              else STARE_VIITOARE <= S_PIETONI_INTERMITENT;

        S_SERVICE:if(~service_i) STARE_VIITOARE <= S_IDLE;
                  else STARE_VIITOARE <= S_SERVICE;

        S_DONE: if(clear) STARE_VIITOARE <= S_IDLE;
                else STARE_VIITOARE <= S_DONE;
       
        default: STARE_VIITOARE <= S_IDLE;
    endcase
end

divFrecventa #(FACTOR_DIVIZARE_AUTO_MODULE) DIV_FR(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_div_fr),
    .clk_div(puls_div)
);

assign enable_div_fr = (STARE_CURENTA == S_VERDE) | (STARE_CURENTA == S_GALBEN);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)                         counter_galben <= 0;
    else if(STARE_CURENTA == S_GALBEN)   counter_galben <= counter_galben +1;
    else if(STARE_CURENTA != S_GALBEN)   counter_galben <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)                        counter_verde <= 0;
    else if(STARE_CURENTA == S_VERDE)   counter_verde <= counter_verde +1;
    else if(STARE_CURENTA != S_VERDE)   counter_verde <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)                                counter_pietoni_verde <= 0;
    else if(STARE_CURENTA == S_PIETONI_VERDE)   counter_pietoni_verde <= counter_pietoni_verde +1;
    else if(STARE_CURENTA != S_PIETONI_VERDE)   counter_pietoni_verde <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)                                      counter_pietoni_intermitent <= 0;
    else if(STARE_CURENTA == S_PIETONI_INTERMITENT)   counter_pietoni_intermitent <= counter_pietoni_intermitent +1;
    else if(STARE_CURENTA != S_PIETONI_INTERMITENT)   counter_pietoni_intermitent <= 0;
end

reg blink;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        blink <= 0;
    else
        blink <= ~blink;  
end

assign galben = (STARE_CURENTA == S_GALBEN) ? 1'b1  :
                (STARE_CURENTA == S_SERVICE) ? blink :
                1'b0;
assign verde = (STARE_CURENTA == S_VERDE);
assign rosu = (STARE_CURENTA == S_IDLE) | (STARE_CURENTA == S_DONE) | (STARE_CURENTA == S_PIETONI_VERDE) | (STARE_CURENTA == S_PIETONI_INTERMITENT);
assign done = (STARE_CURENTA == S_DONE);
assign verde_pietoni = (STARE_CURENTA == S_PIETONI_VERDE)         ? 1'b1  :
                       (STARE_CURENTA == S_PIETONI_INTERMITENT)   ? blink :
                       1'b0;
assign rosu_pietoni = ~((STARE_CURENTA == S_PIETONI_INTERMITENT) | (STARE_CURENTA == S_PIETONI_VERDE));

endmodule

