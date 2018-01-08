----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:38 08/14/2013 
-- Design Name: 
-- Module Name:    cordic_rotation_core_step - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_rotation_core_step is
	 Generic( step : integer := 0;
				 Angle :  STD_LOGIC_VECTOR (15 downto 0):=x"0000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           o_En : out  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov16_Phase : out  STD_LOGIC_VECTOR (15 downto 0));
end cordic_rotation_core_step;

architecture rtl of cordic_rotation_core_step is

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

core_proc : process(i_Rst,i_Clk,i_En)
variable tv12_IData : STD_LOGIC_VECTOR (11 downto 0):=x"000";
variable tv12_QData : STD_LOGIC_VECTOR (11 downto 0):=x"000";
variable tv16_Angle : STD_LOGIC_VECTOR (15 downto 0):=x"0000";
begin
	if(i_Rst='1') then
		o_En <= '0';
		ov12_IData <= (others => '0');
		ov12_QData <= (others => '0');
		ov16_Phase <= (others => '0');	
	elsif(rising_edge(i_Clk)) then
		if(i_En='1') then
			o_En <= '1';				
			if(signed(iv16_Phase)>=0) then
				ov12_IData <= signed(iv12_IData) - signed(shrn(iv12_QData,step));
				ov12_QData <= signed(iv12_QData) + signed(shrn(iv12_IData,step));
				ov16_Phase <= signed(iv16_Phase) - signed(Angle);				
			else
				ov12_IData <= signed(iv12_IData) + signed(shrn(iv12_QData,step));
				ov12_QData <= signed(iv12_QData) - signed(shrn(iv12_IData,step));
				ov16_Phase <= signed(iv16_Phase) + signed(Angle);				
			end if;	
		else
			o_En <= '0';
			ov12_IData <= iv12_IData;
			ov12_QData <= iv12_QData;
			ov16_Phase <= iv16_Phase;		
		end if;
	end if;
end process core_proc;

end rtl;



