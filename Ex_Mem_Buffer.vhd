-- EX/Mem Buffer



library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;





entity Ex_Mem_Buffer is

generic (width: integer:=31);

port(

clk: in std_logic:='0';

    Ex_RegW: in std_logic:='0';

    Ex_MReg: in std_logic:='0';

    Ex_MemW: in std_logic:='0';

    Decode_Ex1: in std_logic_vector(31 downto 0) :=  (others =>'0');

    Decode_Ex2: in std_logic_vector(31 downto 0) :=  (others =>'0');

    WB_in: in std_logic_vector(4 downto 0) :=  (others =>'0');

    Mem_Reg_W: out std_logic:='0';

    Mem_Reg_M: out std_logic:='0';

    Mem_Write_M: out std_logic:='0';

    EX_D1: out std_logic_vector(31 downto 0) :=  (others =>'0');

    EX_D2: out std_logic_vector(31 downto 0) :=  (others =>'0');

    Output_WB: out std_logic_vector(4 downto 0) :=  (others =>'0')

    );

end Ex_Mem_Buffer;



architecture Behavioral of Ex_Mem_Buffer is

begin

process(clk)

begin

if(falling_edge(clk)) then

      Mem_Reg_W <= Ex_RegW;

      Mem_Reg_M <= Ex_MReg;

      Mem_Write_M <= Ex_MemW;

      EX_D1   <= Decode_Ex1;

      EX_D2   <= Decode_Ex2;

      Output_WB    <= WB_in;

end if;

end process;

end Behavioral;
