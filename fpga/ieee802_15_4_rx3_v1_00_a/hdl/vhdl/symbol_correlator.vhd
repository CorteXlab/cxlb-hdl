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
	 Generic (ICORR_SEQ : std_logic_vector(15 downto 0) := x"0000";
				 QCORR_SEQ : std_logic_vector(15 downto 0) := x"0000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov12_Correlation : out  STD_LOGIC_VECTOR(11 downto 0));
end symbol_correlator;

architecture rtl of symbol_correlator is

signal sv16_IChip, sv16_QChip : signed(16 downto 0);
signal sv6_RRP, sv6_IIP, sv6_IRP, sv6_RIP : signed(5 downto 0);

begin

--sv16_IChip <= shift_right(sv16_IChip,1);
--sv16_QChip <= shift_right(sv16_QChip,1);
--sv16_IChip(0) <= i_IChip;
--sv16_QChip(0) <= i_QChip;

shift_proc : process(i_Rst, i_Clk)
begin
	if(i_Rst='1') then
		sv16_IChip <= (others => '0');
		sv16_QChip <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		sv16_IChip <= shift_right(sv16_IChip,1);
		sv16_QChip <= shift_right(sv16_QChip,1);
		sv16_IChip(0) <= i_IChip;
		sv16_QChip(0) <= i_QChip;
	end if;
end process;

RRProc : process(i_Rst, i_Clk)
variable cnt : integer range 0 to 16 := 0;
variable RRProduct : signed(5 downto 0) := (others => '0');
variable vIChip : signed(1 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		RRProduct := (others => '0');
	elsif(rising_edge(i_Clk)) then
		for cnt in 0 to 15 loop
			if(sv16_IChip(cnt)='0') then
				vIChip := to_signed(1,2);
			else
				vIChip := to_signed(-1,2);
			end if;	
			if(ICORR_SEQ(15-cnt)='0') then
				RRProduct := RRProduct + vIChip;
			else
				RRProduct := RRProduct - vIChip;
			end if;
		end loop;
		sv6_RRP <= RRProduct;
	end if;
end process RRProc;

IIProc : process(i_Rst, i_Clk)
variable cnt : integer range 0 to 16 := 0;
variable IIProduct : signed(5 downto 0) := (others => '0');
variable vQChip : signed(1 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		IIProduct := (others => '0');
	elsif(rising_edge(i_Clk)) then
		for cnt in 0 to 15 loop
			if(sv16_QChip(cnt)='0') then
				vQChip := to_signed(1,2);
			else
				vQChip := to_signed(-1,2);
			end if;			
			if(QCORR_SEQ(15-cnt)='0') then
				IIProduct := IIProduct + vQChip;
			else
				IIProduct := IIProduct - vQChip;
			end if;
		end loop;
		sv6_IIP <= IIProduct;
	end if;
end process IIProc;

IRProc : process(i_Rst, i_Clk)
variable cnt : integer range 0 to 16 := 0;
variable IRProduct : signed(5 downto 0) := (others => '0');
variable vIChip : signed(1 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		IRProduct := (others => '0');
	elsif(rising_edge(i_Clk)) then
		for cnt in 0 to 15 loop
			if(sv16_IChip(cnt)='0') then
				vIChip := to_signed(1,2);
			else
				vIChip := to_signed(-1,2);
			end if;			
			if(QCORR_SEQ(15-cnt)='0') then
				IRProduct := IRProduct + vIChip;
			else
				IRProduct := IRProduct - vIChip;
			end if;
		end loop;
		sv6_IRP <= IRProduct;
	end if;
end process IRProc;

RIProc : process(i_Rst, i_Clk)
variable cnt : integer range 0 to 16 := 0;
variable RIProduct : signed(5 downto 0) := (others => '0');
variable vQChip : signed(1 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		RIProduct := (others => '0');
	elsif(rising_edge(i_Clk)) then
		for cnt in 0 to 15 loop
			if(sv16_QChip(cnt)='0') then
				vQChip := to_signed(1,2);
			else
				vQChip := to_signed(-1,2);
			end if;			
			if(ICORR_SEQ(15-cnt)='0') then
				RIProduct := RIProduct + vQChip;
			else
				RIProduct := RIProduct - vQChip;
			end if;
		end loop;
		sv6_RIP <= RIProduct;
	end if;
end process RIProc;

ABS_CORR_PROC : process(i_Rst,i_Clk)
variable v6_rrp_m_iip : signed(5 downto 0) := (others => '0');
variable v6_rip_p_irp : signed(5 downto 0) := (others => '0');

variable v12_square_rrp_m_iip : signed(11 downto 0) := (others => '0');
variable v12_square_rip_p_irp : signed(11 downto 0) := (others => '0');

begin
	if(i_Rst='1') then
			ov12_Correlation <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		v6_rrp_m_iip := sv6_RRP - sv6_IIP;
		v6_rip_p_irp := sv6_IRP + sv6_RIP;
		v12_square_rrp_m_iip := v6_rrp_m_iip * v6_rrp_m_iip;
		v12_square_rip_p_irp := v6_rip_p_irp * v6_rip_p_irp;
		
		ov12_Correlation <= std_logic_vector(v12_square_rrp_m_iip + v12_square_rip_p_irp);
		
		--ov12_Correlation <= to_signed((sv6_RRP-sv6_IIP)*(sv6_RRP-sv6_IIP),12) +
		--						  to_signed((sv6_IRP+sv6_RIP)*(sv6_IRP+sv6_RIP),12);							  
	end if;
end process ABS_CORR_PROC;

end rtl;

