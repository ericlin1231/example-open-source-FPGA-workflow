module adder #(
    parameter CLK_HZ = 25_000_000,
    parameter DEBOUNCE_MS = 10,
    parameter ACTIVE_LOW = 0,
    parameter MAX_DATA = 16,
    parameter WIDTH = $clog2(MAX_DATA)
) (
    input clk_25mhz,
    input [3:0] btn,
    output logic [WIDTH-1:0] led
);

  logic rst;
  logic [2:0] btn_pressed;

  /* verilator lint_off PINCONNECTEMPTY */
  debounce #(
      .CLK_HZ(CLK_HZ),
      .DEBOUNCE_MS(DEBOUNCE_MS),
      .ACTIVE_LOW(ACTIVE_LOW)
  ) debounce_u_rst (
      .clk(clk_25mhz),
      .rst(),
      .btn_i(btn[3]),
      .pressed(rst)
  );

  debounce #(
      .CLK_HZ(CLK_HZ),
      .DEBOUNCE_MS(DEBOUNCE_MS),
      .ACTIVE_LOW(ACTIVE_LOW)
  ) debounce_u0 (
      .clk(clk_25mhz),
      .rst(rst),
      .btn_i(btn[0]),
      .pressed(btn_pressed[0])
  );

  debounce #(
      .CLK_HZ(CLK_HZ),
      .DEBOUNCE_MS(DEBOUNCE_MS),
      .ACTIVE_LOW(ACTIVE_LOW)
  ) debounce_u1 (
      .clk(clk_25mhz),
      .rst(rst),
      .btn_i(btn[1]),
      .pressed(btn_pressed[1])
  );

  debounce #(
      .CLK_HZ(CLK_HZ),
      .DEBOUNCE_MS(DEBOUNCE_MS),
      .ACTIVE_LOW(ACTIVE_LOW)
  ) debounce_u2 (
      .clk(clk_25mhz),
      .rst(rst),
      .btn_i(btn[2]),
      .pressed(btn_pressed[2])
  );

  always_ff @(posedge clk_25mhz) begin
    if (rst) begin
      led <= 0;
    end else begin
      if (btn_pressed[0]) begin
        led <= led + 1;
      end else if (btn_pressed[1]) begin
        led <= led + (1 << 1);
      end else if (btn_pressed[2]) begin
        led <= led + (1 << 2);
      end else begin
        led <= led;
      end
    end
  end

endmodule
