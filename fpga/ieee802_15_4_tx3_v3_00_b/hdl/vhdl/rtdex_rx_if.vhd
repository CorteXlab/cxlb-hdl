----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    17:34:02 09/13/2013 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    rtdex_rx_if - rtl 
-- Project Name: 	 IEEE 802.15.4
--
-- Revision: 0.03
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ieee802_15_4_pkg.ALL;

entity rtdex_rx_if is
    Generic(CLKDIV : integer := RTDEX_CLKDIV);
    Port ( iClk : in  STD_LOGIC;
           iRst : in  STD_LOGIC;
           iRxReady : in  STD_LOGIC;
           oRxRe : out  STD_LOGIC;
           iRxDataValid : in  STD_LOGIC;
			  oDValid : out  STD_LOGIC;
           iv32_RxData : in  STD_LOGIC_VECTOR (31 downto 0);
			  ov32_Data : out  STD_LOGIC_VECTOR (31 downto 0));
end rtdex_rx_if;

architecture rtl of rtdex_rx_if is
signal RE : std_logic;
begin

Ctrl_proc : process(iClk, iRst, iRxReady)
begin
	if(rising_edge(iClk)) then
		if(iRxReady='1' and RE='1') then
			oRxRe <= '1';
		else
			oRxRe <= '0';
		end if;
	end if;
end process Ctrl_proc;

Data_proc : process(iClk, iRst, iRxDataValid)
begin
	if(rising_edge(iClk)) then
		if(iRxDataValid='1') then
			--------------------------------------------------------------------
			--Big-Endian
			--------------------------------------------------------------------			
			--ov32_Data <= iv32_RxData(27 downto 24) & iv32_RxData(31 downto 28) 
			--		   & iv32_RxData(19 downto 16) & iv32_RxData(23 downto 20) 
			--		   & iv32_RxData(11 downto 8) & iv32_RxData(15 downto 12) 
			--		   & iv32_RxData(3 downto 0) & iv32_RxData(7 downto 4);	
			--------------------------------------------------------------------			
			--Little-Endian
			--------------------------------------------------------------------			
			ov32_Data <= iv32_RxData(3 downto 0) & iv32_RxData(7 downto 4)
					   & iv32_RxData(11 downto 8) & iv32_RxData(15 downto 12)
					   & iv32_RxData(19 downto 16) & iv32_RxData(23 downto 20) 					    
					   & iv32_RxData(27 downto 24) & iv32_RxData(31 downto 28) ;	
			--------------------------------------------------------------------					   
			oDValid <= '1';
		end if;
	end if;
end process Data_proc;

RE_PROC : process(iRst,iClk)
variable cnt_div : integer := 0;
begin
	if(iRst='1') then
		RE <= '0';
		cnt_div := 0;
	elsif(rising_edge(iClk)) then
		cnt_div := cnt_div + 1;
		if(cnt_div>=CLKDIV) then
			RE <= '1';
			cnt_div := 0;
		else
			RE <= '0';
		end if;			
	end if;
end process RE_PROC;

end rtl;

