----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:02 09/13/2013 
-- Design Name: 
-- Module Name:    rtdex_tx_if - rtl 
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

entity rtdex_tx_if is
    Port ( i_Clk : in  STD_LOGIC;
           i_Rst : in  STD_LOGIC;
           i_TxReady : in  STD_LOGIC;
           o_TxWe : out  STD_LOGIC;
           ov32_TxData : out  STD_LOGIC_VECTOR (31 downto 0);
			  iv32_Data : in  STD_LOGIC_VECTOR (31 downto 0));
end rtdex_tx_if;

architecture rtl of rtdex_tx_if is

begin

process(i_Clk, i_Rst, i_TxReady)
begin
	if(rising_edge(i_Clk)) then
		if(i_TxReady='1') then
			o_TxWe <= '1';
			ov32_TxData <= iv32_Data;
		end if;
	end if;
end process;

end rtl;

