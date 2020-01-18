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
	warning: out std_logic  -- error signal	

);
end SecureSequenceRec;

architecture SSR_beh of SecureSequenceRec is
	SUBTYPE STATE_TYPE_COUNT is STD_LOGIC_VECTOR (1 DOWNTO 0) ;
	CONSTANT SMEM: STATE_TYPE_COUNT  :="00"; -- when in this state the counter just keep the exit constant
	CONSTANT SINC: STATE_TYPE_COUNT  :="01"; -- when in this state the counter increment the exit
	CONSTANT SRES: STATE_TYPE_COUNT  :="11"; -- when in this state the counter reset the exit
	

	SUBTYPE STATE_TYPE is STD_LOGIC_VECTOR (3 DOWNTO 0) ;
	-- constants to drive the state
	CONSTANT SINIT: STATE_TYPE:="0000";
	CONSTANT S0: STATE_TYPE:="0001";
	CONSTANT S1: STATE_TYPE:="0010";
	CONSTANT S2: STATE_TYPE:="0011";
	CONSTANT S3: STATE_TYPE:="0100";
	CONSTANT S4: STATE_TYPE:="0101";
	CONSTANT S5: STATE_TYPE:="0110";
	CONSTANT SBLOCK: STATE_TYPE:="0111";
	

	signal signal_star_in  : STATE_TYPE;
	signal signal_star_out : STATE_TYPE;

	signal lut_in  : std_logic_vector(2 downto 0);
	signal lut_out : std_logic_vector(7 downto 0);

	signal signal_ok_in  : std_logic_vector(0 downto 0);
	signal signal_ok_out : std_logic_vector(0 downto 0);-- 0 when a wrong number is inserted

	signal count_wr_in  : STATE_TYPE_COUNT; -- count the wrong sequences
	signal count_wr_out : std_logic_vector(2 downto 0);

	signal counter_state_in : STATE_TYPE_COUNT;

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
	
		port(
			address : in STD_LOGIC_VECTOR(2 downto 0);
			data : out STD_LOGIC_VECTOR(7 downto 0)
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

	SEQNUMBER: counter_mod --Drives the lut
	generic map(N_bitc => 3)
	port map(clock,reset,counter_state_in,lut_in);

	OK: DFF --1 if the seq number is correct,0 otherwise
	generic map(N_bit => 1)
	port map(clock,reset,signal_ok_in,signal_ok_out);

	STAR: DFF --status register
	generic map(N_bit => 4)
	port map(clock,reset,signal_star_in,signal_star_out);
	
	COUNT_WRONG: counter_mod --Keeps track of the wrong sequences
	generic map(N_bitc =>3 )
	port map(clock,reset,count_wr_in,count_wr_out);
	
	lut_seq : LUT --contains the sequence numbers
	port map(lut_in,lut_out);
	

	LOGIC:process(signal_star_out,reset,first)
	begin
		if(reset='0') then
			signal_star_in<=SINIT;
			unlock<='0';
			warning<='0';
			signal_ok_in<="0";
			counter_state_in<=SRES;
			count_wr_in<=SRES;
		else
			case(signal_star_out) is   
				when SINIT=>
					unlock<='0';
					warning<='0';
					if(first='1' ) then
						signal_star_in<=S0;	
						counter_state_in<=SINC;	--start counting				
					else
						signal_star_in<=SINIT;
						counter_state_in<=SMEM;
					end if;
					signal_ok_in<="0";
					count_wr_in<=SMEM;
		   		when S0 =>
					count_wr_in<=SMEM;
					unlock<='0';
					warning<='0';
					if(count_wr_out="101") then
						signal_star_in<=S1;
					else
						signal_star_in<=S1;
					end if;
					counter_state_in<= SINC; 
					if(num_in = lut_out ) then --Checking Sequence number 0
						signal_ok_in<="1";
					else
						signal_ok_in<=signal_ok_in;
					end if;
					
				when S1 =>
					unlock<='0';
					warning<='0'; 
					count_wr_in<=SMEM;
					if(first='1')then
						signal_ok_in<="0";
						signal_star_in<=SBLOCK;
					else	
						if(num_in = lut_out)then --Checking Sequence number 1
							signal_ok_in<=signal_ok_in;
						else
							signal_ok_in<="0";
						end if;

						signal_star_in<=S2;
						counter_state_in<= SINC;
						
					end if;
					
				when S2=>
					unlock<='0';
					warning<='0'; 
					count_wr_in<=SMEM;
					if(first='1')then
						signal_ok_in<="0";
						signal_star_in<=SBLOCK;
					else	
						if(num_in = lut_out)then --Checking Sequence number 2
							signal_ok_in<=signal_ok_in;
						else
							signal_ok_in<="0";
						end if;

						signal_star_in<=S3;
						counter_state_in<= SINC;
						
					end if;
				when S3=>
					unlock<='0';
					warning<='0'; 
					count_wr_in<=SMEM;
					if(first='1')then
						signal_ok_in<="0";
						signal_star_in<=SBLOCK;
					else	
						if(num_in = lut_out)then --Checking Sequence number 3
							signal_ok_in<=signal_ok_in;
						else
							signal_ok_in<="0";
						end if;

						signal_star_in<=S4;
						counter_state_in<= SMEM;
						
					end if;	
				when S4=>
					unlock<='0';
					warning<='0'; 
					count_wr_in<=SMEM;
					if(first='1')then
						signal_ok_in<="0";
						signal_star_in<=SBLOCK;
					else	
						if(num_in = lut_out)then --Checking Sequence number 4
							signal_ok_in<=signal_ok_in;
						else
							signal_ok_in<="0";
						end if;

						signal_star_in<=S5;
						counter_state_in<= SRES;
						
					end if;	
				when S5 =>
					unlock<= signal_ok_out(0);
					warning <= not signal_ok_out(0);
					if(signal_ok_out(0)='1') then
						count_wr_in<=SMEM;
					else
						count_wr_in<=SINC;
					end if;
					counter_state_in<= SRES;
					signal_star_in<=S0;
					
				when SBLOCK=>
					unlock<='0';
					warning<='1';
					signal_star_in<=SBLOCK;
					counter_state_in<= SRES;
					count_wr_in<=SRES;
				when others => null; -- Specifying that nothing happens in the other cases 
		  	end case;
		end if;
	end process;

end SSR_beh;