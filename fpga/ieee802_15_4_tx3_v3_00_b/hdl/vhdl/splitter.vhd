----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    15:13:58 01/31/2014 
-- Design Name:    IEEE 802.15.4
-- Module Name:    splitter - rtl 
-- Project Name:   IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ieee802_15_4_pkg.ALL;

entity splitter is
	 Generic(CLKDIV : integer := SPLIT_CLKDIV);
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           iv32_Data : in  STD_LOGIC_VECTOR (31 downto 0);
           ov4_Data : out  STD_LOGIC_VECTOR (3 downto 0);
           iDValid : in  STD_LOGIC;
           oDValid : out  STD_LOGIC);
end splitter;

architecture rtl of splitter is
signal CE : std_logic;
begin

DATA_PROC : process(iRst,iClk,CE)
variable cnt_data : integer range 0 to 8 := 8;
begin
	if(iRst='1') then
		ov4_Data <= (others => '0');
		oDValid <= '0';
		cnt_data := 8;
	elsif(rising_edge(iClk) and CE='1') then
		if(iDValid='1') then
			ov4_Data <= iv32_Data(cnt_data*4-1 downto (cnt_data-1)*4);
			oDValid <= '1';
		end if;	
		cnt_data := cnt_data - 1;
		if(cnt_data=0) then
			cnt_data := 8;
		end if;	
	end if;
end process DATA_PROC;

CE_PROC : process(iRst,iClk)
variable cnt_div : integer := 0;
begin
	if(iRst='1') then
		CE <= '0';
		cnt_div := 0;
	elsif(rising_edge(iClk)) then
			cnt_div := cnt_div + 1;
			if(cnt_div>=CLKDIV) then
				CE <= '1';
				cnt_div := 0;
			else
				CE <= '0';
			end if;			
	end if;
end process CE_PROC;

end rtl;

