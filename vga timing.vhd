library ieee ;
use ieee . std_logic_1164 .all;
use ieee . numeric_std .all;
entity vga_timing is
port (
clk : in std_logic ;
rst : in std_logic ;
hsync : out std_logic ;
vsync : out std_logic ;
de : out std_logic ;
x : out unsigned (9 downto 0);
y : out unsigned (9 downto 0)
);
end entity ;
architecture rtl of vga_timing is
constant H_VISIBLE : integer := 640;
constant H_FRONT : integer := 16;
constant H_SYNC : integer := 96;
constant H_BACK : integer := 48;
constant H_TOTAL : integer := 800;
constant V_VISIBLE : integer := 480;
constant V_FRONT : integer := 10;
constant V_SYNC : integer := 2;
constant V_BACK : integer := 33;
constant V_TOTAL : integer := 525;
signal hc : integer range 0 to H_TOTAL -1 := 0;
signal vc : integer range 0 to V_TOTAL -1 := 0;
begin
process (clk )
begin
if rising_edge (clk ) then
if rst =’1’ then
hc <= 0;
vc <= 0;
  else
if hc = H_TOTAL -1 then
hc <= 0;
if vc = V_TOTAL -1 then
vc <= 0;
else
vc <= vc + 1;
end if;
else
hc <= hc + 1;
end if;
end if;
end if;
end process ;
de <= ’1’ when (hc < H_VISIBLE and vc < V_VISIBLE ) else ’0’;
x <= to_unsigned (hc , x’ length ) when (hc < H_VISIBLE ) else
( others =>’0’);
y <= to_unsigned (vc , y’ length ) when (vc < V_VISIBLE ) else
( others =>’0’);
hsync <= ’0’ when (hc >= H_VISIBLE + H_FRONT and hc < H_VISIBLE
+
H_FRONT + H_SYNC ) else ’1’;
vsync <= ’0’ when (vc >= V_VISIBLE + V_FRONT and vc < V_VISIBLE
+
V_FRONT + V_SYNC ) else ’1’;
end architecture ;
