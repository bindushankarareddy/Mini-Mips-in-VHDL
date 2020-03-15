library ieee;

use IEEE.std_logic_1164.all;

--use IEEE.numeric_std.all;

use IEEE.std_logic_arith.all;

use IEEE.std_logic_unsigned.all;



entity Hazard_Unit is

generic(

    mux_s: integer:=1;

address: integer:=4

  );



port(

clk: in std_logic;

    --address from various stages

    Write_Reg_W: in std_logic_vector( address downto 0):= (others=>'0');

Write_RegM: in std_logic_vector( address downto 0):= (others=>'0');

Write_RegE: in std_logic_vector( address downto 0):= (others=>'0');

    RsD, RtD, Ex_Rs, Ex_Rt, RdE: in std_logic_vector( address downto 0):= (others=>'0');

    --select lines for muxes in EX stage

    mux3_en_1,mux3_en_2: out std_logic_vector( mux_s downto 0):= (others=>'0');

    --select lines for muxes in ID stage

    AD, BD: out std_logic:='0';



    --in presence LOAD instruction

    Mem_Reg_W, Reg_WriteW, Reg_WriteE, Mem_Reg_M, Ex_MReg : in std_logic:='0';



    --stall control signals

    ID_Stall, IF_Stall : out std_logic:='1';



flush: out std_logic:='0';

    Bra_Det: in std_logic_vector(1 downto 0):= (others=>'0')

    );

end Hazard_Unit;







architecture Behavioral of Hazard_Unit is

begin

process(clk)

begin

      --HAZARD 1: DATA HAZARD

      --solution: data forwarding

      --if destination and source address are same ,

      --adjust the mux signal to read the RIGHT data as input

if(Reg_WriteW ='1') then

if(unsigned(Write_Reg_W) = unsigned(Ex_Rs)) then

          mux3_en_1 <="01"; else

          mux3_en_1 <="00";

end if;

if(unsigned(Write_Reg_W) = unsigned(Ex_Rt)) then

          mux3_en_2 <="01"; else

          mux3_en_2 <="00";

end if;

end if;





if (Reg_WriteE ='1') then

if(unsigned(RdE)=unsigned(RsD)) then

          mux3_en_1 <="10"; else

          mux3_en_1 <="00";

end if;



if(unsigned(RdE)=unsigned(RtD)) then

          mux3_en_2 <="10"; else

          mux3_en_2 <="00";

end if;

end if;

      --HAZARD 2: Load delay

      --STALL solution

      -- if a load is followed by an instruction which uses

      -- load's destination as its source then STALL by one cycle



if(unsigned(Ex_Rt)=unsigned(RsD)) or (unsigned(Ex_Rt)=unsigned(RtD)) then

if(Ex_MReg ='1') then

          IF_Stall <= '0';

flush<= '0';

end if; else

          ID_Stall  <= '1';

          IF_Stall  <= '1';

flush<= '0';

end if;

end process;

end Behavioral ;
