----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:02 09/13/2013 
-- Design Name: 
-- Module Name:    rtdex_rx_if - rtl 
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

entity rtdex_rx_if is
    Port ( i_Clk : in  STD_LOGIC;
           i_Rst : in  STD_LOGIC;
           i_RxReady : in  STD_LOGIC;
           o_RxRe : out  STD_LOGIC;
           i_RxDataValid : in  STD_LOGIC;
           iv32_RxData : in  STD_LOGIC_VECTOR (31 downto 0);
			  ov32_Data : out  STD_LOGIC_VECTOR (31 downto 0));
end rtdex_rx_if;

architecture rtl of rtdex_rx_if is

begin

Ctrl_proc : process(i_Clk, i_Rst, i_RxReady)
begin
	if(rising_edge(i_Clk)) then
		if(i_RxReady='1') then
			o_RxRe <= '1';
		end if;
	end if;
end process Ctrl_proc;

Data_proc : process(i_Clk, i_Rst, i_RxDataValid)
begin
	if(rising_edge(i_Clk)) then
		if(i_RxDataValid='1') then
			ov32_Data <= iv32_RxData;
		end if;
	end if;
end process Data_proc;

end rtl;

