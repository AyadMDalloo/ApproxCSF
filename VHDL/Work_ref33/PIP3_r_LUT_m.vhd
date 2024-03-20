----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:53 09/16/2022 
-- Design Name: 
-- Module Name:    PIP3_r_LUT_m - RTL 
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


entity PIP3_r_LUT_m is
    Port ( r : in  STD_LOGIC_VECTOR (N-1 downto 0);
           mi : in  STD_LOGIC_VECTOR (2*Nint downto 0);
           j : in  STD_LOGIC_VECTOR (4 downto 0);
           clk,rst : in  STD_LOGIC;
           ro : out  STD_LOGIC_VECTOR (N-1 downto 0);
           r2 : out  STD_LOGIC_VECTOR (N-1 downto 0);
           F1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
           F2 : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PIP3_r_LUT_m;

architecture RTL of PIP3_r_LUT_m is

constant LUT : memory:=Gen_LUT(mem);
signal t_rs, t_rsp,t_F1,t_F2 :std_logic_vector(N-1 downto 0);
signal t_m : std_logic_vector(M-1 downto 0);

begin
t_rs<=r(N-1) & r(N-1 downto 1);---------1 sign+2 int+9 frac
U_Incx: Incx  generic map (Nx =>2) Port MAP(  -- performance parameterPORT MAP(

		a => t_rs(N-1 downto N-2),
		H => t_rsp(N-1 downto N-2));
		
		
		
		
t_rsp(N-3 downto 0)<=t_rs(N-3 downto 0);

----------------
t_F2<=LUT(to_integer(unsigned(j)));
t_m<=mi(M+4 downto 5);

D_Demux: DeMux Generic Map( N=>N,M=>M) PORT MAP(
		sel => t_m,-----R
		F =>t_F1	);	


U_Regr: Reg Generic Map(N=>N) PORT MAP(
		d => r,
		rst => rst,
		CE => '1',
		clk => clk,
		q => ro
	);		
U_Regr2: Reg Generic Map(N=>N) PORT MAP(
		d => t_rsp,
		rst => rst,
		CE => '1',
		clk => clk,
		q => r2
	);		

		
U_RegF1: Reg Generic Map(N=>N) PORT MAP(
		d => t_F1,
		rst => rst,
		CE => '1',
		clk => clk,
		q => F1
	);		
U_RegF2: Reg Generic Map(N=>N) PORT MAP(
		d => t_F2,
		rst => rst,
		CE => '1',
		clk => clk,
		q => F2
	);		
		
		
end RTL;

