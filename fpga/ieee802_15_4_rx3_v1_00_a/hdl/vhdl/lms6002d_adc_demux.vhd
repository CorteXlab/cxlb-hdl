----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    11:38:22 02/03/2014 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    lms6002d_adc_demux - rtl 
-- Project Name: 	 IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lms6002d_adc_demux is
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0);
           iv12_IQData : in  STD_LOGIC_VECTOR (11 downto 0);
           iIQSel : in  STD_LOGIC);
end lms6002d_adc_demux;

architecture rtl of lms6002d_adc_demux is
begin						
						
DATA_PROC : process(iRst,iClk)
begin
	if(iRst='1') then
		ov12_IData <= (others=>'1');
		ov12_QData <= (others=>'1');
	elsif(rising_edge(iClk)) then
		if(iIQSel='1') then
			ov12_IData <= ov12_IQData;
		else
			ov12_QData <= ov12_IQData;
		end if;
	end if;	
end process DATA_PROC;

end rtl;

