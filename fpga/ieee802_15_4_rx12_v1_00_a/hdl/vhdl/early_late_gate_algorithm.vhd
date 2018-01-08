----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:45 10/29/2013 
-- Design Name: 
-- Module Name:    early_late_gate_algorithm - rtl 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."log2";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity early_late_gate_algorithm is
	 Generic(NUMBER_SAMPLES_PER_SYMBOL : integer :=8);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv12_IData : in  SIGNED (11 downto 0);
           iv12_QData : in  SIGNED (11 downto 0);
           o_IChip : out  STD_LOGIC;
           o_QChip : out  STD_LOGIC);
end early_late_gate_algorithm;

architecture rtl of early_late_gate_algorithm is

signal sv12_realp  : SIGNED (11 downto 0);
signal sv12_early  : SIGNED (11 downto 0);
signal sv12_prompt : SIGNED (11 downto 0);
signal sv12_late   : SIGNED (11 downto 0);

signal Ks : integer range 0 to NUMBER_SAMPLES_PER_SYMBOL := 0;

begin

real_pos_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		sv12_realp <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		if(iv12_IData<0) then
			sv12_realp <= -iv12_IData;
		else
			sv12_realp <= iv12_IData;
		end if;
	end if;
end process real_pos_proc;

-- sample & hold
early_proc : process(i_Rst,i_Clk)
variable k : integer range 0 to NUMBER_SAMPLES_PER_SYMBOL := 0;
begin
	if(i_Rst='1') then
		sv12_early <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		k := k + 1;
		if(k=Ks) then
			k := 0;
			sv12_early <= sv12_realp;
		end if;
	end if;
end process early_proc;

prompt_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		sv12_prompt <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		sv12_prompt <= sv12_early;
	end if;
end process prompt_proc;

late_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		sv12_late <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		sv12_late <= sv12_prompt;
	end if;
end process late_proc;

logic_decision_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		o_IChip <= '0';
		o_QChip <= '0';
	elsif(rising_edge(i_Clk)) then
		if(sv12_prompt>sv12_early and sv12_prompt>sv12_late) then
			Ks <= 8;
			if(iv12_IData <0) then
				o_IChip <= '1'; 
			else
				o_IChip <= '0';
			end if;	
			if(iv12_QData <0) then
				o_QChip <= '1'; 
			else
				o_QChip <= '0';
			end if;
		elsif(sv12_prompt>sv12_early and sv12_prompt<sv12_late and Ks>4) then
			Ks <= Ks + 1;
		elsif(sv12_prompt<sv12_early and sv12_prompt>sv12_late and Ks>4) then
			Ks <= Ks - 1;	
		end if;	
	end if;
end process logic_decision_proc;

end rtl;

