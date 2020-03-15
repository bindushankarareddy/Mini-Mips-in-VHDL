library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity EX_Stage is

port(



clk: in std_logic:='0';

  Ex_RegW, Ex_MReg, Ex_MemW, ALU_S_en, RegDst_en : in std_logic:='X';

  ALUctl_en: in std_logic_vector(2 downto 0) := (others=>'X');

  MUX3_en1,MUX3_en2: in std_logic_vector(1 downto 0) :=  (others =>'0');

  MUX3_Rin1, MUX3_Rin2, MUX2_SignIm, ALUout_mem,ResW: in std_logic_vector(31 downto 0) :=  (others =>'X');

  Ex_Rs, Ex_Rt, RdE  : in std_logic_vector(4 downto 0) :=  (others =>'0');



  Mem_Reg_W, Mem_Reg_M, Mem_Write_M: out std_logic:='X';

ALUout_mem2 : out std_logic_vector(31 downto 0):=(others=>'0');

  Write_DM: out std_logic_vector(31 downto 0):=(others=>'0');

  Output_WBE, Output_WBM: out std_logic_vector(4 downto 0):=(others=>'0')



);

end EX_Stage;



architecture Behavioral of EX_Stage is

--3 input mux for input A

component ThreeIn_MUX is

port(

MUX3_en: in std_logic_vector(1 downto 0) := (others=>'X');

  MUX3_in1: in std_logic_vector(31 downto 0) := (others=>'0');

 MUX3_in2: in std_logic_vector(31 downto 0) := (others=>'0');

 MUX3_in3: in std_logic_vector(31 downto 0) := (others=>'0');

  MUX3_out: out std_logic_vector(31 downto 0) := (others=>'0')

);

end component;



--2 input MUX

component TwoIn_MUX is

port(

MUX2_en: in std_logic:= 'X';

  MUX2_in1: in std_logic_vector(31 downto 0) := (others=>'0');

  MUX2_in2: in std_logic_vector(31 downto 0) := (others=>'0');

  MUX2_out: out std_logic_vector(31 downto 0) := (others=>'0')

);

end component;



-- MUX for selecting Registers

component  mux_reg_select is

port(

MUX_RS_en: in std_logic:= 'X';

  MUX_RS_in1: in std_logic_vector(4 downto 0) := (others=>'0');

  MUX_RS_in2: in std_logic_vector(4 downto 0) := (others=>'0');

  MUX_RS_out: out std_logic_vector(4 downto 0) := (others=>'0')

);

end component;



--ALU Unit

component ALU is

port(

clk: in std_logic;

    input_1 : in std_logic_vector(31 downto 0);

    input_2 : in std_logic_vector(31 downto 0);

    ALU_ctl: in std_logic_vector(2 downto 0);

    Output_ALU: out std_logic_vector(31 downto 0)

    );

end component;





--EX/Mem Buffer



component Ex_Mem_Buffer is

port(

clk: in std_logic;

    Ex_RegW, Ex_MReg, Ex_MemW: in std_logic:='X';

    -- signals for ALU output and Reg output

    Decode_Ex1,Decode_Ex2: in std_logic_vector(31 downto 0) :=  (others =>'0');

    --write back address input

    WB_in: in std_logic_vector(4 downto 0) :=  (others =>'0');



    Mem_Reg_W, Mem_Reg_M, Mem_Write_M: out std_logic:='X';

    EX_D1,EX_D2: out std_logic_vector(31 downto 0) :=  (others =>'0');

    Output_WB: out std_logic_vector(4 downto 0) :=  (others =>'0')

    );

end component;



signal SrcA, SrcB, Mux3to2,ALUtoEDB : std_logic_vector(31 downto 0);

signal Mux2toEDB: std_logic_vector(4 downto 0); 



begin

  Output_WBE <=  Mux2toEDB;

m2  : mux_reg_select port map(RegDst_en, Ex_Rt, RdE, Mux2toEDB);

m31 : ThreeIn_MUX port map(MUX3_en1, MUX3_Rin1, ResW, ALUout_mem, SrcA);

m32 : ThreeIn_MUX port map(MUX3_en2, MUX3_Rin2, ResW, ALUout_mem, Mux3to2);

m22 : TwoIn_MUX port map(ALU_S_en, Mux3to2, MUX2_SignIm, SrcB);

alu1 : ALU  port map(clk, SrcA, SrcB, ALUctl_en, ALUtoEDB);

buf : Ex_Mem_Buffer port map(clk,Ex_RegW, Ex_MReg, Ex_MemW,

                                                                                    ALUtoEDB, Mux3to2, Mux2toEDB, Mem_Reg_W,

                                                                                    Mem_Reg_M, Mem_Write_M, ALUout_mem2, Write_DM, Output_WBM);

end Behavioral;
