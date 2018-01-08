----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    23:27:22 01/31/2014 
-- Design Name:    IEEE 802.15.4
-- Module Name:    txfilter - rtl 
-- Project Name:   IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.ieee802_15_4_pkg.ALL;

entity txfilter is
Generic(CLKDIV : integer := TXF_CLKDIV);
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           iDValid : in  STD_LOGIC;
           iISymbol : in  STD_LOGIC;
           iQSymbol : in  STD_LOGIC;
           oDValid : out  STD_LOGIC;
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
end txfilter;

architecture rtl of txfilter is													
signal CE : std_logic;
signal sv12_QData : STD_LOGIC_VECTOR(11 downto 0);
signal svNx12_QData : DLY_OQPSK;
begin

ov12_QData <= svNx12_QData(USFact/2-1);

DELAY_PROC : process(iRst,iClk)
variable I : integer range 0 to USFact/2-1 := 0;
begin
	if(iRst='1') then
		svNx12_QData <= (others => (others => '0'));
	elsif(rising_edge(iClk) and CE='1') then
		DELAY_LOOP : FOR I IN (USFact/2-1) DOWNTO 1 LOOP
			svNx12_QData(I) <= svNx12_QData(I-1);
		END LOOP DELAY_LOOP;
		svNx12_QData(0) <= sv12_QData;
	end if;
end process DELAY_PROC;

DATA_PROC : process(iRst,iClk,CE)
variable cnt_data : integer range 0 to USFact := 0;
begin
	if(iRst='1') then
		ov12_IData <=(others => '0');
		sv12_QData <= (others => '0');
		oDValid <= '0';
		cnt_data := 0;
	elsif(rising_edge(iClk) and CE='1') then
		if(iDValid='1') then	
			if(iISymbol='1') then
				ov12_IData <= filter_coef(cnt_data);
			else
				ov12_IData <= not(filter_coef(cnt_data)) + x"001";
			end if;
			if(iQSymbol='1') then
				sv12_QData <= filter_coef(cnt_data);
			else
				sv12_QData <= not(filter_coef(cnt_data)) + x"001";
			end if;
			oDValid <= '1';
		end if;	
		cnt_data := cnt_data + 1;
		if(cnt_data>=USFact) then
			cnt_data := 0;
		end if;	
	end if;
end process DATA_PROC;

CE_PROC : process(iRst,iClk)
begin
	if(iRst='1') then
		CE <= '1';
	elsif(rising_edge(iClk)) then
		CE <= not CE;
	end if;
end process CE_PROC;

end rtl;

