library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Jump_Adder is

port(

    PC4: in std_logic_vector(31 downto 0) := (others=>'0');

 Sign_Extend_out: in  std_logic_vector(31 downto 0) := (others=>'0');

    Adder_out: out std_logic_vector (31 downto 0) := (others=>'0')

  );

end Jump_Adder;

architecture Behavioral of Jump_Adder is

signal adder_signal : std_logic_vector(31 downto 0) := (others=>'0');

begin

adder_signal <= Sign_Extend_out (29 downto 0) & "00";
Adder_out <= std_logic_vector(unsigned(PC4) +unsigned(adder_signal));

end Behavioral;
