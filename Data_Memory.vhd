-- Data memory

-- width = 32bits, length = 1024 Bytes

library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity Data_Memory is

generic(

datasize: integer:=31;

address: integer:=31;

    mem_length: integer:=4096

  );

port(

clk, Write_Data: in std_logic:='0';

    -- data memory address input is 32 bits inc ase of ALU output and 11 bits to access mem inc ase of load,

    -- data mem data input is the data to be stored in the memory

    DM_Addr_in, DM_Data_in: in std_logic_vector(31 downto 0):=(others=>'0');

    DM_out: out std_logic_vector(31 downto 0):=(others=>'0')

  );

end Data_Memory;



architecture Behavioral of Data_Memory is

  -- array of 256 entries each 4Bytes

type blk is array(0 to mem_length) of std_logic_vector(7 downto 0);

signal signal1: blk:=(others=>(others=>'0'));

signal signal2: std_logic_vector(31 downto 0);



begin

process(clk)

begin

if(rising_edge(clk)) then

if(Write_Data ='1') then

signal1(to_integer(unsigned(signal2(11 downto 0)))) <= DM_Data_in(31 downto 24);

signal1(to_integer(unsigned(signal2(11 downto 0)))+1) <= DM_Data_in(23 downto 16);

signal1(to_integer(unsigned(signal2(11 downto 0)))+2) <= DM_Data_in(15 downto 8);

signal1(to_integer(unsigned(signal2(11 downto 0)))+3) <= DM_Data_in (7 downto 0);

end if;



if(Write_Data ='0') then

DM_out(31 downto 24) <= signal1(to_integer(unsigned(signal2(11 downto 0))));

DM_out(23 downto 16) <= signal1(to_integer(unsigned(signal2(11 downto 0)))+1);

DM_out(15 downto 8) <= signal1(to_integer(unsigned(signal2(11 downto 0)))+2);

DM_out( 7 downto 0) <= signal1(to_integer(unsigned(signal2(11 downto 0)))+3);

end if;

end if;

end process; 

end Behavioral;
