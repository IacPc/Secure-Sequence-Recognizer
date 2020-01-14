library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SecureSequenceRec is
port (
	clock:	in std_logic; --- clock signal	
	reset:	in std_logic; -- reset signal active low
	first:	in std_logic; -- start sampling signal
	num_in:	in std_logic_vector(7 downto 0); --input sequence number
	
	unlock:	 out std_logic; -- signal of success
	warning: out std_logic -- error signal	

);
end SecureSequenceRec;

architecture SSR_beh of SecureSequenceRec is

	SUBTYPE STATE_TYPE is STD_LOGIC_VECTOR (2 DOWNTO 0) ;
	-- constants to drive the state
	CONSTANT S0: STATE_TYPE:="000";
	CONSTANT S1: STATE_TYPE:="001";
	CONSTANT S2: STATE_TYPE:="010";
	CONSTANT S3: STATE_TYPE:="011";
	CONSTANT S4: STATE_TYPE:="100";

	signal signal_star_in : std_logic_vector(2 downto 0); --current
	signal signal_star_out : std_logic_vector (2 downto 0);

	signal lut_in  : std_logic_vector(2 downto 0);
	signal lut_out : std_logic_vector(7 downto 0);

	signal signal_ok_in  : std_logic_vector(0 downto 0);
	signal signal_ok_out : std_logic_vector(0 downto 0);-- 0 when a wrong number is inserted

	signal count_wr_in  : std_logic_vector(1 downto 0); -- count the wrong sequences
	signal count_wr_out : std_logic_vector(1 downto 0);

	signal counter_state_in : std_logic_vector(1 downto 0);

	

	component DFF is
		generic(N_bit : integer); 
		port (
			clk: in std_logic;
			reset: in std_logic;
			D: in std_logic_vector(N_bit-1 downto 0);
			Q: out std_logic_vector(N_bit-1 downto 0) 
		);
	end component;

	component LUT is  
		generic(
			N_ADD : integer;
			M_DATA : integer
		);
		port(
			address : in STD_LOGIC_VECTOR(N_ADD-1 downto 0);
			data : out STD_LOGIC_VECTOR(M_DATA-1 downto 0)
		);
	end component;
	component Counter_mod is
	generic(N_bitc : integer);  
	 port(
		 count_clk 	: in 	STD_LOGIC;
		 count_reset 	: in 	STD_LOGIC;		 	 
		 enabler_in	: in 	STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		 D_out 		: out 	STD_LOGIC_VECTOR(N_bitc-1 downto 0)
	     );

	end component;

	begin
	
	STAR: DFF --status register
	generic map(N_bit => 3)
	port map(clock,reset,signal_star_in,signal_star_out);

	OK: DFF --1 if the seq number is correct,0 otherwise
	generic map(N_bit => 1)
	port map(clock,reset,signal_ok_in,signal_ok_out);
	
	COUNT_WRONG: DFF --Keeps track of the wrong sequences
	generic map(N_bit => 1)
	port map(clock,reset,count_wr_in,count_wr_out);
	
	SEQNUMBER: counter_mod --Drives the lut
	generic map(N_bit => 3)
	port map(clock,reset,counter_state_in,lut_in);

	lut_seq : LUT --contains the sequence numbers
	generic map(N_ADD => 3, M_DATA => 8)
	port map(lut_in,lut_out);
	

	LOGIC:process(clock,reset)
	begin
		if(reset='0') then
			unlock<='0';
			warning<='0';
			signal_star_in<=S0;
			signal_ok_in<="0";
			count_wr_in<="00";
		elsif(rising_edge(clock)) then
			case(signal_star_out) is   
		   		when S0 =>
					unlock<='0';
					warning<='0';
					if(first='1' ) then
						signal_star_in<=S1;
					else
						signal_star_in<=S0;
					end if;
					if(num_in = lut_out) then
						signal_ok_in<="1";
					end if;
					counter_state_in<= "000"; --start counting
				when S1 =>
					unlock<='0';
					warning<='0';
					if(first='1' ) then
						warning<='1';
					end if;
		
					signal_ok_in<="1" when num_in = lut_out else "0";
										
					if(lut_in="101")
						signal_star_in<=S2;
					else
						signal_star_in<=signal_star_in;
					end if;
					counter_state_in<= "001";
				when S2 =>
					unlock<= signal_ok_out;
					warning <= not signal_ok_out;
					counter_state_in<= "111";
					signal_star_in<=S0;
				when others => null; -- Specifying that nothing happens in the other cases 
		  	end case;
		end if;
	end process;

end SSR_beh;