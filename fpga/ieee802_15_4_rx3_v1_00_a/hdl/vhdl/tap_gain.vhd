----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:39 11/11/2013 
-- Design Name: 
-- Module Name:    tap_gain - rtl 
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

entity tap_gain is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data : in  STD_LOGIC_VECTOR(11 downto 0);
			  iv8_Coef : in  STD_LOGIC_VECTOR(7 downto 0);
           ov12_Data : out  STD_LOGIC_VECTOR(11 downto 0));
end tap_gain;

architecture rtl of tap_gain is
begin
process(i_Rst,i_Clk,i_En)
variable v20_Data : SIGNED (19 downto 0);
begin
	if(i_Rst='1') then
		ov12_Data <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		v20_Data := signed(iv12_Data) * signed(iv8_Coef);
		ov12_Data <= std_logic_vector(resize(v20_Data,12));
	end if;
end process;
end rtl;

