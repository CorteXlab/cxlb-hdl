----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:10:54 08/13/2013 
-- Design Name: 
-- Module Name:    cordic_rotation_init - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_rotation_init is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           o_En : out  STD_LOGIC;			  
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0);
			  iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end cordic_rotation_init;

architecture rtl of cordic_rotation_init is

begin

process(i_Rst,i_Clk)
variable v_En : std_logic := '0';
begin
	if(i_Rst='1') then
		o_En <= '0';
		ov12_IData <= (others => '0');
		ov12_QData <= (others => '0');
		ov16_Phase <= (others => '0');
	elsif(rising_edge(i_Clk)) then	
		if(iv16_Phase=x"0000")	then
			ov12_IData <= iv12_IData;
			ov12_QData <= iv12_QData;
			ov16_Phase <= (others => '0');	
			o_En <= '0';
		elsif(iv16_Phase=x"4650" or iv16_Phase=x"B9B0")	then	-- (+180e2) or (-180e2)
			ov12_IData <= not(iv12_IData)+x"001";
			ov12_QData <= not(iv12_QData)+x"001";
			ov16_Phase <= (others => '0');		
			o_En <= '0';
		elsif(iv16_Phase=x"2328") then	-- (+90e2)
			ov12_IData <= not(iv12_QData)+x"001";
			ov12_QData <= iv12_IData;
			ov16_Phase <= (others => '0');
			o_En <= '0';
		elsif(iv16_Phase=x"DCD8")	then	-- (-90e2)
			ov12_IData <= iv12_QData;
			ov12_QData <= not(iv12_IData)+x"001";
			ov16_Phase <= (others => '0');
			o_En <= '0';
		else
			if(iv16_Phase>x"2328") then	-- (+90e2)
				ov12_IData <= not(iv12_QData)+x"001";
				ov12_QData <= iv12_IData;
				ov16_Phase <= iv16_Phase - x"2328";
			elsif(iv16_Phase<x"DCD8")	then	-- (-90e2)
				ov12_IData <= iv12_QData;
				ov12_QData <= not(iv12_IData)+x"001";
				ov16_Phase <= iv16_Phase + x"2328";
			else		
				ov12_IData <= iv12_IData;
				ov12_QData <= iv12_QData;
				ov16_Phase <= iv16_Phase;	
			end if;
			o_En <= '1';
		end if;
	end if;	
end process;
end rtl;