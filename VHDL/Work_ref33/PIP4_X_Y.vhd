----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:56:26 09/16/2022 
-- Design Name: 
-- Module Name:    PIP4_X_Y - RTL 
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


entity PIP4_X_Y is
    Port ( r : in  STD_LOGIC_VECTOR (N-1 downto 0);
           r2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           F1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           F2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           clk,rst : in  STD_LOGIC;
           X,Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PIP4_X_Y;

architecture RTL of PIP4_X_Y is
signal t_rr,t_Y :std_logic_vector(2*N-1 downto 0);
signal t_rr2,t_YR,t_rr2r,t_YRr,t_X :std_logic_vector(N-1 downto 0);

begin
U_MultipKerR: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
						X1 =>r ,--s1.14
						X2 => r2,--s1.14
						F => t_rr	);--s2.29
t_rr2<=t_rr(2*N-1) & t_rr(2*N-3 downto N-1);---int 2 bit

D_MultipKerY: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
						X1 =>F1 ,--s1.14
						X2 =>F2,---s1.14
						F => t_Y	);	--s2.29=32

t_YR<=t_Y(2*N-1) & t_Y(2*N-3 downto N-1);

U_RegRR: Reg Generic Map(N=>N) PORT MAP(
		d => t_rr2,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_rr2r
	);
U_RegY1: Reg Generic Map(N=>N) PORT MAP(
		d => t_YR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_YRr
	);
U_RegY2: Reg Generic Map(N=>N) PORT MAP(
		d => t_YRr,
		rst => rst,
		CE => '1',
		clk => clk,
		q => Y
	);
---------------------
U_Incx2: Incx  generic map (Nx =>2) Port MAP(  -- performance parameterPORT MAP(

		a => t_rr2r(N-1 downto N-2),
		H => t_X(N-1 downto N-2));	
		
		
t_X(N-3 downto 0)<=	t_rr2r(N-3 downto 0);

U_RegX: Reg Generic Map(N=>N) PORT MAP(
		d => t_X,
		rst => rst,
		CE => '1',
		clk => clk,
		q => X
	);



end RTL;

