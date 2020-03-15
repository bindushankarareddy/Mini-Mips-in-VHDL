library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

 

entity Branch_Det is

  port(

    Bra_Det: in std_logic_vector(1 downto 0):=(others=>'0'); -- To detect Branch and Jump

    Input_1: in std_logic_vector(31 downto 0);

    Input_2: in std_logic_vector(31 downto 0);

    Output_branch: out std_logic_vector(1 downto 0):=(others=>'0') -- To detect Branch and Jump

  );

end Branch_Det;

architecture Behavioral of Branch_Det is

  signal eq : std_logic_vector(31 downto 0);

begin

  Output_branch <= "01" when ((Bra_Det ="01") and (unsigned(Input_1) = unsigned(Input_2)))
else "10" when (Bra_Det ="10")
else "00" when (Bra_Det ="00")
else "11";


--                        else '0';



end Behavioral;
