library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity Decode_MUX is

port (

      mux_in: in std_logic :='0';

      reg_data: in std_logic_vector(31 downto 0):=(others=>'0');

      Output_ALU: in std_logic_vector(31 downto 0):=(others=>'0');

      Mux_output: out std_logic_vector(31 downto 0):=(others=>'0')

    );

end Decode_MUX;



architecture Behavioral of Decode_MUX is

begin

 Mux_output <= reg_data when mux_in = '0' else

           Output_ALU  when mux_in = '1' else (others=>'0');



end Behavioral;
