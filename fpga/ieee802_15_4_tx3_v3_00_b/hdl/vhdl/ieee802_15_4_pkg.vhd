----------------------------------------------------------------------------------
-- Company: INRIA
-- Engineer: Abdelbassat MASSOURI
-- 
-- Create Date:    11:38:22 02/03/2014 
-- Design Name: 	 IEEE 802.15.4
-- Module Name:    ieee802_15_4_pkg - pkg 
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
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ieee802_15_4_pkg is

constant USFact : integer := 8;

constant F_samp : integer := 8000000;
constant D_rate : integer := 250000;
constant D_symb : integer := 62500;
constant D_chip : integer := 2000000;
constant D_samp : integer := D_chip*USFact/2;

constant RTDEX_CLKDIV : integer := (F_samp/D_rate)*32*2;
constant SPLIT_CLKDIV : integer := (F_samp/D_rate)*4*2;
constant S2C_CLKDIV   : integer := (F_samp/D_chip)*2*2;
constant TXF_CLKDIV   : integer := 2;

--#########################################################################################
TYPE memv16x32 IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(0 TO 31);
--#########################################################################################
CONSTANT dsss_16pn_sequences_32b : memv16x32 :=   ( x"D9C3522E",
													x"ED9C3522",
													x"2ED9C352",
													x"22ED9C35",
													x"522ED9C3",
													x"3522ED9C",
													x"C3522ED9",
													x"9C3522ED",
													x"8C96077B",
													x"B8C96077",
													x"7B8C9607",
													x"77B8C960",
													x"077B8C96",
													x"6077B8C9",
													x"96077B8C",
													x"C96077B8");
--#########################################################################################
TYPE DLY_OQPSK IS ARRAY (0 TO USFact/2-1) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
--##############################################################################################
TYPE FLT_COEF_T IS ARRAY (0 TO USFact-1) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
--##############################################################################################
--		IF USFact = 8
--##############################################################################################
CONSTANT filter_coef : FLT_COEF_T := 	(	x"000",
											x"30F",
											x"5A8",
											x"764",
											x"7FF",
											x"764",
											x"5A8",
											x"30F");
--##############################################################################################
end ieee802_15_4_pkg;

package body ieee802_15_4_pkg is
 
end ieee802_15_4_pkg;
