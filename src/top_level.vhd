library ieee;
  use ieee.std_logic_1164.all;

entity top_level is
  port (
    clk100mhz : in    std_logic;
    sw        : in    std_logic_vector(7 downto 0);
    btnc      : in    std_logic;
    btnu      : in    std_logic;
    btnl      : in    std_logic;
    btnr      : in    std_logic;
    btnd      : in    std_logic;
    vga_r     : out   std_logic_vector(3 downto 0);
    vga_g     : out   std_logic_vector(3 downto 0);
    vga_b     : out   std_logic_vector(3 downto 0);
    vga_hs    : out   std_logic;
    vga_vs    : out   std_logic
  );
end entity top_level;

architecture behavioral of top_level is

  component clk_pll is
    port (
      clk100mhz_in : in    std_logic;
      clk40mhz     : out   std_logic
    );
  end component;

  component counter is
    generic (
      nbit         : integer;
      length       : integer;
      front_porch  : integer;
      sync_pulse   : integer;
      back_porch   : integer;
      visible_area : integer
    );
    port (
      clk      : in    std_logic;
      rst      : in    std_logic;
      count    : out   std_logic_vector(NBIT - 1 downto 0);
      sync     : out   std_logic;
      display  : out   std_logic;
      overflow : out   std_logic
    );
  end component;

  signal sig_clk40mhz   : std_logic;
  signal sig_h_count    : std_logic_vector(10 downto 0);
  signal sig_v_count    : std_logic_vector(10 downto 0);
  signal sig_h_overflow : std_logic;

  --! HAVEN'T BEEN USED YET
  signal sig_h_sync     : std_logic;
  signal sig_v_sync     : std_logic;
  signal sig_h_display  : std_logic;
  signal sig_v_display  : std_logic;
  signal sig_v_overflow : std_logic;

begin

  pll : component clk_pll
    port map (
      clk100mhz_in => clk100mhz,
      clk40mhz     => sig_clk40mhz
    );

  h_couter : component counter
    generic map (
      nbit         => 11,
      length       => 1056,
      front_porch  => 40,
      sync_pulse   => 128,
      back_porch   => 88,
      visible_area => 800
    )
    port map (
      clk      => sig_clk40mhz,
      rst      => btnc,
      count    => sig_h_count,
      sync     => vga_hs,
      display  => sig_h_display,
      overflow => sig_h_overflow
    );

  v_couter : component counter
    generic map (
      nbit         => 10,
      length       => 628,
      front_porch  => 1,
      sync_pulse   => 4,
      back_porch   => 23,
      visible_area => 600
    )
    port map (
      clk      => sig_h_overflow,
      rst      => btnc,
      count    => sig_v_count,
      sync     => vga_vs,
      display  => sig_v_display,
      overflow => sig_v_overflow
    );

end architecture behavioral;
