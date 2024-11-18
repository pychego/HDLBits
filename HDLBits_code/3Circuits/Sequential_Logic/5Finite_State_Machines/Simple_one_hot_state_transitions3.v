module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    parameter A = 0, B = 1, C = 2, D = 3;

    assign next_state[A] = state[A]&(~in) | state[C]&(~in);
    assign next_state[B] = in&(state[A] | state[B] | state[D]);
    // 因为这里judge有非独热编码输入, next_state[B] = in&(~state[C]); 会出错
    assign next_state[C] = state[B]&(~in) | state[D]&(~in);
    assign next_state[D] = in&(state[C]);

    assign out = state[D];



endmodule