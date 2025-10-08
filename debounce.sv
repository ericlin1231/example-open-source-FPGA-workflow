module debounce #(
    parameter CLK_HZ      = 25_000_000,
    parameter DEBOUNCE_MS = 10,
    parameter ACTIVE_LOW  = 1
) (
    input  logic clk,
    input  logic rst,
    input  logic btn_i,
    output logic pressed
);

  logic btn_norm;
  assign btn_norm = ACTIVE_LOW ? ~btn_i : btn_i;

  logic s0, s1;
  always_ff @(posedge clk) begin
    if (rst) begin
      s0 <= 1'b0;
      s1 <= 1'b0;
    end else begin
      s0 <= btn_norm;
      s1 <= s0;
    end
  end

  /* actually CLK_HZ * (DEBOUNCE_MS / 1000)
   * but this is integer division
   * (DEBOUNCE_MS / 1000) will become 0
   */
  localparam STABLE_CYCLES = (CLK_HZ / 1000) * DEBOUNCE_MS;
  localparam CNT_W = (STABLE_CYCLES > 1) ? $clog2(STABLE_CYCLES) : 1;

  logic [CNT_W-1:0] cnt;
  logic stable_state;

  /* verilator lint_off WIDTHEXPAND */
  always_ff @(posedge clk) begin
    if (rst) begin
      stable_state <= 1'b0;
      cnt          <= 0;
    end else begin
      if (s1 == stable_state) begin
        cnt <= 0;
      end else begin
        if (cnt == STABLE_CYCLES - 1) begin
          stable_state <= s1;
          cnt          <= 0;
        end else begin
          cnt <= cnt + 1'b1;
        end
      end
    end
  end

  logic stable_state_d;
  always_ff @(posedge clk) begin
    if (rst) stable_state_d <= 1'b0;
    else stable_state_d <= stable_state;
  end

  assign pressed = (stable_state & ~stable_state_d);
endmodule

