----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:59:45 11/11/2013 
-- Design Name: 
-- Module Name:    rxfilter - structural 
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
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rxfilter is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data : in  STD_LOGIC_VECTOR(11 downto 0);
           ov12_Data : out  STD_LOGIC_VECTOR(11 downto 0));
end rxfilter;

architecture structural of rxfilter is

TYPE dd_iv12b_Data_T IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(11 DOWNTO 0);										
signal sdv12_Data : dd_iv12b_Data_T;	

--TYPE dg_iv12_Data_T IS ARRAY (0 TO 7) OF SIGNED(11 DOWNTO 0);										
--signal sgv12_Data : dg_iv12_Data_T;	

TYPE ds_iv12b_Data_T IS ARRAY (0 TO 13) OF STD_LOGIC_VECTOR(11 DOWNTO 0);										
signal ssv12_Data : ds_iv12b_Data_T;

TYPE FLT_COEF_T IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT filter_coef : FLT_COEF_T := 	(	x"00",	--x"00",
														x"30",	--x"04",
														x"5A",	--x"07",
														x"76",	--x"09",
														x"7F",	--x"0A",
														x"76",	--x"09",
														x"5A",	--x"07",
														x"30");	--x"04");

component tap_delay is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data : in  STD_LOGIC_VECTOR(11 downto 0);
           ov12_Data : out STD_LOGIC_VECTOR(11 downto 0));
end component;

component tap_gain is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data : in  STD_LOGIC_VECTOR(11 downto 0);
			  iv8_Coef : in  STD_LOGIC_VECTOR(7 downto 0);
           ov12_Data : out  STD_LOGIC_VECTOR(11 downto 0));
end component;

component tap_sum is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data0 : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_Data1 : in  STD_LOGIC_VECTOR(11 downto 0);
           ov12_Data : out  STD_LOGIC_VECTOR(11 downto 0));
end component;

begin

sdv12_Data(0) <= iv12_Data;

taps_generate_loop : FOR I IN 0 TO 7 GENERATE
BEGIN
	tap_delay_generate : IF(I /= 0) GENERATE
	BEGIN
	tap_delay_inst : tap_delay
		 Port map(  i_Rst => i_Rst,
						i_Clk => i_Clk,
						i_En => i_En,
						iv12_Data => sdv12_Data(I-1),
						ov12_Data => sdv12_Data(I));
	END GENERATE tap_delay_generate;	

	tap_gain_inst : tap_gain
		 Port map(  i_Rst => i_Rst,
						i_Clk => i_Clk,
						i_En => i_En,
						iv12_Data => sdv12_Data(I),
						iv8_Coef => filter_coef(I),
						ov12_Data => ssv12_Data(I));	
END GENERATE taps_generate_loop;

-- SUM STAGE 0
sum_generate_loop_stage0 : FOR I IN 0 TO 3 GENERATE
	tap_sum_inst : tap_sum
		 Port map(  i_Rst => i_Rst,
						i_Clk => i_Clk,
						i_En => i_En,
						iv12_Data0 => ssv12_Data(2*I),
						iv12_Data1 => ssv12_Data(2*I+1),
						ov12_Data => ssv12_Data(I+8));
END GENERATE sum_generate_loop_stage0;

-- SUM STAGE 1
sum_generate_loop_stage1 : FOR I IN 0 TO 1 GENERATE
	tap_sum_inst : tap_sum
		 Port map(  i_Rst => i_Rst,
						i_Clk => i_Clk,
						i_En => i_En,
						iv12_Data0 => ssv12_Data(2*I+8),
						iv12_Data1 => ssv12_Data(2*I+1+8),
						ov12_Data => ssv12_Data(I+12));
END GENERATE sum_generate_loop_stage1;

-- SUM STAGE 2
tap_sum_inst7 : tap_sum
		 Port map(  i_Rst => i_Rst,
						i_Clk => i_Clk,
						i_En => i_En,
						iv12_Data0 => ssv12_Data(12),
						iv12_Data1 => ssv12_Data(13),
						ov12_Data => ov12_Data);
						
end structural;

