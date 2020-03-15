library ieee;

use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;



entity ID_Stage is

generic (

width, datasize, no_reg: integer:=31;

addr: integer:=4

            );

port

(

clk, flush :in std_logic :='0';

            Mux_Signal1: in std_logic:='0';

	    Mux_Signal2: in std_logic:='0'; -- muxes to select RD1 and RD2

            WB_reg : in std_logic :='0'; -- from the hazard unit

            WB_out : in std_logic_vector(4 downto 0) := (others=>'0');

            Inst_Decode: in std_logic_vector(31 downto 0) := (others=>'0');

Data_W: in std_logic_vector(31 downto 0) := (others=>'0');

PC4: in std_logic_vector(31 downto 0) := (others=>'0');

Output_ALU: in std_logic_vector(31 downto 0) := (others=>'0');



  -- control signals

  Ex_RegW, Ex_MReg, Ex_MemW, ALU_S_en, RegDst_en : out std_logic :='0';
  PCSrcD :out std_logic_vector(1 downto 0) := (others=>'0');
  Bra_Det :out std_logic_vector(1 downto 0) := (others=>'0');

  --ALU control bits

  ALUctl_en: out std_logic_vector(2 downto 0) := (others=>'0');



  Ex_Rs, Ex_Rt, Ex_Rd, RsD, RtD : out std_logic_vector(4 downto 0) := (others=>'0');

  IE_out1, IE_out2,Ex_Sign: out std_logic_vector(31 downto 0) := (others=>'0');

  AdderOut: out  std_logic_vector(31 downto 0) := (others=>'0')

);

end ID_Stage;



architecture Behavioral of ID_Stage is



component Control_Unit is

port(

clk: in std_logic;

Opcode: in std_logic_vector(2 downto 0):=(others=>'0');
Fnctn: in std_logic_vector(5 downto 0):=(others=>'0');

      Reg_Write,MR_Mux_Sel, Mem_Write, ALU_Mux_Sel, Reg_Mux_Sel: out std_logic:='0';
 Bra_Det:out std_logic_vector(1 downto 0) := (others=>'0');


      ALU_Control: out std_logic_vector(2 downto 0):=(others=>'0')

    );

end component;



component Reg_File is --register file

port(

clk, En_W: in std_logic :='0'; 

  --access contents of operand 1

  Reg1: in std_logic_vector(addr downto 0):=(others=>'0');

  --access contents of operand 2

  Reg2: in std_logic_vector(addr downto 0):=(others=>'0');

  --write to register @address

  Reg_W: in std_logic_vector(addr downto 0):=(others=>'0');

  --write back data

  Data_W: in std_logic_vector(datasize downto 0):=(others=>'0');

  --output from operand 1

Data1: out std_logic_vector(datasize downto 0):=(others=>'0');

  --output from operand 2

  Data2: out std_logic_vector(datasize downto 0):=(others=>'0')

);

end component;



component Decode_MUX is

port (

      mux_in: in std_logic :='0';

      reg_data, Output_ALU: in std_logic_vector(31 downto 0):=(others=>'0');

      Mux_output: out std_logic_vector(31 downto 0):=(others=>'0')

    );

end component;



component Branch_Det is

port(

    Bra_Det: in std_logic_vector(1 downto 0) := (others=>'0');

    Input_1, Input_2: in std_logic_vector(31 downto 0);

    Output_branch: out std_logic_vector(1 downto 0) := (others=>'0')


  );

end component;



component Sign_Extend is

port(

    in_SE: in std_logic_vector(18 downto 0) := (others=>'0');

    Sign_Extend_out: out std_logic_vector(31 downto 0) := (others=>'0')

  );

end component;



component Jump_Adder is

port(

    PC4: in std_logic_vector(31 downto 0) := (others=>'0');

    Sign_Extend_out: in  std_logic_vector(31 downto 0) := (others=>'0');

    Adder_out: out std_logic_vector (31 downto 0) := (others=>'0')

  );

end component;



component ID_EX_Buffer is

port(

clk,flush: in std_logic:='0';

    Reg_W_Decode, MR_Mux_Sel, Mem_Write, ALU_Mux_Sel, Reg_Mux_Sel: in std_logic:='X';

    ALU_Control : in std_logic_vector(2 downto 0) := (others=>'X');

    RF_Reg1, RF_Reg2, RF_RegW: in  std_logic_vector(4 downto 0) := (others=>'0');

    Exe_1, Exe_2, Sign_decode: in std_logic_vector(width downto 0) := (others=>'0');

    Exe_WReg, Exe_MReg, Exe_MemW, Exe_ALU, Exe_Reg : out std_logic:='X';

    Exe_ALU_Control: out std_logic_vector(2 downto 0) := (others=>'X');

    Ex_Rs,Ex_Rt,Ex_Rd: out std_logic_vector(4 downto 0) := (others=>'0');

    IE_out1, IE_out2, Ex_Sign: out std_logic_vector(width downto 0) := (others=>'0')

  );

end component;



signal SignEtoAdder, RegtoMux1, RegtoMux2, Mux1toIEB, Mux2toIEB: std_logic_vector(datasize downto 0);

signal RWD, MRD, MWD, ASD, RDD: std_logic;

signal BD: std_logic_vector(1 downto 0) := (others=>'0');

signal ACD: std_logic_vector(2 downto 0);



begin

  Bra_Det  <= BD;

  RsD   <= Inst_Decode(28 downto 24);

  RtD   <= Inst_Decode(23 downto 19);

   se       :  Sign_Extend port map(Inst_Decode(18 downto 0), SignEtoAdder);

  c1       :  Control_Unit port map(clk, Inst_Decode(31 downto 29), Inst_Decode(5 downto 0), RWD, MRD, MWD, ASD, RDD, BD, ACD);

adder    :  Jump_Adder     port map(PC4, SignEtoAdder, AdderOut);

regfile  :  Reg_File       port map(clk, WB_reg, Inst_Decode(28 downto 24), Inst_Decode(23 downto 19), WB_out, Data_W, RegtoMux1, RegtoMux2);

  m1       :  Decode_MUX port map(Mux_Signal1, RegtoMux1, Output_ALU, Mux1toIEB);

  m2       :  Decode_MUX port map(Mux_Signal2, RegtoMux2, Output_ALU, Mux2toIEB);

bra      : Branch_Det port map(BD, RegtoMux1, RegtoMux2, PCsrcD);

  IE       : ID_EX_Buffer port map(clk, flush, RWD, MRD, MWD, ASD, RDD, ACD, Inst_Decode(28 downto 24),

                                   Inst_Decode(23 downto 19), Inst_Decode(18 downto 14), Mux1toIEB, Mux2toIEB,

                                   SignEtoAdder, Ex_RegW, Ex_MReg, Ex_MemW, ALU_S_en, RegDst_en,

                                   ALUctl_en, Ex_Rs, Ex_Rt, Ex_Rd, IE_out1, IE_out2, Ex_Sign);

end Behavioral;
