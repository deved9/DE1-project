library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Package for data types conversion

-------------------------------------------------

entity counter is
  generic (
    nbit         : integer := 11; --! Number of bits
    length       : integer := 1056;
    front_porch  : integer := 40;
    sync_pulse   : integer := 128;
    back_porch   : integer := 88;
    visible_area : integer := 800
  );
  port (
    clk      : in    std_logic;                           
    rst      : in    std_logic;                           
    count    : out   std_logic_vector(nbit - 1 downto 0); 
    sync     : out   std_logic;
    display  : out   std_logic;
    overflow : out   std_logic
  );
end entity counter;

-------------------------------------------------

architecture behavioral of counter is

  signal sig_count       : integer range 0 to (2 ** nbit - 1);
  signal sig_sync        : std_logic := '1';
  signal sig_display     : std_logic := '1';
  signal sig_front_porch : integer;
  signal sig_back_porch  : integer;
  signal sig_overflow    : std_logic := '0';

begin

  p_counter : process (clk) is
  begin

    --! Define variables
    sig_front_porch <= visible_area + front_porch;
    sig_back_porch  <= sig_front_porch + sync_pulse;

    if (rising_edge(clk)) then
      --! Check for active RESET
      if (rst = '1') then
        sig_count    <= 0;
        sig_display  <= '1';
        sig_overflow <= '0';
        sig_sync     <= '1';
      else
        --! Check counter overflow
        if (sig_count < length) then
          --! Enable DISPLAY if counter is in visible area
          if (sig_count < visible_area) then
            sig_display <= '1';
          else
            sig_display <= '0';
          end if;
          --! Generate SYNC pulse
          if ((sig_count > sig_front_porch) and (sig_count < sig_back_porch)) then
            sig_sync <= '0';
          else
            sig_sync <= '1';
          end if;
          --! Increment counter
          sig_count    <= sig_count + 1;
          sig_overflow <= '0';
        else
          sig_count    <= 0;
          sig_overflow <= '1';
        end if;
      end if;
    end if;

  end process p_counter;

  -- Assign internal register to output
  -- Note: integer--> unsigned--> std_logic vector
  count    <= std_logic_vector(to_unsigned(sig_count, nbit));
  sync     <= sig_sync;
  display  <= sig_display;
  overflow <= sig_overflow;

end architecture behavioral;

--! sources:
--! http://tinyvga.com/vga-timing/800x600@60Hz
