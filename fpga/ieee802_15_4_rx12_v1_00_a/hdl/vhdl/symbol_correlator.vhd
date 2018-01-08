----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:25:22 11/04/2013 
-- Design Name: 
-- Module Name:    symbol_correlator - rtl 
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
-- arithmetic functions with Signed or signed values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity symbol_correlator is
	 Generic (CORR_SEQ : std_logic_vector(14 downto 0) := "000000000000000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_Chip : in  STD_LOGIC;
           ov12_Correlation : out  signed (11 downto 0));
end symbol_correlator;

architecture rtl of symbol_correlator is

signal sv15_Chip : signed(14 downto 0);

begin

shift_proc : process(i_Rst, i_Clk, i_En)
begin
	if(i_Rst='1') then
		sv15_Chip <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		if(i_En='1') then
			sv15_Chip <= shift_left(sv15_Chip,1);
			sv15_Chip(0) <= i_Chip;
		else	
			sv15_Chip <= (others => '0');
		end if;	
	end if;
end process shift_proc;

RRProc : process(i_Rst, i_Clk, i_En)
variable cnt : integer range 0 to 15 := 0;
variable RRProduct : signed(5 downto 0) := (others => '0');
variable vChip : signed(1 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		RRProduct := (others => '0');
		ov12_Correlation <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		if(i_En='1') then
			for cnt in 0 to 14 loop
				if(sv15_Chip(cnt)='0') then
					vChip := to_signed(1,2);
				else
					vChip := to_signed(-1,2);
				end if;	
				if(CORR_SEQ(14-cnt)='0') then
					RRProduct := RRProduct + vChip;
				else
					RRProduct := RRProduct - vChip;
				end if;
			end loop;
			ov12_Correlation <= RRProduct * RRProduct;
		else
			ov12_Correlation <= (others => '0');
		end if;	
	end if;
end process RRProc;

end rtl;

