library ieee;
  use ieee.std_logic_1164.all;

entity top_level is
  port (
    clk100mhz : in    std_logic;
    sw        : in    std_logic_vector(15 downto 0);
    btnc      : in    std_logic;
    btnu      : in    std_logic;
    btnl      : in    std_logic;
    btnr      : in    std_logic;
    btnd      : in    std_logic;
    vga_r     : out   std_logic_vector(3 downto 0);
    vga_g     : out   std_logic_vector(3 downto 0);
    vga_b     : out   std_logic_vector(3 downto 0);
    vga_hs    : out   std_logic;
    vga_vs    : out   std_logic
  );
end entity top_level;

architecture behavioral of top_level is

  component clk_pll is
    port (
      clk100mhz_in : in    std_logic;
      clk40mhz     : out   std_logic
    );
  end component;

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

  component shapes is
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
        shape_sel : in std_logic;
        colorRbackground : in std_logic_vector( 3 downto 0);
        colorGbackground : in std_logic_vector( 3 downto 0);
        colorBbackground : in std_logic_vector( 3 downto 0);
        colorRout: out std_logic_vector( 3 downto 0);
        colorGout: out std_logic_vector( 3 downto 0);
        colorBout: out std_logic_vector( 3 downto 0)
      );
  end component;

  signal sig_clk40mhz   : std_logic;

  signal sig_h_count    : std_logic_vector(10 downto 0);
  signal sig_v_count    : std_logic_vector(10 downto 0);
  
  signal sig_h_overflow : std_logic;
  signal sig_v_overflow : std_logic;
  
  signal sig_h_sync     : std_logic;  -- Not used
  signal sig_v_sync     : std_logic;

  signal sig_h_display  : std_logic;
  signal sig_v_display  : std_logic;

  signal sig_colorR : std_logic_vector (3 downto 0);
  signal sig_colorG : std_logic_vector (3 downto 0);
  signal sig_colorB : std_logic_vector (3 downto 0);

begin

  pll : component clk_pll
    port map (
      clk100mhz_in => clk100mhz,
      clk40mhz     => sig_clk40mhz
    );

  h_couter : component counter
    generic map (
      nbit         => 11,
      length       => 1056,
      front_porch  => 40,
      sync_pulse   => 128,
      back_porch   => 88,
      visible_area => 800
    )
    port map (
      clk      => sig_clk40mhz,
      rst      => btnc,
      count    => sig_h_count,
      sync     => vga_hs,
      display  => sig_h_display,
      overflow => sig_h_overflow
    );

  v_couter : component counter
    generic map (
      nbit         => 10,
      length       => 628,
      front_porch  => 1,
      sync_pulse   => 4,
      back_porch   => 23,
      visible_area => 600
    )
    port map (
      clk      => sig_h_overflow,
      rst      => btnc,
      count    => sig_v_count,
      sync     => sig_v_sync,
      display  => sig_v_display,
      overflow => sig_v_overflow
    );

  shape_generator: component shapes
    generic map (
      scr_width => 800,
      scr_height => 600,
      size => 250,
      v_nbit => 10,
      h_nbit => 11
    )
    port map (
      rowNum => sig_v_count,
      colNum => sig_h_count,
      count => sig_v_sync,
      move_u => BTNU,
      move_d => BTND,
      move_l => BTNL,
      move_r => BTNR,
      shape_sel => SW(15),
      colorRbackground => b"0000",
      colorGbackground => b"0000",
      colorBbackground => b"0000",
      colorRout => sig_colorR,
      colorGout => sig_colorG,
      colorBout => sig_colorB
    );

    vga_vs <= sig_v_sync;

    -- DO NOT output color when outside display area
    vga_r <= sig_colorR when (sig_v_display = '1' and sig_h_display = '1') else b"0000";
    vga_g <= sig_colorG when (sig_v_display = '1' and sig_h_display = '1') else b"0000";
    vga_b <= sig_colorB when (sig_v_display = '1' and sig_h_display = '1') else b"0000";

end architecture behavioral;
