--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:24:06 11/08/2013
-- Design Name:   
-- Module Name:   C:/fwspace/TEST_FOR_CORRELATION/simple_test/testbench.vhd
-- Project Name:  simple_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decoder
    PORT(
         i_Rst : IN  std_logic;
         i_Clk : IN  std_logic;
         i_En : IN  std_logic;
         i_BitPreamble : IN  std_logic;
         i_BitSFD : IN  std_logic;
         i_BitSymbol : IN  std_logic;
         o_Bit : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_Rst : std_logic := '0';
   signal i_Clk : std_logic := '0';
   signal i_En : std_logic := '0';
   signal i_BitPreamble : std_logic := '0';
   signal i_BitSFD : std_logic := '0';
   signal i_BitSymbol : std_logic := '0';

 	--Outputs
   signal o_Bit : std_logic;

   -- Clock period definitions
   constant i_Clk_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decoder PORT MAP (
          i_Rst => i_Rst,
          i_Clk => i_Clk,
          i_En => i_En,
          i_BitPreamble => i_BitPreamble,
          i_BitSFD => i_BitSFD,
          i_BitSymbol => i_BitSymbol,
          o_Bit => o_Bit
        );

   -- Clock process definitions
   i_Clk_process :process
   begin
		i_Clk <= '1';
		wait for i_Clk_period/2;
		i_Clk <= '0';
		wait for i_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin			

		i_Rst <= '1';
      wait for i_Clk_period;
		
		i_Rst <= '0';
		i_En <= '1';
		i_BitPreamble <= '0';
		i_BitSFD <= '0';
		i_BitSymbol <= '0';
      wait for i_Clk_period*3;	
		i_BitPreamble <= '1';
      wait for i_Clk_period;	
		i_BitPreamble <= '0';
      wait for i_Clk_period*2;	
		i_BitSFD <= '1';
      wait for i_Clk_period;
		i_BitPreamble <= '0';
		i_BitSFD <= '0';
		i_BitSymbol <= '1';
      wait for i_Clk_period*3;	
		i_BitSymbol <= '0';
      wait for i_Clk_period*2;
		i_BitSymbol <= '1';
      wait for i_Clk_period*5;		

      -- insert stimulus here 

      wait;
   end process;

END;
