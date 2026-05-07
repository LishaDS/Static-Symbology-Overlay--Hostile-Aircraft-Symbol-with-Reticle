library ieee ;
use ieee . std_logic_1164 .all;
use ieee . numeric_std .all;
entity hud_symbology_final is
port (
clk : in std_logic ;
de : in std_logic ;
x : in unsigned (9 downto 0);
y : in unsigned (9 downto 0);
white_on : out std_logic ;
white_rgb : out std_logic_vector (11 downto 0);
jet_on : out std_logic ;
jet_rgb : out std_logic_vector (11 downto 0);
yellow_on : out std_logic ;
yellow_rgb : out std_logic_vector (11 downto 0)
);
end entity ;
architecture rtl of hud_symbology_final is
constant WHITE : std_logic_vector (11 downto 0) := x"FFF ";
constant YELLOW : std_logic_vector (11 downto 0) := x"FF0 ";
constant GRAY1 : std_logic_vector (11 downto 0) := x"AAA ";
constant GRAY2 : std_logic_vector (11 downto 0) := x "555";
constant CX : integer := 320;
constant CY : integer := 205; -- aircraft sits in sky
constant HORIZON_Y : integer := 360;
-- Jet body bounding box
constant JL : integer := CX - 48;
constant JR : integer := CX + 48;
constant JT : integer := CY - 34;
constant JB : integer := CY + 28;
-- Reticle centered on target jet
constant RX : integer := CX;
constant RY : integer := CY;
constant RR_IN : integer := 20*20;
constant RR_OUT : integer := 22*22;
signal xi , yi : integer range 0 to 1023;
function glyph (c : character ; row : integer ) return
std_logic_vector
is
variable g : std_logic_vector (7 downto 0) := ( others => ’0’);
begin
case c is
when ’0’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x"6E";
when 3 => g:=x "76";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’1’ => case row is
when 0 => g:=x "18"; when 1 => g:=x "38"; when 2 => g:=x "18";
when 3 => g:=x "18";
when 4 => g:=x "18"; when 5 => g:=x "18"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’2’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "06";
when 3 => g:=x"1C";
when 4 => g:=x "30"; when 5 => g:=x "60"; when 6 => g:=x"7E";
when others => g:=x "00"; end case ;
when ’5’ => case row is
when 0 => g:=x"7E"; when 1 => g:=x "60"; when 2 => g:=x"7C";
when 3 => g:=x "06";
when 4 => g:=x "06"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’8’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x"3C";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’9’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x"3E";
when 4 => g:=x "06"; when 5 => g:=x"0C"; when 6 => g:=x "38";
when others => g:=x "00"; end case ;
when ’:’ => case row is
when 1 => g:=x "18"; when 2 => g:=x "18"; when 4 => g:=x "18";
when 5 => g:=x "18"; when others => g:=x "00"; end case ;
when ’=’ => case row is
when 2 => g:=x"7E"; when 4 => g:=x"7E"; when others =>
g:=x "00"; end case ;
when ’>’ => case row is
when 1 => g:=x "60"; when 2 => g:=x "30"; when 3 => g:=x "18";
when 4 => g:=x "30"; when 5 => g:=x "60"; when others => g:=x
"00"; end
  case ;
when ’A’ => case row is
when 0 => g:=x "18"; when 1 => g:=x"3C"; when 2 => g:=x "66";
when 3 => g:=x "66";
when 4 => g:=x"7E"; when 5 => g:=x "66"; when 6 => g:=x "66";
when others => g:=x "00"; end case ;
when ’C’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "60";
when 3 => g:=x "60";
when 4 => g:=x "60"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’D’ => case row is
when 0 => g:=x"7C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x "66";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"7C";
when others => g:=x "00"; end case ;
when ’E’ => case row is
when 0 => g:=x"7E"; when 1 => g:=x "60"; when 2 => g:=x "60";
when 3 => g:=x"7C";
when 4 => g:=x "60"; when 5 => g:=x "60"; when 6 => g:=x"7E";
when others => g:=x "00"; end case ;
when ’G’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "60";
when 3 => g:=x"6E";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"3E";
when others => g:=x "00"; end case ;
when ’H’ => case row is
when 0 => g:=x "66"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x"7E";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x "66";
when others => g:=x "00"; end case ;
when ’I’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "18"; when 2 => g:=x "18";
when 3 => g:=x "18";
when 4 => g:=x "18"; when 5 => g:=x "18"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’K’ => case row is
when 0 => g:=x "66"; when 1 => g:=x"6C"; when 2 => g:=x "78";
when 3 => g:=x "70";
when 4 => g:=x "78"; when 5 => g:=x"6C"; when 6 => g:=x "66";
when others => g:=x "00"; end case ;
when ’L’ => case row is
when 0 => g:=x "60"; when 1 => g:=x "60"; when 2 => g:=x "60";
when 3 => g:=x "60";
when 4 => g:=x "60"; when 5 => g:=x "60"; when 6 => g:=x"7E";
when others => g:=x "00"; end case ;
when ’M’ => case row is
when 0 => g:=x "63"; when 1 => g:=x "77"; when 2 => g:=x"7F";
when 3 => g:=x"6B";
when 4 => g:=x "63"; when 5 => g:=x "63"; when 6 => g:=x "63";
when others => g:=x "00"; end case ;
when ’N’ => case row is
when 0 => g:=x "66"; when 1 => g:=x "76"; when 2 => g:=x"7E";
when 3 => g:=x"7E";
when 4 => g:=x"6E"; when 5 => g:=x "66"; when 6 => g:=x "66";
when others => g:=x "00"; end case ;
when ’O’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x "66";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’P’ => case row is
when 0 => g:=x"7C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x"7C";
when 4 => g:=x "60"; when 5 => g:=x "60"; when 6 => g:=x "60";
when others => g:=x "00"; end case ;
when ’R’ => case row is
when 0 => g:=x"7C"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x"7C";
when 4 => g:=x"6C"; when 5 => g:=x "66"; when 6 => g:=x "66";
when others => g:=x "00"; end case ;
when ’S’ => case row is
when 0 => g:=x"3C"; when 1 => g:=x "66"; when 2 => g:=x "30";
when 3 => g:=x "18";
when 4 => g:=x"0C"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’T’ => case row is
when 0 => g:=x"7E"; when 1 => g:=x"5A"; when 2 => g:=x "18";
when 3 => g:=x "18";
when 4 => g:=x "18"; when 5 => g:=x "18"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’U’ => case row is
when 0 => g:=x "66"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x "66";
when 4 => g:=x "66"; when 5 => g:=x "66"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
when ’V’ => case row is
when 0 => g:=x "66"; when 1 => g:=x "66"; when 2 => g:=x "66";
when 3 => g:=x "66";
when 4 => g:=x "66"; when 5 => g:=x"3C"; when 6 => g:=x "18";
when others => g:=x "00"; end case ;
when ’W’ => case row is
when 0 => g:=x "63"; when 1 => g:=x "63"; when 2 => g:=x "63";
when 3 => g:=x"6B";
when 4 => g:=x"7F"; when 5 => g:=x "77"; when 6 => g:=x "63";
when others => g:=x "00"; end case ;
when ’Y’ => case row is
when 0 => g:=x "66"; when 1 => g:=x "66"; when 2 => g:=x"3C";
when 3 => g:=x "18";
when 4 => g:=x "18"; when 5 => g:=x "18"; when 6 => g:=x"3C";
when others => g:=x "00"; end case ;
  when ’ ’ => g := x "00";
when others => g := x "00";
end case ;
return g;
end function ;
function text_on (str : string ; px , py , x0 , y0 : integer ) return
std_logic is
variable relx , rely : integer ;
variable chpos , col , row : integer ;
variable c : character ;
variable gg : std_logic_vector (7 downto 0);
begin
if px < x0 or py < y0 then
return ’0’;
end if;
relx := px - x0;
rely := py - y0;
if rely < 0 or rely >= 8 then
return ’0’;
end if;
chpos := relx / 8;
col := relx mod 8;
row := rely ;
if chpos < 0 or chpos >= str ’ length then
return ’0’;
end if;
c := str(str ’low + chpos );
gg := glyph (c, row );
if gg (7- col )=’1’ then
return ’1’;
else
return ’0’;
end if;
end function ;
signal w_on : std_logic ;
signal j_on : std_logic ;
signal y_on : std_logic ;
signal jet_dark : std_logic ;
begin
xi <= to_integer (x);
yi <= to_integer (y);
-- White HUD elements
w_on <= ’1’ when (de=’1’ and (
-- thicker horizon
  (( yi = HORIZON_Y or yi = HORIZON_Y +1) and xi >= 8 and xi <=
631)
or
-- pitch ladder
(( yi = HORIZON_Y -224 or yi = HORIZON_Y +48) and (( xi >= CX -60
and xi <= CX -24) or (xi >=
CX +24 and xi <= CX +60) )) or
(( yi = HORIZON_Y -248 or yi = HORIZON_Y +72) and (( xi >= CX -46
and xi <= CX -18) or (xi >=
CX +18 and xi <= CX +46) )) or
(( yi = HORIZON_Y -272 or yi = HORIZON_Y +96) and (( xi >= CX -34
and xi <= CX -14) or (xi >=
CX +14 and xi <= CX +34) )) or
-- altitude tape line and ticks
(( xi = 70 or xi = 71) and (yi >= 120 and yi <= 360) ) or
(( yi = 160 or yi = 200 or yi = 240 or yi = 280 or yi = 320) and
(xi >= 70 and xi <= 90)) or
-- heading scale and caret
( text_on ("W", xi , yi , 220 , 12) =’1’) or
( text_on ("N", xi , yi , 316 , 12) =’1’) or
( text_on ("E", xi , yi , 412 , 12) =’1’) or
(yi = 30 and (xi = 250 or xi = 285 or xi = 320 or xi = 355 or
xi
= 390) ) or
(( yi = 24 and xi >= 314 and xi <= 326) or
(yi = 25 and xi >= 315 and xi <= 325) or
(yi = 26 and xi >= 316 and xi <= 324) ) or
-- lock brackets around jet
(( yi = JT) and (( xi >= JL and xi <= JL +16) or (xi >= JR -16 and
xi
<= JR))) or
(( yi = JB) and (( xi >= JL and xi <= JL +16) or (xi >= JR -16 and
xi
<= JR))) or
(( xi = JL) and (( yi >= JT and yi <= JT +16) or (yi >= JB -16 and
yi
<= JB))) or
(( xi = JR) and (( yi >= JT and yi <= JT +16) or (yi >= JB -16 and
yi
<= JB))) or
-- labels
( text_on (" LOCK ", xi , yi , JR + 14, CY - 4) =’1’) or
( text_on (" SKY", xi , yi , 12, 28) =’1’) or
( text_on (" GND", xi , yi , 12, 390) =’1’) or
( text_on ("12000" , xi , yi , 8, 152) =’1’) or
( text_on ("11000" , xi , yi , 8, 192) =’1’) or
( text_on ("= > 10000" , xi , yi , 4, 232) =’1’) or
( text_on ("9000" , xi , yi , 16, 272) =’1’) or
( text_on ("8000" , xi , yi , 16, 312) =’1’) or
  ( text_on (" SPD 250" , xi , yi , 520 , 280) =’1’) or
( text_on (" MODE : NAV", xi , yi , 8, 440) =’1’) or
( text_on (" STATUS : LOCK ", xi , yi , 500 , 440) =’1’)
)) else ’0’;
-- Fighter jet silhouette , back view
j_on <= ’1’ when (de=’1’ and (
-- fuselage
(( xi >= CX -6 and xi <= CX +6) and (yi >= CY -26 and yi <= CY +26) )
or
-- canopy / top spine
(( xi >= CX -3 and xi <= CX +3) and (yi >= CY -34 and yi <= CY -27) )
or
-- main wings , swept
(( yi >= CY -6 and yi <= CY +4) and
(xi >= CX -44 + (yi -(CY -6))*2 and xi <= CX -10) ) or
(( yi >= CY -6 and yi <= CY +4) and
(xi >= CX +10 and xi <= CX +44 - (yi -(CY -6))*2)) or
-- wing roots
(( yi >= CY -10 and yi <= CY -6) and
(xi >= CX -20 and xi <= CX +20) ) or
-- tail planes
(( yi >= CY +10 and yi <= CY +16) and
(xi >= CX -24 and xi <= CX -8)) or
(( yi >= CY +10 and yi <= CY +16) and
(xi >= CX +8 and xi <= CX +24) ) or
-- twin tail fins
(( yi >= CY +16 and yi <= CY +28) and
(xi >= CX -12 and xi <= CX -7)) or
(( yi >= CY +16 and yi <= CY +28) and
(xi >= CX +7 and xi <= CX +12) ) or
-- engine block
(( yi >= CY +2 and yi <= CY +16) and (xi >= CX -10 and xi <= CX +10)
)
)) else ’0’;
-- darker parts on jet
jet_dark <= ’1’ when (de=’1’ and (
(( xi >= CX -4 and xi <= CX +4) and (yi >= CY -26 and yi <= CY +24) )
or
(( yi >= CY +4 and yi <= CY +12) and (xi >= CX -8 and xi <= CX +8) )
or
(( yi >= CY -4 and yi <= CY +2) and
(( xi >= CX -26 and xi <= CX -12) or (xi >= CX +12 and xi <=
CX +26) ))
)) else ’0’;
  -- Yellow attack reticle on locked target
y_on <= ’1’ when (de=’1’ and (
(((( xi -RX)*(xi -RX) + (yi -RY)*(yi -RY)) >= RR_IN ) and
((( xi -RX)*(xi -RX) + (yi -RY)*(yi -RY)) <= RR_OUT )) or
(( yi = RY) and (( xi >= RX -34 and xi <= RX -24) or (xi >= RX +24
and
xi <= RX +34) )) or
(( xi = RX) and (( yi >= RY -34 and yi <= RY -24) or (yi >= RY +24
and
yi <= RY +34) ))
)) else ’0’;
process (clk )
begin
if rising_edge (clk ) then
white_on <= w_on ;
white_rgb <= WHITE ;
jet_on <= j_on ;
if jet_dark =’1’ then
jet_rgb <= GRAY2 ;
else
jet_rgb <= GRAY1 ;
end if;
yellow_on <= y_on ;
yellow_rgb <= YELLOW ;
end if;
end process ;
end architecture ;
