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
           i_Chip : in  STD_LOGIC;
           o_Bit : out  STD_LOGIC);
end decoder;

architecture structural of decoder is

component fsm_decoder is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Preamble : in  SIGNED(11 downto 0);
           iv12_SFD : in  SIGNED(11 downto 0);
           o_EnSFD : out  STD_LOGIC;
           o_EnSBC : out  STD_LOGIC);
end component;

signal s_EnSFD : STD_LOGIC;
signal s_EnSBC : STD_LOGIC;

signal sv12_Preamble : SIGNED(11 downto 0);
signal sv12_SFD : SIGNED(11 downto 0);
			  
component preamble_sfd_correlator is
	 Generic (CORR_SEQ : std_logic_vector(119 downto 0) := x"000000000000000000000000000000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_Chip : in  STD_LOGIC;
           ov12_Correlation : out  SIGNED (11 downto 0));
end component;

component symbol_bank_correlator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_Chip : in  STD_LOGIC;
           o_Bit : out  STD_LOGIC);
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
	 Generic map(CORR_SEQ => x"F5917B23D647AC8F5917B23D647AC8")		--2C9D2C9D
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_Chip => i_Chip,
				  ov12_Correlation => sv12_Preamble);			  

sfd_correlator_inst : preamble_sfd_correlator
	 Generic map(CORR_SEQ => x"0C6E14DC29B85370C6E14DC29B8537")		--362DB076
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => s_EnSFD,
				  i_Chip => i_Chip,
				  ov12_Correlation => sv12_SFD);		  
			  			  
symbol_bank_correlator_inst : symbol_bank_correlator
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => s_EnSBC,
				  i_Chip => i_Chip,
				  o_Bit => o_Bit);
			  
end structural;

