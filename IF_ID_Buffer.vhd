-- IF/ID stage buffer

library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity IF_ID_Buffer is

generic

  (

size : integer:=42;

width: integer:=31;

addr:   integer:=4

  );

port

  (

clk: in std_logic;

en: in std_logic :='1';

clr: in std_logic_vector(1 downto 0) :=(others =>'0');

      InstR_in : in std_logic_vector(width downto 0):=  (others =>'0');

input : in std_logic_vector(width downto 0):=  (others =>'0');

      Buffer_out: out std_logic_vector(width downto 0):=  (others =>'0');

output : out std_logic_vector(width downto 0):=  (others =>'0')

      ); 

end IF_ID_Buffer;



architecture Behavioral of IF_ID_Buffer is

begin

process(clk)

begin

if(falling_edge(clk) and en='1' and clr="00") then

           Buffer_out <=  InstR_in;

output<=  input;

elsif ((clr="01") or (clr="10")) then

           Buffer_out <= "00000000000000000000000000111100" ; --(others=>'0')

           output<=  "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; --(others=>'0')

end if;

end process;

end Behavioral;
