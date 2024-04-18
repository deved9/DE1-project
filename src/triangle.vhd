library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.math_real.ALL;

entity triangle is
    generic (
        v_nbit: integer := 10;
        h_nbit: integer := 11;
        size: integer := 250;
        -- default color is white
        R: integer := 15;
        G: integer := 15;
        B: integer := 15
    );
    port (
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
end triangle;

architecture bahavioral of triangle is

    signal rowInRange : std_logic := '0';
    signal colInRange : std_logic := '0';
    signal count_up : std_logic := '0';
    signal triangle_width : unsigned(v_nbit - 1 downto 0);
    signal last_rowNum : std_logic_vector( v_nbit - 1 downto 0);
    signal last_colNum : std_logic_vector( h_nbit - 1 downto 0);



  begin
  
    process (colNum)
    begin
        -- calculate triangle width on current row
        triangle_width <= (unsigned(rowNum) - unsigned(rowOffset))/2;
        
        -- check if current column number is in range for shape
        colInRange <= '0';
        if ((unsigned(colNum) > (unsigned(colOffset) + to_unsigned(size, h_nbit)/2 - triangle_width )) and
        (unsigned(colNum) < (unsigned(colOffset) + to_unsigned(size, h_nbit)/2 + triangle_width))) then
            colInRange <= '1';
        end if;
        
        -- check if current row number is in range for shape
        rowInRange <= '0';
        if ((unsigned(rowNum) >= unsigned(rowOffset)) and (unsigned(rowNum) < (unsigned(rowOffset) + size))) then
            rowInRange <= '1';
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