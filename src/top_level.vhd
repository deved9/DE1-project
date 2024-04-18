library ieee;
  use ieee.std_logic_1164.all;

entity top_level is
  port (
    CLK100MHZ : in    std_logic;
    SW        : in    std_logic_vector(15 downto 0);
    BTNC      : in    std_logic;
    BTNU      : in    std_logic;
    BTNL      : in    std_logic;
    BTNR      : in    std_logic;
    BTND      : in    std_logic;
    VGA_R     : out   std_logic_vector(3 downto 0);
    VGA_G     : out   std_logic_vector(3 downto 0);
    VGA_B     : out   std_logic_vector(3 downto 0);
    VGA_HS    : out   std_logic;
    VGA_VS    : out   std_logic
  );
end entity top_level;

architecture behavioral of top_level is

  component CLK_PLL is
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
        shape_sel : in std_logic_vector(1 downto 0);
        colorRbackground : in std_logic_vector( 3 downto 0);
        colorGbackground : in std_logic_vector( 3 downto 0);
        colorBbackground : in std_logic_vector( 3 downto 0);
        colorRout: out std_logic_vector( 3 downto 0);
        colorGout: out std_logic_vector( 3 downto 0);
        colorBout: out std_logic_vector( 3 downto 0)
      );
  end component;

  component colours is
    generic(
           scr_width: integer := 800;
           scr_height: integer := 600;
           v_nbit: integer := 10;
           h_nbit: integer := 11
           );
    Port ( SW_TOP_R             : in STD_LOGIC;
           SW_TOP_G             : in STD_LOGIC;
           SW_TOP_B             : in STD_LOGIC;
           SW_BOT_R             : in STD_LOGIC;
           SW_BOT_G             : in STD_LOGIC;
           SW_BOT_B             : in STD_LOGIC;
           SW_DIR               : in STD_LOGIC;
           out_R                : out std_logic_vector (3 downto 0);
           out_G                : out std_logic_vector (3 downto 0);
           out_B                : out std_logic_vector (3 downto 0);
           counter_horz         : in std_logic_vector (10 downto 0);
           counter_vert         : in std_logic_vector (9 downto 0);
           display_horz         : in STD_LOGIC;
           display_vert         : in STD_LOGIC;
           clk                  : in std_logic 
           );
  end component;
  
  signal sig_clk40mhz   : std_logic;

  signal sig_h_count    : std_logic_vector(10 downto 0);
  signal sig_v_count    : std_logic_vector(9 downto 0);
  
  signal sig_h_overflow : std_logic;
  signal sig_v_overflow : std_logic;
  
  signal sig_h_sync     : std_logic;  -- Not used
  signal sig_v_sync     : std_logic;

  signal sig_h_display  : std_logic;
  signal sig_v_display  : std_logic;

  signal sig_colorR : std_logic_vector (3 downto 0);
  signal sig_colorG : std_logic_vector (3 downto 0);
  signal sig_colorB : std_logic_vector (3 downto 0);
  
  signal sig_colorR_background : std_logic_vector (3 downto 0);
  signal sig_colorG_background : std_logic_vector (3 downto 0);
  signal sig_colorB_background : std_logic_vector (3 downto 0);

begin

  pll_clk : component CLK_PLL
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
      rst      => BTNC,
      count    => sig_h_count,
      sync     => VGA_HS,
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
      rst      => BTNC,
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
      shape_sel => SW(15 downto 14),
      colorRbackground => sig_colorR_background,
      colorGbackground => sig_colorG_background,
      colorBbackground => sig_colorB_background,
      colorRout => sig_colorR,
      colorGout => sig_colorG,
      colorBout => sig_colorB
    );
    
    colours_gen: component colours
    generic map (
        scr_width => 800,
        scr_height => 600,
        v_nbit => 10,
        h_nbit => 11
     )
     port map (
        SW_TOP_R => SW(0),         
        SW_TOP_G => SW(1),
        SW_TOP_B => SW(2),
        SW_BOT_R => SW(3),
        SW_BOT_G => SW(4),
        SW_BOT_B => SW(5),
        SW_DIR => SW(6),
        out_R => sig_colorR_background,  
        out_G => sig_colorG_background,          
        out_B => sig_colorB_background,          
        counter_horz => sig_h_count,   
        counter_vert => sig_v_count,   
        display_horz => sig_h_display,    
        display_vert => sig_v_display,   
        clk => sig_clk40mhz
        );             

    VGA_VS <= sig_v_sync;

    -- DO NOT output color when outside display area
    vga_r <= sig_colorR when (sig_v_display = '1' and sig_h_display = '1') else b"0000";
    vga_g <= sig_colorG when (sig_v_display = '1' and sig_h_display = '1') else b"0000";
    vga_b <= sig_colorB when (sig_v_display = '1' and sig_h_display = '1') else b"0000";

end architecture behavioral;
