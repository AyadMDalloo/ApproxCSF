----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:30:37 09/16/2022 
-- Design Name: 
-- Module Name:    PIP2_r_m_j - RTL 
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


entity PIP2_r_m_j is
generic(N:integer:=16);
    Port ( z  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           zn : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Ni : in  STD_LOGIC_VECTOR (2*Nint downto 0);
           Ji : in  STD_LOGIC_VECTOR (2*Nint downto 0);
           clk,rst : in  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (N-1 downto 0);
           m : out  STD_LOGIC_VECTOR (2*Nint downto 0);
           j : out  STD_LOGIC_VECTOR (4 downto 0));
end PIP2_r_m_j;

architecture RTL of PIP2_r_m_j is
signal t_r,t_Ri :std_logic_vector(N-1 downto 0);
signal t_m :std_logic_vector(2*Nint downto 0);
begin

U_Sub_ker: Sub_ker Generic Map( N_Sub=>N) PORT MAP(
		A => z,
		B => zn,
		S =>t_Ri);

t_r<=t_Ri(N-1) & t_Ri(N-Nint-1 downto 0) & "00000"; ---integer 2 bitend RTL;


D_Sub_ker: Sub_ker Generic Map( N_Sub=>2*Nint+1) PORT MAP(
		A => Ni,-----R
		B => Ji ,
		S =>t_m
	);	


U1_RegZn: Reg Generic Map(N=>N) PORT MAP(
		d => t_r,
		rst => rst,
		CE => '1',
		clk => clk,
		q => r
	);	
U2_RegZ: Reg Generic Map(N=>5) PORT MAP(
		d => Ji(4 downto 0),
		rst => rst,
		CE => '1',
		clk => clk,
		q => j
	);	
U3_RegN: Reg Generic Map(N=>2*Nint+1) PORT MAP(
		d => t_m,
		rst => rst,
		CE => '1',
		clk => clk,
		q => m
	);	
	
end RTL;
