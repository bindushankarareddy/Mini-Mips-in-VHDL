library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity Fetch_MUX is

port

      (

        Mux_sel : in std_logic_vector(1 downto 0) :=(others=>'0');

        PC4: in std_logic_vector(31 downto 0) :=(others=>'0');

        PC_Branch : in std_logic_vector(31 downto 0) :=(others=>'0');

        Output_m : out std_logic_vector(31 downto 0) :=(others=>'0');
I1 : in std_logic_vector(31 downto 0) :=(others=>'0')

        );

end Fetch_MUX;


architecture Behavioral of Fetch_MUX is

begin

  Output_m <=  PC4 when Mux_sel = "00" else 
PC_Branch  when Mux_sel = "01" else
I1  when Mux_sel = "10" else
PC4;

end Behavioral;
