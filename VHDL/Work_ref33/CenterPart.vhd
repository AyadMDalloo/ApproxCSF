----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:23 09/16/2022 
-- Design Name: 
-- Module Name:    CenterPart - RTL 
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


entity CenterPart is
Generic (N:integer:=16);
    Port ( zi : in  STD_LOGIC_VECTOR (N-1 downto 0);
           clk,rst : in  STD_LOGIC;
           zo : out  STD_LOGIC_VECTOR (N-1 downto 0);
           No : out  STD_LOGIC_VECTOR (2*Nint downto 0));
end CenterPart;

architecture RTL of CenterPart is
constant Ri : STD_LOGIC_VECTOR(N-1 downto 0) :=frac2bin(32.0/log(2.0),N,Nint);
signal t_Fx : std_logic_vector(2*N-1 downto 0);
signal t_N   : std_logic_vector(2*Nint downto 0);
signal t_zr: std_logic_vector(N-1 downto 0);
begin
U_Regz: Reg Generic Map(N=>N) PORT MAP(
		d => zi,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_zr
	);
U_MultipKer1: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
						X1 =>t_zr ,--s6.9
						X2 => Ri,---s6.9
						F => t_Fx	);
						
t_N<=t_Fx(2*N-1 downto 2*N-N1);----integer s12.0 (2*Nint+1)

U_RegN: Reg Generic Map(N=>2*Nint+1) PORT MAP(
		d => t_N,
		rst => rst,
		CE => '1',
		clk => clk,
		q => No
	);




U_RegZr1: Reg Generic Map(N=>N) PORT MAP(
		d => t_zr,
		rst => rst,
		CE => '1',
		clk => clk,
		q => zo
	);	

	
end RTL;

