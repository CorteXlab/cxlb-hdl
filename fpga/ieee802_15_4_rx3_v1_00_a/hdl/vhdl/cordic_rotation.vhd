----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:33:06 08/15/2013 
-- Design Name: 
-- Module Name:    cordic_rotation - structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_rotation is
	 Generic( NUMBER_ITERATION : integer :=16);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
			  iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
			  ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
           --ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end cordic_rotation;

architecture structural of cordic_rotation is

type iqData_core_step_connector is array(0 to NUMBER_ITERATION) of std_logic_vector(11 downto 0);
type phase_core_step_connector is array(0 to NUMBER_ITERATION) of std_logic_vector(15 downto 0);
type angle_rom is array(0 to 15) of std_logic_vector(15 downto 0);

component cordic_rotation_init is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           o_En : out  STD_LOGIC;			  
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0);
			  iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

signal s_En : std_logic_vector(0 to NUMBER_ITERATION);
signal sv12_IData : iqData_core_step_connector;
signal sv12_QData : iqData_core_step_connector;
signal sv16_Phase : phase_core_step_connector;

component cordic_rotation_core_step is
	 Generic( step : integer := 0;
				 Angle :  STD_LOGIC_VECTOR (15 downto 0):=x"0000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           o_En : out  STD_LOGIC;		  
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

constant sv16_Angle : angle_rom := (x"1194",
												 x"0A61",
												 x"057C",
												 x"02C9",
												 x"0166",
												 x"00B3",
												 x"005A",
												 x"002D",
												 x"0017",
												 x"000C",
												 x"0006",
												 x"0003",
												 x"0002",
												 x"0001",
												 x"0001",
												 x"0001");

component cordic_rotation_term is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
			  ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
           --ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

cordic_rotation_init_inst : cordic_rotation_init
    Port map( i_Rst => i_Rst,
           i_Clk => i_Clk,

           o_En => s_En(0),			  
           iv12_IData => iv12_IData,
           iv12_QData => iv12_QData,
           ov12_IData => sv12_IData(0),
           ov12_QData => sv12_QData(0),
			  iv16_Phase => iv16_Phase,
           ov16_Phase => sv16_Phase(0));	

cordic_rotation_core_step_generate : for i in 0 to NUMBER_ITERATION-1 generate
	cordic_rotation_core_step_inst : cordic_rotation_core_step
	 Generic map(	step => i,
						Angle => sv16_Angle(i))
    Port map( i_Rst => i_Rst,
           i_Clk => i_Clk,
			  i_En => s_En(i),
			  o_En => s_En(i+1),
           iv12_IData => sv12_IData(i),
			  iv12_QData => sv12_QData(i),
			  iv16_Phase => sv16_Phase(i),			  
           ov12_IData => sv12_IData(i+1),
			  ov12_QData => sv12_QData(i+1),
			  ov16_Phase => sv16_Phase(i+1));
end generate cordic_rotation_core_step_generate;			  
			  
cordic_rotation_term_inst : cordic_rotation_term
    Port map( i_Rst => i_Rst,
           i_Clk => i_Clk,
           i_En => s_En(NUMBER_ITERATION),
           iv16_Phase => sv16_Phase(NUMBER_ITERATION),
           iv12_IData => sv12_IData(NUMBER_ITERATION),
           iv12_QData => sv12_QData(NUMBER_ITERATION),
			  ov12_IData => ov12_IData,
			  ov12_QData => ov12_QData);
           --ov16_Phase => ov16_Phase);			  

end structural;

