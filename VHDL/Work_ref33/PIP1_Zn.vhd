----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:03:57 09/16/2022 
-- Design Name: 
-- Module Name:    PIP1_Zn - RTL 
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
use IEEE.Math_real.all;
use work.Pkg_Exp.all;


entity PIP1_Zn is
Generic (N:integer:=16);
    Port ( zi : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Ni : in  STD_LOGIC_VECTOR (2*Nint downto 0);
           clk,rst : in  STD_LOGIC;
           Zn : out  STD_LOGIC_VECTOR (N-1 downto 0);
           J  : out  STD_LOGIC_VECTOR (2*Nint downto 0);
           No : out  STD_LOGIC_VECTOR (2*Nint downto 0);
           zo : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PIP1_Zn;

architecture RTL of PIP1_Zn is
constant Ro : std_Logic_vector(N-1 downto 0) :=frac2bin(log(2.0)/32.0,N,1);
signal t_Zn:std_logic_vector(2*N-1 downto 0);
signal t_Znr:std_logic_vector(N-1 downto 0);
signal t_Rem :std_logic_vector(2*Nint downto 0);
begin

U_MultiDiffSz: MultiDiffSz Generic Map (N1=>N1, N2=>N2) PORT MAP(
						X1 =>Ni ,---12 bit integer+ 1 sign
						X2 => Ro,--- 1 bit integer +1 sign+14 fraction
						F => t_Zn(N1+N2-1 downto 0)	); --13 integer+15+1 sign=29 bit
						
t_Zn(2*N-1  downto N1+N2)<=(others=>t_Zn(N1+N2-1));----  31--->29 
t_Znr<=t_Zn(2*N-1) & t_Zn(N+4 downto 6);-----1 sign+ 6 integer+9 fractions

t_Rem(4 downto 0)<=Ni(4 downto 0);t_Rem(2*Nint downto 5)<=(others=>'0');---t_Rem =0000000J

U1_RegZn: Reg Generic Map(N=>N) PORT MAP(
		d => t_Znr,
		rst => rst,
		CE => '1',
		clk => clk,
		q => Zn
	);	
U2_RegZ: Reg Generic Map(N=>N) PORT MAP(
		d => zi,
		rst => rst,
		CE => '1',
		clk => clk,
		q => zo
	);	
U3_RegN: Reg Generic Map(N=>2*Nint+1) PORT MAP(
		d => Ni,
		rst => rst,
		CE => '1',
		clk => clk,
		q => No
	);	
U4_RegJ: Reg Generic Map(N=>2*Nint+1) PORT MAP(
		d => t_Rem,
		rst => rst,
		CE => '1',
		clk => clk,
		q => J
	);	

end RTL;

