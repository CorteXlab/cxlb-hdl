----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    11:38:22 02/03/2014 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    lms6002d_dac_mux - rtl 
-- Project Name: 	 IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lms6002d_dac_mux is
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           iDValid : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           ov12_IQData : out  STD_LOGIC_VECTOR (11 downto 0);
           oIQSel : out  STD_LOGIC);
end lms6002d_dac_mux;

architecture rtl of lms6002d_dac_mux is
signal iqEn : std_logic := '1'; 
begin

oIQSel <= iqEn;
ov12_IQData <= iv12_IData when iqEn='1' else iv12_QData;						
						
CLK_PROC : process(iRst,iClk)
begin
	if(iRst='1') then
		iqEn <= '1';
	elsif(rising_edge(iClk)) then
		iqEn <= not iqEn;
	end if;	
end process CLK_PROC;

end rtl;

