----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:25:25 11/08/2013 
-- Design Name: 
-- Module Name:    decoder - structural 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or SIGNED values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov4_Symbol : out  STD_LOGIC_VECTOR (3 downto 0));
end decoder;

architecture structural of decoder is

component fsm_decoder is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Preamble : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_SFD : in  STD_LOGIC_VECTOR(11 downto 0);
           o_EnSFD : out  STD_LOGIC;
           o_EnSBC : out  STD_LOGIC);
end component;

signal s_EnSFD : STD_LOGIC;
signal s_EnSBC : STD_LOGIC;

signal sv12_Preamble : STD_LOGIC_VECTOR(11 downto 0);
signal sv12_SFD : STD_LOGIC_VECTOR(11 downto 0);
			  
component preamble_sfd_correlator is
	 Generic (ICORR_SEQ : std_logic_vector(31 downto 0) := x"00000000";
				 QCORR_SEQ : std_logic_vector(31 downto 0) := x"00000000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov12_Correlation : out  STD_LOGIC_VECTOR(11 downto 0));
end component;

component symbol_bank_correlator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov4_Symbol : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

begin

fsm_decoder_inst : fsm_decoder
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  iv12_Preamble => sv12_Preamble,
				  iv12_SFD => sv12_SFD,
				  o_EnSFD => s_EnSFD,
				  o_EnSBC => s_EnSBC);
			  
preamble_correlator_inst : preamble_sfd_correlator
	 Generic map(ICORR_SEQ => x"A917A917",		--719A719A
					 QCORR_SEQ => x"D9C2D9C2")		--2C9D2C9D
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_IChip => i_IChip,
				  i_QChip => i_QChip,
				  ov12_Correlation => sv12_Preamble);			  

sfd_correlator_inst : preamble_sfd_correlator
	 Generic map(ICORR_SEQ => x"A45E7A91",		--19A7E54A
					 QCORR_SEQ => x"670BD263")		--362DB076
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => s_EnSFD,
				  i_IChip => i_IChip,
				  i_QChip => i_QChip,
				  ov12_Correlation => sv12_SFD);		  
			  			  
symbol_bank_correlator_inst : symbol_bank_correlator
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => s_EnSBC,
				  i_IChip => i_IChip,
				  i_QChip => i_QChip,
				  ov4_Symbol => ov4_Symbol);
			  
end structural;

