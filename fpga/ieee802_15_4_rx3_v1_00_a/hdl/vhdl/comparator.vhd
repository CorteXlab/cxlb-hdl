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
           iv12_PortData0 : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_PortData1 : in  STD_LOGIC_VECTOR(11 downto 0);
           iv4_PortIndex0 : in  STD_LOGIC_VECTOR (3 downto 0);
           iv4_PortIndex1 : in  STD_LOGIC_VECTOR (3 downto 0);
           ov4_PortIndex : out  STD_LOGIC_VECTOR (3 downto 0);
           ov12_PortData : out  STD_LOGIC_VECTOR(11 downto 0));
end comparator;

architecture rtl of comparator is

begin

process(i_Rst,i_Clk,i_En)
begin
	if(i_Rst='1') then
		ov12_PortData <= (others => '0');
		ov4_PortIndex <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		if(i_En='1') then
			if(signed(iv12_PortData0) >= signed(iv12_PortData1)) then
				ov12_PortData <= iv12_PortData0;
				ov4_PortIndex <= iv4_PortIndex0;	
			else
				ov12_PortData <= iv12_PortData1;
				ov4_PortIndex <= iv4_PortIndex1;			
			end if;
		else
			ov12_PortData <= (others => '0');
			ov4_PortIndex <= (others => '0');		
		end if;	
	end if;
end process;

end rtl;

