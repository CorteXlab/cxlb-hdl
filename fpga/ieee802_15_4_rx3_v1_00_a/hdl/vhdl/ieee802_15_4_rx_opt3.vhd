library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ieee802_15_4_rx_opt3 is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
			  ov4_Symbol : out  STD_LOGIC_VECTOR (3 downto 0));
end ieee802_15_4_rx_opt3;

architecture structural of ieee802_15_4_rx_opt3 is

component rxfilter is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_Data : in  STD_LOGIC_VECTOR(11 downto 0);
           ov12_Data : out  STD_LOGIC_VECTOR(11 downto 0));
end component rxfilter;

signal sv12_IData_filter, sv12_QData_filter : STD_LOGIC_VECTOR(11 downto 0);

component carrier_phase_recovery is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR (11 downto 0);
           iv16_Phase : in  STD_LOGIC_VECTOR (15 downto 0);
			  iv18_kp : in std_logic_vector(17 downto 0);
			  iv18_ka : in std_logic_vector(17 downto 0);			  
           ov12_IData : out  STD_LOGIC_VECTOR (11 downto 0);
           ov12_QData : out  STD_LOGIC_VECTOR (11 downto 0));
end component carrier_phase_recovery;

signal sv12_IData_cfo, sv12_QData_cfo : STD_LOGIC_VECTOR(11 downto 0);

component early_late_gate_algorithm is
	 Generic(NUMBER_SAMPLES_PER_SYMBOL : integer :=8);
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           --i_En : in  STD_LOGIC;
           iv12_IData : in  STD_LOGIC_VECTOR(11 downto 0);
           iv12_QData : in  STD_LOGIC_VECTOR(11 downto 0);
           o_IChip : out  STD_LOGIC;
           o_QChip : out  STD_LOGIC);
end component early_late_gate_algorithm;

signal s_IChip, s_QChip : std_logic;

component decoder is
    Port ( i_Rst : in  STD_LOGIC;
           i_Clk : in  STD_LOGIC;
           i_En : in  STD_LOGIC;
           i_IChip : in  STD_LOGIC;
           i_QChip : in  STD_LOGIC;
           ov4_Symbol : out  STD_LOGIC_VECTOR (3 downto 0));
end component decoder;

begin

rxfilter_i_inst : rxfilter
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  iv12_Data => iv12_IData,
				  ov12_Data => sv12_IData_filter);
			  
rxfilter_q_inst : rxfilter
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  iv12_Data => iv12_QData,
				  ov12_Data => sv12_QData_filter);		

carrier_phase_recovery_inst : carrier_phase_recovery
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  iv12_IData => sv12_IData_filter,
				  iv12_QData => sv12_QData_filter,
				  iv16_Phase => x"0000",
				  iv18_kp => "00" & x"0001",
				  iv18_ka => "00" & x"0001",			  
				  ov12_IData => sv12_IData_cfo,
				  ov12_QData => sv12_QData_cfo);			

early_late_gate_algorithm_inst : early_late_gate_algorithm
	 Generic map(NUMBER_SAMPLES_PER_SYMBOL => 8)
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  --i_En => i_En,
				  iv12_IData => sv12_IData_cfo,
				  iv12_QData => sv12_QData_cfo,
				  o_IChip => s_IChip,
				  o_QChip => s_QChip);	

decoder_inst : decoder
    Port map( i_Rst => i_Rst,
				  i_Clk => i_Clk,
				  i_En => i_En,
				  i_IChip => s_IChip,
				  i_QChip => s_QChip,
				  ov4_Symbol => ov4_Symbol);			  


end structural;