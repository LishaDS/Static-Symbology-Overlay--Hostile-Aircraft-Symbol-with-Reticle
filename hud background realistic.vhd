library ieee ;
use ieee . std_logic_1164 .all;
use ieee . numeric_std .all;
entity hud_background_realistic is
port (
clk : in std_logic ;
de : in std_logic ;
x : in unsigned (9 downto 0);
y : in unsigned (9 downto 0);
rgb : out std_logic_vector (11 downto 0)
);
end entity ;
architecture rtl of hud_background_realistic is
begin
process (clk )
variable xi , yi : integer ;
variable r, g, b : integer range 0 to 15;
variable band : integer ;
begin
if rising_edge (clk ) then
if de=’1’ then
  xi := to_integer (x);
yi := to_integer (y);
if yi < 360 then
-- Sky : 3/4 screen , smooth blue gradient
r := 1 + yi / 140;
g := 6 + yi / 100;
b := 11 + yi / 80;
if r > 5 then r := 5; end if;
if g > 11 then g := 11; end if;
if b > 15 then b := 15; end if;
-- subtle wide variation
if (( xi / 80) mod 2) = 1 then
if g < 15 then g := g + 1; end if;
end if;
else
-- Ground : last 1/4 only , muted green terrain
band := (( xi / 64) + (yi / 20) ) mod 3;
case band is
when 0 =>
r := 2; g := 6; b := 2;
when 1 =>
r := 3; g := 7; b := 2;
when others =>
r := 2; g := 5; b := 2;
end case ;
-- darker toward bottom
if yi > 420 then
if g > 0 then g := g - 1; end if;
end if;
end if;
rgb <= std_logic_vector (
to_unsigned (r ,4) &
to_unsigned (g ,4) &
to_unsigned (b ,4)
);
else
rgb <= ( others =>’0’);
end if;
end if;
end process ;
end architecture ;
