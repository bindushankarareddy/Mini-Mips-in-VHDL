--this is the ALU part of the code
--this is the ALU part of the code



library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
port(

clk: in std_logic;

    input_1 : in std_logic_vector(31 downto 0);

    input_2 : in std_logic_vector(31 downto 0);

    ALU_ctl: in std_logic_vector(2 downto 0);

    Output_ALU: out std_logic_vector(31 downto 0)

    );

end ALU;

architecture Behavioral of ALU is

begin

process(clk)

begin

if(rising_edge(clk)) then

case ALU_ctl is

when "010" =>

          Output_ALU  <= std_logic_vector(unsigned (input_1) + unsigned (input_2));



when "110" =>

          Output_ALU  <= std_logic_vector(unsigned (input_1) - unsigned (input_2));



when "000" =>

          Output_ALU  <= std_logic_vector(unsigned (input_1) and  unsigned (input_2));



when "001" =>

          Output_ALU  <= std_logic_vector(unsigned (input_1) xor unsigned (input_2));



when others =>

          Output_ALU <= (others=>'X');



end case;

end if;

end process; 

end Behavioral;

