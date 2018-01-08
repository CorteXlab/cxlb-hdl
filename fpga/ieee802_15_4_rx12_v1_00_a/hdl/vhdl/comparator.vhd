----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:27 11/08/2013 
-- Design Name: 
-- Module Name:    comparator - rtl 
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

entity comparator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_PortData0 : in  SIGNED (11 downto 0);
           iv12_PortData1 : in  SIGNED (11 downto 0);
           o_Bit : out STD_LOGIC);
end comparator;

architecture rtl of comparator is

begin

process(i_Rst,i_Clk,i_En)
begin
	if(i_Rst='1') then
		o_Bit <= '0';
	elsif(rising_edge(i_Clk)) then
		if(i_En='1') then
			if(iv12_PortData0 >= iv12_PortData1) then
				o_Bit <= '0';	
			else
				o_Bit <= '1';			
			end if;
		else
			o_Bit <= '0';		
		end if;	
	end if;
end process;

end rtl;

