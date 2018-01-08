----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:39:39 08/13/2013 
-- Design Name: 
-- Module Name:    cordic_rotation_term - rtl 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_rotation_term is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
			  ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
           --ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end cordic_rotation_term;

architecture rtl of cordic_rotation_term is

  FUNCTION shrn(iv_data:std_logic_vector; n:integer) return std_logic_vector is 
    variable ov_data : std_logic_vector(iv_data'high downto iv_data'low); 
  begin 
    if(n = 0) then 
      ov_data := iv_data; 
    elsif(n<iv_data'high) then 
		if(iv_data(iv_data'high)='0') then
		 ov_data(ov_data'high downto ov_data'high-(n-1)) := (others => '0'); 
		 ov_data(ov_data'high -n downto 0) := iv_data(iv_data'high downto n);		
		else
			ov_data := (others => iv_data(iv_data'high)); 
			for i in iv_data'high downto 0 loop 
			  ov_data(i-n) := iv_data(i); 
			  if(i = n) then 
				 exit; 
			  end if; 
			end loop;
		end if;	
	 else
		ov_data := (others => '0'); 	 
    end if; 
    return ov_data; 
  end shrn;

  FUNCTION gain_scale(iv_data:std_logic_vector) return std_logic_vector is 
    variable ov_data : std_logic_vector(11 downto 0):=x"000"; 
	 variable sign_vector : std_logic_vector(11 downto 0) := "010110010010";
  begin 
		for i in 11 downto 0 loop 
			if(sign_vector(i)='0') then
				ov_data := signed(ov_data) + signed(shrn(iv_data,11-i));
			else
				ov_data := signed(ov_data) - signed(shrn(iv_data,11-i));
			end if;
		end loop;
    return ov_data; 
  end gain_scale;

begin

process(i_Rst,i_Clk)
begin
	if(i_Rst='1') then
		ov12_IData <= (others => '0');
		ov12_QData <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		if(i_En='0') then
			ov12_IData <= iv12_IData;
			ov12_QData <= iv12_QData;
		else
			ov12_IData <= gain_scale(iv12_IData);
			ov12_QData <= gain_scale(iv12_QData);
		end if;
	end if;
end process;

end rtl;

