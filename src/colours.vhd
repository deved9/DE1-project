library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity colours is
    Port ( SW_TOP_R : in STD_LOGIC;
           SW_TOP_G : in STD_LOGIC;
           SW_TOP_B : in STD_LOGIC;
           SW_BOT_R : in STD_LOGIC;
           SW_BOT_G : in STD_LOGIC;
           SW_BOT_B : in STD_LOGIC;
           SW_DIR : in STD_LOGIC;
           out_R : out std_logic_vector (3 downto 0);
           out_G : out std_logic_vector (3 downto 0);
           out_B : out std_logic_vector (3 downto 0);
           counter_horz : in std_logic_vector (11 downto 0);
           counter_vert : in std_logic_vector (11 downto 0);
           display_horz : in STD_LOGIC;
           display_vert : in STD_LOGIC);
end colours;

--800x600
--50x37,5

architecture Behavioral of colours is
    
constant coloursCount : unsigned(3 downto 0) := "1111";
constant vertSegmentCount : unsigned(3 downto 0) := "100110"; --38
constant horzSegmentCount : unsigned(3 downto 0) := "110010"; --50

begin
    process (counter_horz, counter_vert, display_horz, display_vert)
    begin
        if (display_horz = '1' and display_vert = '1') then
            if SW_DIR = '1' then                                                            --vertical colours
                if SW_TOP_R = '1' and SW_BOT_R = '1' then                                       --full red
                    out_R <= "1111";
                elsif SW_TOP_R = '0' and SW_BOT_R = '0' then                                    --no red
                    out_R <= "0000";
                elsif SW_TOP_R = '1' and SW_BOT_R = '0' then                                    --red from top
                    out_R <= unsigned(counter_vert) / vertSegmentCount;
                else                                                                            --red from bottom
                    out_G <= coloursCount - (unsigned(counter_vert) / vertSegmentCount);
                end if;
                if SW_TOP_G = '1' and SW_TOP_G = '1' then                                       --full green
                    out_G <= "1111";
                elsif SW_TOP_G = '0' and SW_TOP_G = '0' then                                    --no green
                    out_G <= "0000";
                elsif SW_TOP_G = '1' and SW_TOP_G = '0' then                                    --green from top
                    out_G <= unsigned(counter_vert) / vertSegmentCount;
                else                                                                            --green from bottom
                    out_G <= coloursCount - (unsigned(counter_vert) / vertSegmentCount);
                end if;
                if SW_TOP_B = '1' and SW_TOP_B = '1' then                                       --full blue
                    out_R <= "1111";
                elsif SW_TOP_B = '0' and SW_TOP_B = '0' then                                    --no blue
                    out_R <= "0000";
                elsif SW_TOP_B = '1' and SW_TOP_B = '0' then                                    --blue from top
                    out_R <= unsigned(counter_vert) / vertSegmentCount;
                else                                                                            --blue from bottom
                    out_R <= coloursCount - (unsigned(counter_vert) / vertSegmentCount);    
                end if;    
            else                                                                            --horizontal colours
            if SW_TOP_R = '1' and SW_BOT_R = '1' then                                           --full red
                    out_R <= "1111";
                elsif SW_TOP_R = '0' and SW_BOT_R = '0' then                                    --no red
                    out_R <= "0000";
                elsif SW_TOP_R = '1' and SW_BOT_R = '0' then                                    --red from left
                    out_R <= unsigned(counter_horz) / horzSegmentCount;
                else                                                                            --red from right
                    out_G <= coloursCount - (unsigned(counter_horz) / horzSegmentCount);
                end if;
                if SW_TOP_G = '1' and SW_TOP_G = '1' then                                       --full green
                    out_G <= "1111";
                elsif SW_TOP_G = '0' and SW_TOP_G = '0' then                                    --no green
                    out_G <= "0000";
                elsif SW_TOP_G = '1' and SW_TOP_G = '0' then                                    --green from left
                    out_G <= unsigned(counter_horz) / horzSegmentCount;
                else                                                                            --green from right
                    out_G <= coloursCount - (unsigned(counter_horz) / horzSegmentCount);
                end if;
                if SW_TOP_B = '1' and SW_TOP_B = '1' then                                       --full blue
                    out_R <= "1111";
                elsif SW_TOP_B = '0' and SW_TOP_B = '0' then                                    --no blue
                    out_R <= "0000";
                elsif SW_TOP_B = '1' and SW_TOP_B = '0' then                                    --blue from left
                    out_R <= unsigned(counter_horz) / horzSegmentCount;
                else                                                                            --blue from right
                    out_R <= coloursCount - (unsigned(counter_horz) / horzSegmentCount);
                end if;    
            end if;
        end if;
    end process;
    
end Behavioral;
