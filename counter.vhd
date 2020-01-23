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

entity Counter_mod is
	generic(N_bitc : integer);  
	 port(
		 count_clk 	: in 	STD_LOGIC;
		 count_reset 	: in 	STD_LOGIC;		 	 
		 enabler_in	: in 	STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		 D_out 		: out 	STD_LOGIC_VECTOR(N_bitc-1 downto 0)
	     );
end Counter_mod;
	 
architecture Counter_beh of Counter_mod is

	 SUBTYPE STATE_TYPE is STD_LOGIC_VECTOR (1 DOWNTO 0) ;
	 CONSTANT SMEM: STATE_TYPE  :="00"; -- when in this state the counter just keep the exit constant
	 CONSTANT SINC: STATE_TYPE  :="01"; -- when in this state the counter increment the exit
	 CONSTANT SRES: STATE_TYPE  :="11"; -- when in this state the counter reset the exit

	 signal	s_RPCA	  :std_logic_vector(N_bitc-1 downto 0);
	 signal retro_add :std_logic_vector(N_bitc-1 downto 0);
	 signal dff_in	  :std_logic_vector(N_bitc-1 downto 0);
	 signal add_in	  :std_logic_vector(N_bitc-1 downto 0);

	 signal cout_RPCA :std_logic;
	 component RPCA is
		generic(Nbit : integer);
		port(
			a	: in  std_logic_vector(Nbit-1 downto 0);
			b	: in  std_logic_vector(Nbit-1 downto 0);
			cin	: in  std_logic;
			s	: out std_logic_vector(Nbit-1 downto 0);
			cout	: out std_logic
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
	generic map(Nbit => N_bitc)
	port map(add_in,retro_add,'0',s_RPCA,cout_RPCA);	
	
	dff1	: DFF
	generic map(N_bit => N_bitc)
	port map(count_clk,count_reset,dff_in,retro_add);
	counting_proc: process(enabler_in,s_RPCA)
	begin
		add_in<= (N_bitc-1 downto 1 => '0',others =>'1');
		if(count_reset='0') then
			dff_in<= (others => '0');
		else
			case(enabler_in) is
			when SMEM=>
				dff_in<=retro_add;				
			when SINC=>
				dff_in<=s_RPCA;	
			when SRES=>
				dff_in <= (others => '0');
			when others => null;		
			end case;
		end if;
		D_out<=retro_add;
	end process;
end Counter_beh;
