-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 28.2.2024 21:53:41 UTC

library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------

entity tb_counter is
end entity tb_counter;

-------------------------------------------------

architecture tb of tb_counter is

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

  constant c_nbit         : integer := 11;
  constant c_length       : integer := 1056;
  constant c_front_porch  : integer := 40;
  constant c_sync_pulse   : integer := 128;
  constant c_back_porch   : integer := 88;
  constant c_visible_area : integer := 800;

  signal sig_clk      : std_logic;
  signal sig_rst      : std_logic;
  signal sig_count    : std_logic_vector(c_nbit - 1 downto 0);
  signal sig_sync     : std_logic;
  signal sig_display  : std_logic;
  signal sig_overflow : std_logic;

  constant tbperiod   : time      := 25 ns; -- EDIT Put right period here
  signal   tbclock    : std_logic := '0';
  signal   tbsimended : std_logic := '0';

begin

  dut : component counter
    generic map (
      nbit         => c_nbit,
      length       => c_length,
      front_porch  => c_front_porch,
      sync_pulse   => c_sync_pulse,
      back_porch   => c_back_porch,
      visible_area => c_visible_area
    )
    port map (
      clk      => sig_clk,
      rst      => sig_rst,
      count    => sig_count,
      sync     => sig_sync,
      display  => sig_display,
      overflow => sig_overflow
    );

  -- Clock generation
  tbclock <= not tbclock after tbperiod / 2 when tbsimended /= '1' else
             '0';

  -- EDIT: Check that clk is really your main clock signal
  sig_clk <= tbclock;

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
    wait for 50000 ns;

    -- Stop the clock and hence terminate the simulation
    tbsimended <= '1';
    wait;

  end process stimuli;

end architecture tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter of tb_counter is
    for tb
    end for;
end cfg_tb_counter;
