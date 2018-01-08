----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:28:54 11/08/2013 
-- Design Name: 
-- Module Name:    symbol_bank_correlator - structural 
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

entity symbol_bank_correlator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov4_Symbol : out  STD_LOGIC_VECTOR (3 downto 0));
end symbol_bank_correlator;

architecture structural of symbol_bank_correlator is

type bank_correlation_vector_stage0_type is array(0 to 15) of STD_LOGIC_VECTOR(11 downto 0);
type bank_correlation_vector_stage1_type is array(0 to 7) of STD_LOGIC_VECTOR(11 downto 0);
type bank_correlation_vector_stage2_type is array(0 to 3) of STD_LOGIC_VECTOR(11 downto 0);
type bank_correlation_vector_stage3_type is array(0 to 1) of STD_LOGIC_VECTOR(11 downto 0);

type bank_index_vector_stage0_type is array(0 to 15) of std_logic_vector(3 downto 0);
type bank_index_vector_stage1_type is array(0 to 7) of std_logic_vector(3 downto 0);
type bank_index_vector_stage2_type is array(0 to 3) of std_logic_vector(3 downto 0);
type bank_index_vector_stage3_type is array(0 to 1) of std_logic_vector(3 downto 0);

type mem_vector_type is array(0 to 15) of std_logic_vector(15 downto 0);

constant I_REF_SEQ : mem_vector_type := (	x"598E",
														x"752A",
														x"E598",
														x"A752",
														x"8E59",
														x"2A75",
														x"98E5",
														x"52A7",
														x"598E",
														x"752A",
														x"E598",
														x"A752",
														x"8E59",
														x"2A75",
														x"98E5",
														x"52A7");

constant Q_REF_SEQ : mem_vector_type := ( x"B934",
														x"D6E0",
														x"4B93",
														x"0D6E",
														x"34B9",
														x"E0D6",
														x"934B",
														x"6E0D",
														x"46CB",
														x"291F",
														x"B46C",
														x"F291",
														x"CB46",
														x"1F29",
														x"6CB4",
														x"91F2");


signal sv12_correlation_stage0 : bank_correlation_vector_stage0_type;
signal sv12_correlation_stage1 : bank_correlation_vector_stage1_type;
signal sv12_correlation_stage2 : bank_correlation_vector_stage2_type;
signal sv12_correlation_stage3 : bank_correlation_vector_stage3_type;

signal sv4_index_stage0 : bank_index_vector_stage0_type;
signal sv4_index_stage1 : bank_index_vector_stage1_type;
signal sv4_index_stage2 : bank_index_vector_stage2_type;
signal sv4_index_stage3 : bank_index_vector_stage3_type;

component symbol_correlator is
	 Generic (ICORR_SEQ : std_logic_vector(15 downto 0) := x"0000";
				 QCORR_SEQ : std_logic_vector(15 downto 0) := x"0000");
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
			  i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov12_Correlation : out  STD_LOGIC_VECTOR(11 downto 0));
end component;

component comparator is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_PortData0 : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_PortData1 : in  STD_LOGIC_VECTOR(11 downto 0);
           iv4_PortIndex0 : in  STD_LOGIC_VECTOR (3 downto 0);
           iv4_PortIndex1 : in  STD_LOGIC_VECTOR (3 downto 0);
           ov4_PortIndex : out  STD_LOGIC_VECTOR (3 downto 0);
           ov12_PortData : out  STD_LOGIC_VECTOR(11 downto 0));
end component;

begin

sv4_index_stage0(0) <= x"0";
sv4_index_stage0(1) <= x"1";
sv4_index_stage0(2) <= x"2";
sv4_index_stage0(3) <= x"3";
sv4_index_stage0(4) <= x"4";
sv4_index_stage0(5) <= x"5";
sv4_index_stage0(6) <= x"6";
sv4_index_stage0(7) <= x"7";
sv4_index_stage0(8) <= x"8";
sv4_index_stage0(9) <= x"9";
sv4_index_stage0(10) <= x"A";
sv4_index_stage0(11) <= x"B";
sv4_index_stage0(12) <= x"C";
sv4_index_stage0(13) <= x"D";
sv4_index_stage0(14) <= x"E";
sv4_index_stage0(15) <= x"F";

symbol_correlator_generate_loop : for I in 0 TO 15 Generate
symbol_correlator_inst : symbol_correlator
	 Generic map(ICORR_SEQ => I_REF_SEQ(I),
				 QCORR_SEQ => Q_REF_SEQ(I))
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_IChip => i_IChip,
				  i_QChip => i_QChip,
				  ov12_Correlation => sv12_correlation_stage0(I));
end generate symbol_correlator_generate_loop;			  

--First STAGE OF COMARATORS <16/2 = 8>
comparators_stage0_generate_loop : for J in 0 TO 7 Generate
comparator_inst_stage0 : comparator
	Port map( i_Rst => i_Rst,
				 i_Clk => i_Clk,
				 i_En => i_En,
				 iv12_PortData0 => sv12_correlation_stage0(2*J),
				 iv12_PortData1 => sv12_correlation_stage0(2*J+1),
				 iv4_PortIndex0 => sv4_index_stage0(2*J),
				 iv4_PortIndex1 => sv4_index_stage0(2*J+1),
				 ov4_PortIndex => sv4_index_stage1(J),
				 ov12_PortData => sv12_correlation_stage1(J));
end generate comparators_stage0_generate_loop;

--SECOND STAGE OF COMARATORS <8/2 = 4>
comparators_stage1_generate_loop : for J in 0 TO 3 Generate
comparator_inst_stage1 : comparator
	Port map( i_Rst => i_Rst,
				 i_Clk => i_Clk,
				 i_En => i_En,
				 iv12_PortData0 => sv12_correlation_stage1(2*J),
				 iv12_PortData1 => sv12_correlation_stage1(2*J+1),
				 iv4_PortIndex0 => sv4_index_stage1(2*J),
				 iv4_PortIndex1 => sv4_index_stage1(2*J+1),
				 ov4_PortIndex => sv4_index_stage2(J),
				 ov12_PortData => sv12_correlation_stage2(J));
end generate comparators_stage1_generate_loop;

--THIRD STAGE OF COMARATORS <4/2 = 2>
comparators_stage2_generate_loop : for J in 0 TO 1 Generate
comparator_inst_stage2 : comparator
	Port map( i_Rst => i_Rst,
				 i_Clk => i_Clk,
				 i_En => i_En,
				 iv12_PortData0 => sv12_correlation_stage2(2*J),
				 iv12_PortData1 => sv12_correlation_stage2(2*J+1),
				 iv4_PortIndex0 => sv4_index_stage2(2*J),
				 iv4_PortIndex1 => sv4_index_stage2(2*J+1),
				 ov4_PortIndex => sv4_index_stage3(J),
				 ov12_PortData => sv12_correlation_stage3(J));
end generate comparators_stage2_generate_loop;

comparator_inst_stage3 : comparator
	Port map( i_Rst => i_Rst,
				 i_Clk => i_Clk,
				 i_En => i_En,
				 iv12_PortData0 => sv12_correlation_stage3(0),
				 iv12_PortData1 => sv12_correlation_stage3(1),
				 iv4_PortIndex0 => sv4_index_stage3(0),
				 iv4_PortIndex1 => sv4_index_stage3(1),
				 ov4_PortIndex => ov4_Symbol);
				 
end structural;

