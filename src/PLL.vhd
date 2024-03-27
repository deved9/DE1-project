----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2024 01:18:19 PM
-- Design Name: 
-- Module Name: skvelejmeno - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PLL is
  Port (
    CLK100MHZ: in std_logic ;
    vystup: out std_logic
   );
end PLL;

architecture Behavioral of PLL is



    component CLK_PLL is
        port(
            CLK100MHZ_IN : in std_logic;
            CLK40MHZ : out std_logic
        );
    end component;
    
    begin
    
        PLL : CLK_PLL
        port map(   CLK100MHZ_IN => CLK100MHZ,
                    CLK40MHZ => vystup
                );
end Behavioral;
