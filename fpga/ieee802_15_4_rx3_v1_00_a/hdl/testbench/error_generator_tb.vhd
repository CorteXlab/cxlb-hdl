--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:51:14 10/28/2013
-- Design Name:   
-- Module Name:   C:/fwspace/CARRIER_RECOVERY/DPLL_2ND_ORDER/ErrGen_Testbench.vhd
-- Project Name:  DPLL_2ND_ORDER
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: error_generator
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
 
ENTITY ErrGen_Testbench IS
END ErrGen_Testbench;
 
ARCHITECTURE behavior OF ErrGen_Testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT error_generator
	 GENERIC(NUMBER_SAMPLES_PER_SYMBOL : integer :=8);
    PORT(
         i_Rst : IN  std_logic;
         i_Clk : IN  std_logic;
         iv12_IData : IN  std_logic_vector(11 downto 0);
         iv12_QData : IN  std_logic_vector(11 downto 0);
         ov24_Error : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_Rst : std_logic := '0';
   signal i_Clk : std_logic := '0';
   signal iv12_IData : std_logic_vector(11 downto 0) := (others => '0');
   signal iv12_QData : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal ov24_Error : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant i_Clk_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: error_generator
	GENERIC MAP(NUMBER_SAMPLES_PER_SYMBOL=>8)
	PORT MAP (
          i_Rst => i_Rst,
          i_Clk => i_Clk,
          iv12_IData => iv12_IData,
          iv12_QData => iv12_QData,
          ov24_Error => ov24_Error
        );

   -- Clock process definitions
   i_Clk_process :process
   begin
		i_Clk <= '0';
		wait for i_Clk_period/2;
		i_Clk <= '1';
		wait for i_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		i_Rst <= '1';
      wait for i_Clk_period;
		i_Rst <= '0';
		iv12_IData <= x"002";
		iv12_QData <= x"012";
      wait for i_Clk_period;
		iv12_IData <= x"012";
		iv12_QData <= x"F42";
      wait for i_Clk_period;	
		iv12_IData <= x"002";
		iv12_QData <= x"012";
      wait for i_Clk_period;
		iv12_IData <= x"012";
		iv12_QData <= x"F42";
      wait for i_Clk_period;
		iv12_IData <= x"002";
		iv12_QData <= x"012";
      wait for i_Clk_period;
		iv12_IData <= x"012";
		iv12_QData <= x"F42";
      wait for i_Clk_period;		
      wait;
   end process;

END;
