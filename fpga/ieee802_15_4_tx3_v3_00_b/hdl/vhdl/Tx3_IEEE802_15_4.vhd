----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    17:07:11 01/31/2014 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    Tx3_IEEE802_15_4 - structural 
-- Project Name:	 IEEE 802.15.4  
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ieee802_15_4_pkg.ALL;

entity Tx3_IEEE802_15_4 is
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
           iDValid : in  STD_LOGIC;
           iv32_Data : in  STD_LOGIC_VECTOR (31 downto 0);
           oDValid : out  STD_LOGIC;
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
end Tx3_IEEE802_15_4;

architecture structural of Tx3_IEEE802_15_4 is

   COMPONENT splitter IS
   GENERIC(CLKDIV : INTEGER := SPLIT_CLKDIV);
   PORT(
        iRst : IN  std_logic;
        iClk : IN  std_logic;
        iv32_Data : IN  std_logic_vector(31 DOWNTO 0);
        ov4_Data : OUT  std_logic_vector(3 DOWNTO 0);
        iDValid : IN  std_logic;
        oDValid : OUT  std_logic
       );
   END COMPONENT;
	
	SIGNAL sDValid : STD_LOGIC;
	SIGNAL sv4_Data : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	COMPONENT symbol2chip IS
	GENERIC(CLKDIV : INTEGER := S2C_CLKDIV);
	PORT( iRst : IN  STD_LOGIC;
			iClk : IN  STD_LOGIC;
			iDValid : IN  STD_LOGIC;
			iv4_Data : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			oIChip : OUT  STD_LOGIC;
			oQChip : OUT  STD_LOGIC;
			oDValid : OUT  STD_LOGIC);
   END COMPONENT;	

	SIGNAL sIChip, sQChip, sDValid1, sDValid2 : STD_LOGIC; 
	
	COMPONENT txfilter is
	GENERIC(CLKDIV : integer := TXF_CLKDIV);
	PORT( iRst : in  STD_LOGIC;
         iClk : in  STD_LOGIC;
         iDValid : in  STD_LOGIC;
         iISymbol : in  STD_LOGIC;
         iQSymbol : in  STD_LOGIC;
         oDValid : out  STD_LOGIC;
         ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
         ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
   END COMPONENT;	
begin

   splitter_inst: splitter 
	GENERIC MAP(CLKDIV => SPLIT_CLKDIV)	
	PORT MAP(iRst => iRst,
            iClk => iClk,
				iv32_Data => iv32_Data,
				ov4_Data => sv4_Data,
				iDValid => iDValid,
				oDValid => sDValid);

   symbol2chip_inst : symbol2chip
	GENERIC MAP(CLKDIV => S2C_CLKDIV)
	PORT MAP(iRst => iRst,
            iClk => iClk,
				iDValid => sDValid,
				iv4_Data => sv4_Data,
				oIChip => sIChip,
				oQChip => sQChip,
				oDValid => sDValid1);	

	txfilter_inst : txfilter
	GENERIC MAP(CLKDIV => TXF_CLKDIV)
	PORT MAP(iRst => iRst,
            iClk => iClk,
				iDValid => sDValid1,
				iISymbol => sIChip,
				iQSymbol => sQChip,
				oDValid => oDValid,
				ov12_IData => ov12_IData,
				ov12_QData => ov12_QData);				
				
end structural;

