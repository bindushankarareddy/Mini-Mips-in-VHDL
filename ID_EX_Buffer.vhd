--Buffer Id Exe:

library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity ID_EX_Buffer is

generic (width: integer:=31);



port(

clk,flush: in std_logic:='0';



            Reg_W_Decode: in std_logic:='0';

	    MR_Mux_Sel: in std_logic:='0';

	    Mem_Write: in std_logic:='0';

	    ALU_Mux_Sel: in std_logic:='0';

	    Reg_Mux_Sel: in std_logic:='0';



            ALU_Control : in std_logic_vector(2 downto 0) := (others=>'0');

            RF_Reg1: in  std_logic_vector(4 downto 0) := (others=>'0');

RF_Reg2: in  std_logic_vector(4 downto 0) := (others=>'0');

RF_RegW: in  std_logic_vector(4 downto 0) := (others=>'0');

            Exe_1: in std_logic_vector(width downto 0) := (others=>'0');

Exe_2: in std_logic_vector(width downto 0) := (others=>'0');

Sign_decode: in std_logic_vector(width downto 0) := (others=>'0');



            Exe_WReg: out std_logic:='0';

Exe_MReg: out std_logic:='0';

Exe_MemW: out std_logic:='0';

            Exe_ALU: out std_logic:='0';

Exe_Reg : out std_logic:='0';

            Exe_ALU_Control: out std_logic_vector(2 downto 0) := (others=>'0');

            Ex_Rs: out std_logic_vector(4 downto 0) := (others=>'0');

Ex_Rt: out std_logic_vector(4 downto 0) := (others=>'0');

Ex_Rd: out std_logic_vector(4 downto 0) := (others=>'0');

            IE_out1: out std_logic_vector(width downto 0) := (others=>'0') ;

IE_out2: out std_logic_vector(width downto 0) := (others=>'0') ;

Ex_Sign: out std_logic_vector(width downto 0) := (others=>'0')

  );

end ID_EX_Buffer;













architecture Behavioral of ID_EX_Buffer is

signal temp : std_logic_vector(31 downto 0) := (others=>'0');

begin

process(clk)

begin

if(falling_edge(clk)) then

if(flush ='0') then



      Exe_WReg   <=  Reg_W_Decode;

      Exe_MReg   <=  MR_Mux_Sel;

      Exe_MemW   <=  Mem_Write;

      Exe_ALU     <=  ALU_Mux_Sel;

      Exe_Reg     <=  Reg_Mux_Sel;

      Exe_ALU_Control <=  ALU_Control;



      Ex_Rs <=  RF_Reg1;

      Ex_Rt <=  RF_Reg2;

      Ex_Rd <=  RF_RegW;



      IE_out1 <=  Exe_1;

      IE_out2 <=  Exe_2;

      Ex_Sign <=  Sign_decode;

end if;

end if;

end process;



end Behavioral;
