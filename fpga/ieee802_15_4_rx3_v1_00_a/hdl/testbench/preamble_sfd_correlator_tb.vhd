--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:22:55 11/07/2013
-- Design Name:   
-- Module Name:   C:/fwspace/CORRELATION/PREAMBLE_SFD_CORRELATION/testbench.vhd
-- Project Name:  PREAMBLE_SFD_CORRELATION
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: preamble_sfd_correlator
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
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT preamble_sfd_correlator
	 Generic (ICORR_SEQ : std_logic_vector(31 downto 0) := x"00000000";
				 QCORR_SEQ : std_logic_vector(31 downto 0) := x"00000000");
    PORT(
         i_Rst : IN  std_logic;
         i_Clk : IN  std_logic;
         i_IChip : IN  std_logic;
         i_QChip : IN  std_logic;
         ov12_Correlation : OUT  SIGNED(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_Rst : std_logic := '0';
   signal i_Clk : std_logic := '0';
   signal i_IChip : std_logic := '0';
   signal i_QChip : std_logic := '0';

 	--Outputs
   signal ov12_Correlation : signed(11 downto 0);

   -- Clock period definitions
   constant i_Clk_period : time := 1 us;
	
	
	--constant sIChip : std_logic_vector(255 downto 0) := x"01234567A917A91701234567A917A91701234567A917A91701234567A917A917";
	--constant sQChip : std_logic_vector(255 downto 0) := x"01234567D9C2D9C201234567D9C2D9C201234567D9C2D9C201234567D9C2D9C2";
	
	--constant sIChip : std_logic_vector(511 downto 0) := x"0000000000000000000000000000000000000000A917A91700000000A917A91700000000A917A91700000000A917A91700000000000000000000000000000000";
	--constant sQChip : std_logic_vector(511 downto 0) := x"0000000000000000000000000000000000000000D9C2D9C200000000D9C2D9C200000000D9C2D9C200000000D9C2D9C200000000000000000000000000000000";	

	constant sIChip : std_logic_vector(0 to 511) :=   x"A917A917A917A917A917A917A917A917A45E7A910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	constant sQChip : std_logic_vector(0 to 511) :=   x"D9C2D9C2D9C2D9C2D9C2D9C2D9C2D9C2670BD2630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";	


BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: preamble_sfd_correlator
	Generic MAP(ICORR_SEQ => x"A917A917",
				   QCORR_SEQ => x"D9C2D9C2")
	PORT MAP (
          i_Rst => i_Rst,
          i_Clk => i_Clk,
          i_IChip => i_IChip,
          i_QChip => i_QChip,
          ov12_Correlation => ov12_Correlation
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
		for i in 0 to sIChip'high loop
			i_IChip <= sIChip(i);
			i_QChip <= sQChip(i);
			wait for i_Clk_period;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
