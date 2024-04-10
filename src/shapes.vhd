library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.math_real.ALL;


entity shapes is
    generic(
            scr_width: integer := 800;
            scr_height: integer := 600;
            size: integer := 250;
            v_nbit: integer := 10;
            h_nbit: integer := 11
        );
    Port (
        rowNum : in std_logic_vector( v_nbit - 1 downto 0);
        colNum: in std_logic_vector( h_nbit - 1 downto 0);
        count : in std_logic;
        move_u : in std_logic;
        move_d : in std_logic;
        move_l : in std_logic;
        move_r : in std_logic;
        shape_sel : in std_logic_vector(1 downto 0);
        colorRbackground : in std_logic_vector( 3 downto 0);
        colorGbackground : in std_logic_vector( 3 downto 0);
        colorBbackground : in std_logic_vector( 3 downto 0);
        colorRout: out std_logic_vector( 3 downto 0);
        colorGout: out std_logic_vector( 3 downto 0);
        colorBout: out std_logic_vector( 3 downto 0)
      );
  end shapes;

  architecture behavioral of shapes is

    component square is
        generic(
            v_nbit: integer := 11;
            h_nbit: integer := 10;
            size: integer := 250;
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
      end component;
    
      component triangle is
        generic(
            v_nbit: integer := 11;
            h_nbit: integer := 10;
            size: integer := 250;
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
      end component;

      signal v_offset : unsigned(v_nbit-1 downto 0) := (others => '0');
      signal h_offset : unsigned(h_nbit-1 downto 0) := (others => '0');

      signal sig_shape_sel : std_logic_vector(1 downto 0) := b"00";

      signal colorRsq, colorGsq, colorBsq : std_logic_vector(3 downto 0);

      signal colorRtr, colorGtr, colorBtr : std_logic_vector(3 downto 0);
      
  begin
    
    sq: component square
        generic map (
            v_nbit => v_nbit,
            h_nbit => h_nbit,
            size => size,
            -- default color is white
            R => 15,
            G => 15,
            B => 15
        )
        port map (
            rowNum => rowNum,
            colNum => colNum,
            rowOffset => std_logic_vector(v_offset),
            colOffset => std_logic_vector(h_offset),
            colorRin => colorRbackground,
            colorGin => colorGbackground,
            colorBin => colorBbackground,
            colorRout => colorRsq,
            colorGout => colorGsq,
            colorBout => colorBsq
        );


    tr: component triangle
        generic map (
            v_nbit => v_nbit,
            h_nbit => h_nbit,
            size => size,
            -- default color is white
            R => 15,
            G => 15,
            B => 15
        )
        port map (
            rowNum => rowNum,
            colNum => colNum,
            rowOffset => std_logic_vector(v_offset),
            colOffset => std_logic_vector(h_offset),
            colorRin => colorRbackground,
            colorGin => colorGbackground,
            colorBin => colorBbackground,
            colorRout => colorRtr,
            colorGout => colorGtr,
            colorBout => colorBtr
        );


    process (count)
    begin
        if rising_edge(count) then
            if (move_u = '1' and (to_integer(unsigned(v_offset)) > 1)) then
                v_offset <= v_offset - 1;
            end if;
            if (move_d = '1' and (to_integer(unsigned(v_offset + size + 1)) < scr_height)) then
                v_offset <= v_offset + 1;
            end if;  
            if (move_l = '1' and (to_integer(unsigned(h_offset)) > 1)) then
                v_offset <= v_offset - 1;
            end if;
            if (move_r = '1' and (to_integer(unsigned(h_offset + size + 1)) < scr_width)) then
                v_offset <= v_offset + 1;
            end if;

            sig_shape_sel <= shape_sel;
        end if;
    end process;

    colorRout <= colorRtr when sig_shape_sel = b"01" else colorRtr when sig_shape_sel = b"10" else colorRbackground;
    colorGout <= colorGtr when sig_shape_sel = b"01" else colorGtr when sig_shape_sel = b"10" else colorGbackground;
    colorBout <= colorBtr when sig_shape_sel = b"01" else colorBtr when sig_shape_sel = b"10" else colorBbackground;

  end architecture;