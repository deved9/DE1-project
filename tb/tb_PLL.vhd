library ieee;
use ieee.std_logic_1164.all;

entity tb_PLL is
end tb_PLL;

architecture tb of tb_PLL is

    component PLL is
        port (CLK100MHZ : in std_logic;
              vystup    : out std_logic);
    end component;

    signal sig_CLK100MHZ : std_logic;
    signal sig_output    : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PLL
    port map (CLK100MHZ => sig_CLK100MHZ,
              vystup    => sig_output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK100MHZ is really your main clock signal
    sig_CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        
        -- EDIT Add stimuli here
        wait for 10 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
