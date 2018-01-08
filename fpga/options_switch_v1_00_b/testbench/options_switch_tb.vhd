----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    17:34:02 09/13/2013 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    options_switch_tb - rtl 
-- Project Name: 	 IEEE 802.15.4
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY options_switch_tb IS
END options_switch_tb;
 
ARCHITECTURE rtl OF options_switch_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT options_switch
    PORT(
         iClk : IN  std_logic;
         iRst : IN  std_logic;
         iRxReady : IN  std_logic;
         oRxRe : OUT  std_logic;
         iRxDataValid : IN  std_logic;
         iv32_RxData : IN  std_logic_vector(31 downto 0);
         iv12_IQData_Tx0 : IN  std_logic_vector(11 downto 0);
         iv12_IQData_Tx1 : IN  std_logic_vector(11 downto 0);
         ov12_IQData : OUT  std_logic_vector(11 downto 0);
         i_IQSel_Tx0 : IN  std_logic;
         i_IQSel_Tx1 : IN  std_logic;
         o_IQSel : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal iClk : std_logic := '0';
   signal iRst : std_logic := '0';
   signal iRxReady : std_logic := '0';
   signal iRxDataValid : std_logic := '0';
   signal iv32_RxData : std_logic_vector(31 downto 0) := (others => '0');
   signal iv12_IQData_Tx0 : std_logic_vector(11 downto 0) := (others => '0');
   signal iv12_IQData_Tx1 : std_logic_vector(11 downto 0) := (others => '0');
   signal i_IQSel_Tx0 : std_logic := '0';
   signal i_IQSel_Tx1 : std_logic := '0';
	
	signal Clk_div2 : std_logic := '0';

 	--Outputs
   signal oRxRe : std_logic;
   signal ov12_IQData : std_logic_vector(11 downto 0);
   signal o_IQSel : std_logic;

   -- Clock period definitions
   constant iClk_period : time := 0.0625 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: options_switch PORT MAP (
          iClk => iClk,
          iRst => iRst,
          iRxReady => iRxReady,
          oRxRe => oRxRe,
          iRxDataValid => iRxDataValid,
          iv32_RxData => iv32_RxData,
          iv12_IQData_Tx0 => iv12_IQData_Tx0,
          iv12_IQData_Tx1 => iv12_IQData_Tx1,
          ov12_IQData => ov12_IQData,
          i_IQSel_Tx0 => i_IQSel_Tx0,
          i_IQSel_Tx1 => i_IQSel_Tx1,
          o_IQSel => o_IQSel
        );

   -- Clock process definitions
   iClk_process :process
   begin
		iClk <= '1';
		wait for iClk_period/2;
		iClk <= '0';
		wait for iClk_period/2;
   end process;
 
--    -- Div Clock by 2
--   Clk_div2_process :process
--   begin
--		Clk_div2 <= '1';
--		wait for iClk_period;
--		Clk_div2 <= '0';
--		wait for iClk_period;
--   end process;

    -- Div Clock by 2
   Clk_div2_process :process(iRst, iClk)
   begin
		if(iRst='1') then
			Clk_div2 <= '1';
		elsif(rising_edge(iClk)) then
			Clk_div2 <= not Clk_div2;
		end if;
   end process;
	
   iRxReady <= '1';
   iRxDataValid <= '1';      
	i_IQSel_Tx0 <= Clk_div2;
   i_IQSel_Tx1 <= Clk_div2;
   -- Stimulus process
   stim_proc: process
   begin		
		iRst <= '1';
      wait for iClk_period;	
		iRst <= '0';

      iv32_RxData <= (others => '0');
      iv12_IQData_Tx0 <= x"111";
      iv12_IQData_Tx1 <= x"FFF";	
      wait for iClk_period*2;
      iv32_RxData <= x"00000001";	--((others=>'0') & (1 downto 0)=>"01");
      iv12_IQData_Tx0 <= x"210";
      iv12_IQData_Tx1 <= x"DEF";		
      wait for iClk_period*2;	
      iv32_RxData <= x"00000003";	--((1 downto 0)=>"11" & others => '0');
      iv12_IQData_Tx0 <= x"543";
      iv12_IQData_Tx1 <= x"ABC";		
      wait for iClk_period*2;
      iv32_RxData <= x"00000002";	--((1 downto 0)=>"10" & others => '0');
      iv12_IQData_Tx0 <= x"876";
      iv12_IQData_Tx1 <= x"987";		
      wait for iClk_period*2;	
      iv32_RxData <= (others => '0');
      iv12_IQData_Tx0 <= x"111";
      iv12_IQData_Tx1 <= x"FFF";		
      wait for iClk_period*2;	
		REPORT "Similation Finished";
		ASSERT FALSE REPORT "NONE. End of simulation." SEVERITY FAILURE;		
   end process;

END;
