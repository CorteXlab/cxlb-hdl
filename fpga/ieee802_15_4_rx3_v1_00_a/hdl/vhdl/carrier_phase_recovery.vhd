----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:57:03 10/29/2013 
-- Design Name: 
-- Module Name:    carrier_phase_recovery - structural 
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

entity carrier_phase_recovery is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
			  iv18_kp : in std_logic_vector(17 downto 0);
			  iv18_ka : in std_logic_vector(17 downto 0);			  
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
end carrier_phase_recovery;

architecture structural of carrier_phase_recovery is

component cordic_rotation is
	 Generic( NUMBER_ITERATION : integer :=16);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
			  iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
			  ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
end component;

signal sv12_IData : STD_LOGIC_VECTOR (11 downto 0);
signal sv12_QData : STD_LOGIC_VECTOR (11 downto 0);
signal sv16_Phase : STD_LOGIC_VECTOR (15 downto 0);
signal sv24_Error  : STD_LOGIC_VECTOR (23 downto 0);

component error_generator is
	 Generic(NUMBER_SAMPLES_PER_SYMBOL : integer :=8);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           ov24_Error : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component loop_filter is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv24_Error : in  STD_LOGIC_VECTOR (23 downto 0);
			  iv18_kp : in std_logic_vector(17 downto 0);
			  iv18_ka : in std_logic_vector(17 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

ov12_IData <= sv12_IData;
ov12_QData <= sv12_QData;

cordic_rotation_inst : cordic_rotation
	 Generic map( NUMBER_ITERATION => 16)
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  iv12_IData => iv12_IData,
				  iv12_QData => iv12_QData,
				  iv16_Phase => sv16_Phase,
				  ov12_IData => sv12_IData,
				  ov12_QData => sv12_QData);

error_generator_inst : error_generator
	 Generic map(NUMBER_SAMPLES_PER_SYMBOL => 8)
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  --i_En : in  STD_LOGIC;
				  iv12_IData => sv12_IData,
				  iv12_QData => sv12_QData,
				  ov24_Error => sv24_Error);
				  
loop_filter_inst : loop_filter
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  --i_En : in  STD_LOGIC;
              iv24_Error => sv24_Error,
			     iv18_kp => iv18_kp,
			     iv18_ka => iv18_ka,
              ov16_Phase => sv16_Phase);				  

end structural;

