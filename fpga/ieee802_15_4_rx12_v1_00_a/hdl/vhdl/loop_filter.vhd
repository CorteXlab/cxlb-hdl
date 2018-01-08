----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:50:55 10/29/2013 
-- Design Name: 
-- Module Name:    loop_filter - rtl 
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
--use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity loop_filter is
	 --Generic(kp : std_logic_vector(17 downto 0) := (others => '1');
	 --			ka : std_logic_vector(17 downto 0) := (others => '1'));
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv24_Error : in  STD_LOGIC_VECTOR (23 downto 0);
			  iv18_kp : in std_logic_vector(17 downto 0);
			  iv18_ka : in std_logic_vector(17 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end loop_filter;

architecture rtl of loop_filter is
signal e_old : std_logic_vector(23 downto 0);  
signal v_signal, v_old : std_logic_vector(41 downto 0);
signal phi_accum, phi_old : std_logic_vector(41 downto 0);  
begin

e_old_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		e_old <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		e_old <= iv24_Error;
	end if;
end process e_old_proc;

v_old_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		v_old <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		v_old <= v_signal;
	end if;
end process v_old_proc;

v_signal_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		v_signal <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		v_signal <= signed(v_old) + 
					   (signed(iv18_kp)+signed(iv18_ka))*signed(iv24_Error) -
  						signed(iv18_kp)*signed(e_old);
	end if;
end process v_signal_proc;

phi_old_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		phi_old <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		phi_old <= phi_accum;
	end if;
end process phi_old_proc;

phi_accum_proc : process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		phi_accum <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		phi_accum <= signed(phi_old) + signed(v_signal);
	end if;
end process phi_accum_proc;

ov16_Phase <= phi_accum(phi_accum'high downto phi_accum'high-15);

end rtl;

