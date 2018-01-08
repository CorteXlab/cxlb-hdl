----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:57:29 11/11/2013 
-- Design Name: 
-- Module Name:    tap_sum - rtl 
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
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tap_sum is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data0 : in  SIGNED (11 downto 0);
           iv12_Data1 : in  SIGNED (11 downto 0);
           ov12_Data : out  SIGNED (11 downto 0));
end tap_sum;

architecture rtl of tap_sum is
begin
process(i_Rst,i_Clk,i_En)
begin
	if(i_Rst='1') then
		ov12_Data <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		ov12_Data <= iv12_Data0 + iv12_Data1;
	end if;
end process;

end rtl;

