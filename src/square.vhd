library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.math_real.ALL;

entity square is
    generic(
        v_nbit: integer := 10;
        h_nbit: integer := 11;
        size: integer := 250;
        -- default color is white
        R: integer := 15;
        G: integer := 15;
        B: integer := 15
        );
    Port (
        rowNum: in std_logic_vector( v_nbit - 1 downto 0);
        colNum: in std_logic_vector( h_nbit - 1 downto 0);
        rowOffset: in std_logic_vector( v_nbit - 1 downto 0);
        colOffset: in std_logic_vector( h_nbit - 1 downto 0);
        colorRin : in std_logic_vector( 3 downto 0);
        colorGin : in std_logic_vector( 3 downto 0);
        colorBin : in std_logic_vector( 3 downto 0);
        colorRout: out std_logic_vector( 3 downto 0);
        colorGout: out std_logic_vector( 3 downto 0);
        colorBout: out std_logic_vector( 3 downto 0)
      );
  end square;

  architecture behavioral of square is

    signal rowInRange : std_logic;
    signal colInRange : std_logic;

  begin
  
    process (rowNum, colNum)
    begin
        rowInRange <= '0';
        if ((unsigned(rowNum) >= unsigned(rowOffset)) and (unsigned(rowNum) <= (unsigned(rowOffset) + size))) then
            rowInRange <= '1';
        end if;

        colInRange <= '0';
        if ((unsigned(colNum) >= unsigned(colOffset)) and (unsigned(colNum) <= (unsigned(colOffset) + size))) then
            colInRange <= '1';
        end if;

        -- draw shape over background
        if (rowInRange = '1' and colInRange = '1') then
            colorRout <= std_logic_vector(to_unsigned(R, colorRout'length));
            colorGout <= std_logic_vector(to_unsigned(G, colorGout'length));
            colorBout <= std_logic_vector(to_unsigned(B, colorBout'length));
        else
            -- pass background through unchanged
            colorRout <= colorRin;
            colorGout <= colorGin;
            colorBout <= colorBin;
        end if;
    end process;

  end architecture;