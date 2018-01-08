----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
--  
-- Create Date:    16:14:55 01/31/2014 
-- Design Name:    IEEE 802.15.4
-- Module Name:    symbol2chip - rtl 
-- Project Name:   IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ieee802_15_4_pkg.ALL;

entity symbol2chip is
    Generic(CLKDIV : integer := S2C_CLKDIV);
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           iDValid : in  STD_LOGIC;
           iv4_Data : in  STD_LOGIC_VECTOR (3 downto 0);
           oIChip : out  STD_LOGIC;
           oQChip : out  STD_LOGIC;
           oDValid : out  STD_LOGIC);
end symbol2chip;

architecture rtl of symbol2chip is
signal CE : std_logic;
begin

DATA_PROC : process(iRst,iClk,CE)
variable cnt_data : integer range 0 to 16 := 0;
variable current_pn_sequence : STD_LOGIC_VECTOR(0 TO 31) := (others => '0');
begin
	if(iRst='1') then
		oIChip <= '0';
		oQChip <= '0';
		oDValid <= '0';
		cnt_data := 0;
		current_pn_sequence := (others => '0');
	elsif(rising_edge(iClk) and CE='1') then
		if(iDValid='1') then
			current_pn_sequence := dsss_16pn_sequences_32b(to_integer(unsigned(iv4_Data(3 downto 0))));
			oIChip <= current_pn_sequence(2*cnt_data);
			oQChip <= current_pn_sequence(2*cnt_data+1);
			oDValid <= '1';
		end if;	
		cnt_data := cnt_data + 1;
		if(cnt_data=16) then
			cnt_data := 0;
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

