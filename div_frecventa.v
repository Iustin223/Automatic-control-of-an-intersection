module divFrecventa #(parameter FACTOR_DIVIZARE = 10)
    (
    input clk,
    input rst_n,
    input enable,

    output clk_div
);

reg [23:0] counter;
always @ (posedge clk or negedge rst_n)
begin
    if(~rst_n) counter <= 0;
    else if(enable & (counter < FACTOR_DIVIZARE)) counter <= counter + 1;
    else counter <= 0;
end

assign clk_div = (counter == FACTOR_DIVIZARE - 1);

endmodule