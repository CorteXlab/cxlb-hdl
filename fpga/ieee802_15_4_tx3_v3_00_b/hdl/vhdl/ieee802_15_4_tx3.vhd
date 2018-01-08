----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    11:50:08 02/03/2014 
-- Design Name:    IEEE 802.15.4
-- Module Name:    PicoSDR_Tx3_IEEE802_154 - structural 
-- Project Name:   IEEE 802.15.4
--
-- Revision: 0.02
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ieee802_15_4_pkg.ALL;

entity ieee802_15_4_tx3 is
    Port ( iRst : in  STD_LOGIC;
           iClk : in  STD_LOGIC;
			  iRxReady : in  STD_LOGIC;
           oRxRe : out  STD_LOGIC;
           iRxDataValid : in  STD_LOGIC;
           iv32_Data : in  STD_LOGIC_VECTOR (31 downto 0);
			  ov12_IQData : out  STD_LOGIC_VECTOR (11 DOWNTO 0);
			  oIQSel : out  STD_LOGIC);
end ieee802_15_4_tx3;

architecture structural of ieee802_15_4_tx3 is

COMPONENT rtdex_rx_if IS
GENERIC(CLKDIV : INTEGER := RTDEX_CLKDIV);
PORT ( iClk : IN  STD_LOGIC;
       iRst : IN  STD_LOGIC;
       iRxReady : IN  STD_LOGIC;
       oRxRe : OUT  STD_LOGIC;
       iRxDataValid : IN  STD_LOGIC;
		 oDValid : OUT  STD_LOGIC;
       iv32_RxData : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
       ov32_Data : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;

SIGNAL sv32_Data : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL sDValid0, sDValid1 : STD_LOGIC;

COMPONENT Tx3_IEEE802_15_4 IS
PORT ( iRst : IN  STD_LOGIC;
       iClk : IN  STD_LOGIC;
       iDValid : IN  STD_LOGIC;
       iv32_Data : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
       oDValid : OUT  STD_LOGIC;
       ov12_IData : OUT  STD_LOGIC_VECTOR (11 DOWNTO 0);
       ov12_QData : OUT  STD_LOGIC_VECTOR (11 DOWNTO 0));
END COMPONENT;

SIGNAL sv12_IData, sv12_QData : STD_LOGIC_VECTOR (11 DOWNTO 0);

COMPONENT lms6002d_dac_mux IS
PORT ( iRst : IN  STD_LOGIC;
       iClk : IN  STD_LOGIC;
       iDValid : IN  STD_LOGIC;
       iv12_IData : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
       iv12_QData : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
       ov12_IQData : OUT  STD_LOGIC_VECTOR (11 DOWNTO 0);
       oIQSel : OUT  STD_LOGIC);
END COMPONENT;

begin

rtdex_rx_if_inst : rtdex_rx_if
GENERIC MAP(CLKDIV => RTDEX_CLKDIV)
PORT MAP( iClk => iClk,
			 iRst => iRst,
          iRxReady => iRxReady,
          oRxRe => oRxRe,
          iRxDataValid => iRxDataValid,
			 oDValid => sDValid0,
          iv32_RxData => iv32_Data,
          ov32_Data => sv32_Data);
			 
Tx3_IEEE802_15_4_inst : Tx3_IEEE802_15_4
PORT MAP( iClk => iClk,
			 iRst => iRst,
          iDValid => sDValid0,
          iv32_Data => sv32_Data,
          oDValid => sDValid1,
          ov12_IData => sv12_IData,
          ov12_QData => sv12_QData);	

lms6002d_dac_mux_inst : lms6002d_dac_mux
PORT MAP( iClk => iClk,
			 iRst => iRst,
          iDValid => sDValid1,
          iv12_IData => sv12_IData,
          iv12_QData => sv12_QData,
          ov12_IQData => ov12_IQData,
          oIQSel => oIQSel);			 
			 
end structural;

