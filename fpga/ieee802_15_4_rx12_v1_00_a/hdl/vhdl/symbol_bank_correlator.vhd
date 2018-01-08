----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:28:54 11/08/2013 
-- Design Name: 
-- Module Name:    symbol_bank_correlator - structural 
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

entity symbol_bank_correlator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_Chip : in  STD_LOGIC;
           o_Bit : out  STD_LOGIC);
end symbol_bank_correlator;

architecture structural of symbol_bank_correlator is

constant CORR_SEQ0 : std_logic_vector(14 downto 0) := "000100110101111";
signal sv12_correlation0, sv12_correlation1 : signed(11 downto 0); 

component symbol_correlator is
	 Generic (CORR_SEQ : std_logic_vector(14 downto 0) := "000000000000000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_Chip : in  STD_LOGIC;
           ov12_Correlation : out  SIGNED (11 downto 0));
end component;

component comparator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_PortData0 : in  SIGNED (11 downto 0);
           iv12_PortData1 : in  SIGNED (11 downto 0);
           o_Bit : out  STD_LOGIC);
end component;

begin

symbol_correlator_inst0 : symbol_correlator
	 Generic map(CORR_SEQ => CORR_SEQ0)
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_Chip => i_Chip,
				  ov12_Correlation => sv12_correlation0);
				  
symbol_correlator_inst1 : symbol_correlator
	 Generic map(CORR_SEQ => not CORR_SEQ0)
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_Chip => i_Chip,
				  ov12_Correlation => sv12_correlation1);			  

comparator_inst : comparator
	Port map( i_Rst => i_Rst,
				 i_Clk => i_Clk,
				 i_En => i_En,
				 iv12_PortData0 => sv12_correlation0,
				 iv12_PortData1 => sv12_correlation1,
				 o_Bit => o_Bit);
				 
end structural;

