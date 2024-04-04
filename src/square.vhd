library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.math_real.ALL;

entity square is
    generic(
        v_nbit: integer := 11;
        h_nbit: integer := 10;
        rowOffset: integer := 0;
        colOffset: integer := 0;
        size: integer := 250;
        R: integer := 15;
        G: integer := 15;
        B: integer := 15
        );
    Port (
        rowNum: in std_logic_vector( v_nbit - 1 downto 0);
        colNum: in std_logic_vector( h_nbit - 1 downto 0);
        colorR: out std_logic_vector( 3 downto 0);
        colorG: out std_logic_vector( 3 downto 0);
        colorB: out std_logic_vector( 3 downto 0)
      );
  end SQUARE;

  architecture behavioral of square is

    signal rowInRange : std_logic;
    signal colInRange : std_logic;

  begin
  
    process (rowNum, colNum)
    begin
        rowInRange <= '0';
        if ((to_integer(unsigned(rowNum)) >= rowOffset) and (to_integer(unsigned(rowNum)) < (rowOffset + size))) then
            rowInRange <= '1';
        end if;

        colInRange <= '0';
        if ((to_integer(unsigned(colNum)) >= colOffset) and (to_integer(unsigned(colNum)) < (colOffset + size))) then
            colInRange <= '1';
        end if;


        if (rowInRange = '1' and colInRange = '1') then
            colorR <= std_logic_vector(to_unsigned(R, colorR'length));
            colorG <= std_logic_vector(to_unsigned(G, colorG'length));
            colorB <= std_logic_vector(to_unsigned(B, colorB'length));
        else
            colorR <= b"0000";
            colorG <= b"0000";
            colorB <= b"0000";
        end if;
    end process;

  end architecture;