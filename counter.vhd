-------------------------------------------------------------------------------
--
-- Title       : Counter
-- Design      : Counter
-- Author      : Iacopo
-- Company     : Electronics_Projects
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Iacopo\Desktop\progetti Electronics\Counter\Counter\src\Counter.vhd
-- Generated   : Fri Nov 15 17:10:31 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Counter} architecture {Counter_beh}}

library IEEE;
use IEEE.std_logic_1164.all;

entity Counter is 
	generic (N_BIT : integer);	 
	 port(
		 count_clk 		: in 	STD_LOGIC;
		 count_reset 	: in 	STD_LOGIC;		 	 
		 D_in 			: in 	STD_LOGIC_VECTOR(N_BIT-1 downto 0);
		 D_out 			: out 	STD_LOGIC_VECTOR(N_BIT-1 downto 0)
	     );
end Counter;
	 
architecture Counter_beh of Counter is
	 signal	s_RPCA  :	  std_logic_vector(N_BIT-1 downto 0);
	 signal retro_add :	  std_logic_vector(N_BIT-1 downto 0);
	 signal cout_RPCA	  :	  std_logic;
	 component RPCA is
		generic(Nbit : integer);
		port(
			a	: in  std_logic_vector(Nbit-1 downto 0);
			b	: in  std_logic_vector(Nbit-1 downto 0);
			cin	: in  std_logic;
			s	: out std_logic_vector(Nbit-1 downto 0);
			cout: out std_logic
		);
	 end component;
	 
	 component DFF is
		generic(N_bit : integer); 
		port (
				clk: in std_logic;
				reset: in std_logic;
				D: in std_logic_vector(N_bit-1 downto 0);
				Q: out std_logic_vector(N_bit-1 downto 0) 
			 );
	 end component;
	 
begin
	rpca1	: RPCA
	generic map(Nbit => N_BIT)
	port map(D_in,retro_add,'0',s_RPCA,cout_RPCA);	
	
	dff1	: DFF
	generic map(N_bit => N_BIT)
	port map(count_clk,count_reset,s_RPCA,retro_add);
	counting_proc: process(retro_add)
	begin
		D_out<=retro_add;
	end process;
end Counter_beh;
