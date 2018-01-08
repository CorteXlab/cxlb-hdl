----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    17:34:02 09/13/2013 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    options_switch - rtl 
-- Project Name: 	 IEEE 802.15.4
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity options_switch is
    Port ( iClk : in  STD_LOGIC;
           iRst : in  STD_LOGIC;
           iRxReady : in  STD_LOGIC;
           oRxRe : out  STD_LOGIC;
           iRxDataValid : in  STD_LOGIC;
           iv32_RxData : in  STD_LOGIC_VECTOR (31 downto 0);
			  iv12_IQData_Tx0 : in  STD_LOGIC_VECTOR (11 downto 0);
			  iv12_IQData_Tx1 : in  STD_LOGIC_VECTOR (11 downto 0);
			  ov12_IQData : out  STD_LOGIC_VECTOR (11 downto 0);
			  i_IQSel_Tx0 : in  STD_LOGIC;
			  i_IQSel_Tx1 : in  STD_LOGIC;
			  o_IQSel : out  STD_LOGIC);
end options_switch;

architecture rtl of options_switch is
signal s_Sel : std_logic_vector(1 downto 0);
signal sv12_IQData_reg,  sv12_IQData_next : STD_LOGIC_VECTOR (11 downto 0);
signal s_IQSel_reg, s_IQSel_next : STD_LOGIC;
begin

Ctrl_proc : process(iClk, iRst, iRxReady)
begin
	if(rising_edge(iClk)) then
		if(iRxReady='1') then
			oRxRe <= '1';
		else
			oRxRe <= '0';
		end if;
	end if;
end process Ctrl_proc;

--Data_proc : process(iClk, iRst, iRxDataValid)
--begin
--	if(iRst='1') then
--		s_Sel <= (others => '0');
--	elsif(rising_edge(iClk)) then
--		if(iRxDataValid='1') then
--			s_Sel <= iv32_RxData(1 downto 0);
--		end if;
--	end if;
--end process Data_proc;

--s_Sel <= iv32_RxData(1 downto 0) when iRxDataValid='1' else "00";
s_Sel <= iv32_RxData(1 downto 0);

-- register state logic
process(iRst,iClk)
begin
	if(iRst='1') then
		sv12_IQData_reg <= (others => '0');
		s_IQSel_reg <= '1';
	elsif(rising_edge(iClk)) then
		sv12_IQData_reg <= sv12_IQData_next;
		s_IQSel_reg <= s_IQSel_next;
	end if;
end process;

--next state logic
with s_Sel select
	sv12_IQData_next <= iv12_IQData_Tx1 when "11",
						iv12_IQData_Tx0 when "01",
						iv12_IQData_Tx0 when "10",
						(others => '0') when others;
						
with s_Sel select
	s_IQSel_next <= i_IQSel_Tx1 when "11",
				  i_IQSel_Tx0 when "01",
				  i_IQSel_Tx0 when "10",
				  '0' when others;
				  
--output state logic				  
ov12_IQData <= sv12_IQData_reg;
o_IQSel <= s_IQSel_reg;				  

end rtl;

