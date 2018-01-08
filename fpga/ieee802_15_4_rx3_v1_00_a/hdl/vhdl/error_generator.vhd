----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:20:01 10/28/2013 
-- Design Name: 
-- Module Name:    error_generator - rtl 
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
--use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real."log2";
--use IEEE.math_real."ceil";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity error_generator is
	 Generic(NUMBER_SAMPLES_PER_SYMBOL : integer :=8);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           ov24_Error : out  STD_LOGIC_VECTOR (23 downto 0));
end error_generator;

architecture rtl of error_generator is
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

begin

process(i_Rst,i_Clk)
variable v12_Error : std_logic_vector(23 downto 0) := (others => '0');
begin
	if(i_Rst='1') then
		ov24_Error <= (others => '0');
	elsif(rising_edge(i_Clk)) then
		v12_Error := signed(iv12_IData) * signed(iv12_QData);
		ov24_Error <= shrn(v12_Error,integer(log2(real(NUMBER_SAMPLES_PER_SYMBOL/2))));	--log2(NUMBER_SAMPLES_PER_SYMBOL/2));	--e(n) = 2*I*Q/Ns
																													--integer(ceil(log2(real(a))))
	end if;
end process;

end rtl;

