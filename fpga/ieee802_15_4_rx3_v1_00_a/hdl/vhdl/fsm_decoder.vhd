----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:05 11/07/2013 
-- Design Name: 
-- Module Name:    fsm_decoder - rtl 
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
-- arithmetic functions with Signed or SIGNED values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_decoder is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Preamble : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_SFD : in  STD_LOGIC_VECTOR(11 downto 0);
           o_EnSFD : out  STD_LOGIC;
           o_EnSBC : out  STD_LOGIC);
end fsm_decoder;

architecture rtl of fsm_decoder is

type hw_fsm_decoder_state_type is (idle, Preamble_Detection, SFD_Detection, Symbol_Decoding);
signal state_reg, state_next : hw_fsm_decoder_state_type;
signal s_EnSFD, s_EnSBC : std_logic;
signal s_EnSFD_buf, s_EnSBC_buf : std_logic;

begin

-- state register
state_register : process(i_Clk,i_Rst,i_En)
begin
	if(i_Rst='1') then
		state_reg <= idle;
	elsif(falling_edge(i_Clk)) then
		if(i_En='1') then
			state_reg <= state_next;
		else
			state_reg <= idle;
		end if;	
	end if;
end process state_register;

-- output buffer
output_buffer : process(i_Rst,i_Clk,i_En)
begin
	if(i_Rst='1') then
		s_EnSFD_buf <= '0';
		s_EnSBC_buf <= '0';		
	elsif(falling_edge(i_Clk)) then
		if(i_En='1') then
			s_EnSFD_buf <= s_EnSFD;
			s_EnSBC_buf <= s_EnSBC;
		else
			s_EnSFD_buf <= '0';
			s_EnSBC_buf <= '0';			
		end if;
	end if;
end process output_buffer;

-- next state logic
next_state_logic : process(state_reg, iv12_Preamble,iv12_SFD)--, i_Clk)
begin
--if(rising_edge(i_Clk)) then
	case state_reg is
		when idle =>
			if(i_En='1') then
				state_next <= Preamble_Detection;
			else
				state_next <= idle;
			end if;	
		when Preamble_Detection =>
			if(signed(iv12_Preamble)>1000) then
				state_next <= SFD_Detection;
			else
				state_next <= Preamble_Detection;
			end if;			
		when SFD_Detection =>
			if(signed(iv12_SFD)>1000) then
				state_next <= Symbol_Decoding;
			else
				state_next <= SFD_Detection;
			end if;
		when Symbol_Decoding =>
			if(i_En='1') then
				state_next <= Symbol_Decoding;
			else
				state_next <= idle;
			end if;
		when others => state_next <= idle;
	end case;
--end if;	
end process next_state_logic;

-- Moore logic output
moore_logic_output : process(state_reg, i_Clk)
begin
--if(rising_edge(i_Clk)) then
	s_EnSFD <= '0';
	s_EnSBC <= '0';
	case state_reg is
		when idle =>
		when Preamble_Detection =>	
			s_EnSFD <= '1';
			s_EnSBC <= '0';
		when SFD_Detection =>
			s_EnSFD <= '0';
			s_EnSBC <= '1';
		when others =>
			s_EnSFD <= '0';
			s_EnSBC <= '0';
	end case;
--end if;	
end process moore_logic_output;

--output
o_EnSFD <= s_EnSFD_buf;
o_EnSBC <= s_EnSBC_buf;

end rtl;

