library ieee ;
use ieee . std_logic_1164 .all;
use ieee . numeric_std .all;
entity top_hud_final is
port (
clk100MHz : in std_logic ;
btnC : in std_logic ;
vgaRed : out std_logic_vector (3 downto 0);
vgaGreen : out std_logic_vector (3 downto 0);
vgaBlue : out std_logic_vector (3 downto 0);
Hsync : out std_logic ;
Vsync : out std_logic
);
end entity ;
architecture rtl of top_hud_final is
signal rst : std_logic ;
signal pix_clk : std_logic := ’0’;
signal div_cnt : unsigned (1 downto 0) := ( others => ’0’);
signal de : std_logic ;
signal x, y : unsigned (9 downto 0);
signal rgb_bg : std_logic_vector (11 downto 0);
signal white_on : std_logic ;
signal white_rgb : std_logic_vector (11 downto 0);
signal jet_on : std_logic ;
signal jet_rgb : std_logic_vector (11 downto 0);
signal yellow_on : std_logic ;
signal yellow_rgb : std_logic_vector (11 downto 0);
signal rgb_out : std_logic_vector (11 downto 0);
begin
rst <= btnC ;
process ( clk100MHz )
begin
if rising_edge ( clk100MHz ) then
if rst =’1’ then
div_cnt <= ( others =>’0’);
pix_clk <= ’0’;
else
div_cnt <= div_cnt + 1;
pix_clk <= div_cnt (1) ;
end if;
end if;
end process ;
U_TIMING : entity work . vga_timing
port map (
clk => pix_clk ,
rst => rst ,
hsync => Hsync ,
vsync => Vsync ,
de => de ,
x => x,
y => y
);
U_BG : entity work . hud_background_realistic
port map (
clk => pix_clk ,
de => de ,
x => x,
y => y,
rgb => rgb_bg
);
U_SYM : entity work . hud_symbology_final
port map (
clk => pix_clk ,
de => de ,
x => x,
y => y,
white_on => white_on ,
white_rgb => white_rgb ,
jet_on => jet_on ,
  jet_rgb => jet_rgb ,
yellow_on => yellow_on ,
yellow_rgb => yellow_rgb
);
U_OVL : entity work . overlay_engine
port map (
clk => pix_clk ,
de => de ,
rgb_bg => rgb_bg ,
white_on => white_on ,
white_rgb => white_rgb ,
jet_on => jet_on ,
jet_rgb => jet_rgb ,
yellow_on => yellow_on ,
yellow_rgb => yellow_rgb ,
rgb_out => rgb_out
);
vgaRed <= rgb_out (11 downto 8);
vgaGreen <= rgb_out (7 downto 4);
vgaBlue <= rgb_out (3 downto 0);
end architecture ;
