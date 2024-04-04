-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 4.4.2024 07:58:14 UTC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_square is
end tb_square;

architecture tb of tb_square is

  constant v_nbit : integer := 10;
  constant h_nbit : integer := 11;
    

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
      count    : out   std_logic_vector(nbit - 1 downto 0);
      sync     : out   std_logic;
      display  : out   std_logic;
      overflow : out   std_logic
    );
  end component;

  component square
    generic(
        v_nbit: integer;
        h_nbit: integer;
        rowOffset: integer;
        colOffset: integer;
        size: integer;
        R: integer := 15;
        G: integer := 15;
        B: integer := 15
        );
    port (rowNum : in std_logic_vector (v_nbit - 1 downto 0);
          colNum : in std_logic_vector (h_nbit - 1 downto 0);
          colorR : out std_logic_vector (3 downto 0);
          colorG : out std_logic_vector (3 downto 0);
          colorB : out std_logic_vector (3 downto 0));
end component;

  signal sig_clk40mhz   : std_logic;
  signal sig_h_count    : std_logic_vector(10 downto 0);
  signal sig_v_count    : std_logic_vector(9 downto 0);
  signal sig_h_overflow : std_logic;

  --! HAVEN'T BEEN USED YET
  signal sig_h_display  : std_logic;
  signal sig_v_display  : std_logic;
  signal sig_v_overflow : std_logic;

  signal sig_colorR : std_logic_vector (3 downto 0);
  signal sig_colorG : std_logic_vector (3 downto 0);
  signal sig_colorB : std_logic_vector (3 downto 0);

  signal sig_rst : std_logic := '0';
  signal vga_vs, vga_hs : std_logic;

  constant tbperiod   : time      := 25 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin
  h_couter : component counter
    generic map (
      nbit         => h_nbit,
      length       => 1056,
      front_porch  => 40,
      sync_pulse   => 128,
      back_porch   => 88,
      visible_area => 800
    )
    port map (
      clk      => sig_clk40mhz,
      rst      => sig_rst,
      count    => sig_h_count,
      sync     => vga_hs,
      display  => sig_h_display,
      overflow => sig_h_overflow
    );

  v_couter : component counter
    generic map (
      nbit         => v_nbit,
      length       => 628,
      front_porch  => 1,
      sync_pulse   => 4,
      back_porch   => 23,
      visible_area => 600
    )
    port map (
      clk      => sig_h_overflow,
      rst      => sig_rst,
      count    => sig_v_count,
      sync     => vga_vs,
      display  => sig_v_display,
      overflow => sig_v_overflow
    );

    sq : component square
    generic map(
        v_nbit => v_nbit,
        h_nbit => h_nbit,
        rowOffset => 16,
        colOffset => 16,
        size => 250
    )
    port map (rowNum => sig_v_count,
              colNum => sig_h_count,
              colorR => sig_colorR,
              colorG => sig_colorG,
              colorB => sig_colorB);

        -- Clock generation
    tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    sig_clk40mhz <= tbclock;

    stimuli : process is
    begin

    -- Reset generation
    -- EDIT: Check that rst is really your reset signal
    sig_rst <= '1';
    wait for 100 ns;
    sig_rst <= '0';
    wait for 100 ns;

    -- EDIT Add stimuli here
    wait for 100 * tbperiod;
    sig_rst <= '1';
    wait for 100 ns;
    sig_rst <= '0';
    wait for 16579200 ns;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

    end process stimuli;
end tb;