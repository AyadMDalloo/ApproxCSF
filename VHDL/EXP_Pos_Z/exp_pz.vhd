----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:08:57 09/07/2022 
-- Design Name: 
-- Module Name:    exp_pz - RTL 
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




entity exp_pz is
    Port ( z : in  STD_LOGIC_VECTOR (N-1 downto 0);
	        clk,rst : std_logic;
           exp: out Std_logic_vector(2*N-1 downto 0));
			  
			 
end exp_pz;

architecture RTL of exp_pz is

constant Ri : STD_LOGIC_VECTOR(N-1 downto 0) :=frac2bin(32.0/log(2.0),N,Nint);
constant Ro : std_Logic_vector(N+1 downto 0) :=frac2bin(log(2.0)/32.0,N2,1);

signal t_Fx  : std_logic_vector(2*N-1 downto 0);
signal t_N,t_Nr : std_logic_vector(N-6 downto 0);

-----------------------------------------
signal t_Zn :std_logic_vector(2*N-4 downto 0);
signal t_X,t_Xr: std_logic_vector(N-1 downto 0);


signal t_Co : std_logic;
signal t_Zr,t_Zn16,t_Zn16r,t_za : std_logic_vector(N+Nint-2 downto 0);
signal t_Y: std_logic_vector(2*N-1 downto 0);
signal t_YR,t_YRr : std_logic_vector(N+Nint downto 0);
-----downto

signal t_m :std_logic_vector(M-1 downto 0);
signal t_F2,t_F1r,t_F2r:std_logic_vector(N-1 downto 0);
signal t_F1,t_F1i:std_logic_vector(N-1 downto 0);

constant LUT : memory:=Gen_LUTP(mem);
signal t_z,t_z1,t_z2: std_logic_vector(N-1 downto 0);
signal t_exp:std_logic_vector(2*N+Nint  downto 0);

begin
P1_Regz0: Reg Generic Map(N=>N) PORT MAP(
		d => z,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_z1
	);
---Multipy Ri=32/ln2(s6.9) by z(s4.11)----zlength=s6.9=16 bit

U_Multin: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
																			X1 =>t_z1 ,
																			X2 => Ri,
																			F => t_Fx	);
----To get integer of F (s12.19)						
t_N<=t_Fx(2*N-1) & t_Fx(get_Hlvl(2*N,2*Nint-2,2*Nint-2)downto get_Llvl(2*N,2*Nfrac+3,0));---s10.0

P2_RegN: Reg Generic Map(N=>N-5) PORT MAP(
		d => t_N,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_Nr
	);


-----calculate Zn
U_MultDSz: MultiDiffSz Generic Map (N1=>N-5, N2=>N2) PORT MAP(
																						X1 =>t_Nr,---12 bit integer+ 1 sign=13
																						X2 => Ro,--- 1 bit integer +1 sign+16 fraction=18
																						F => t_Zn	); --13+18=31 bit

 ----Convert Zn 31bit to 16 bit with s6.9
t_Zn16<=t_Zn(N1+N2- 3) & t_Zn(get_Hlvl(N1+N2-2,2*Nint-1,4) downto get_Llvl(N1+N2-2,2*Nfrac-1,2*Nfrac-2));--s4.16
P3a_RegZn: Reg Generic Map(N=>N+5) PORT MAP(
		d => t_Zn16,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_Zn16r
	);
P1_Regz1: Reg Generic Map(N=>N) PORT MAP(
		d => t_z1,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_z2
	);
P1_Regz2: Reg Generic Map(N=>N) PORT MAP(
		d => t_z2,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_z
	);	
t_za<=t_z & "00000";	
U_Sub_ker: Sub_ker Generic Map( N_Sub=>N+Nint-1) PORT MAP(
																		A => t_za,
																		B => t_Zn16r,
																		S =>t_Zr	);----t_X =21 bit (s4.16)

															
---------fraction of t_X s1.8	
t_X<= t_Zr(N+Nint-2) & '1' & t_Zr(get_Hlvl(N+Nint-1,Nint-2,0) downto 2);----just fraction of t_Zr s1.14

	-----t_X ==s1.8=10 bit

P4a_RegXR: Reg Generic Map(N=>N) PORT MAP(
		d => t_X,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_Xr
	);

	


----------down

t_F2<=LUT(to_integer(unsigned(t_Nr(4 downto 0))));  ----s1.14

t_m<= t_Nr(M+4 downto 5);

D_Demux: DeMux Generic Map( N=>N,M=>M) PORT MAP(
		sel => t_m,-----R
		F =>t_F1	);	
	
t_F1i<=t_F1(N-1 downto 0) ;---s15.0

P3b_RegF1: Reg Generic Map(N=>N) PORT MAP(
		d => t_F1i,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F1r
	);
P3c_RegF2: Reg Generic Map(N=>N) PORT MAP(
		d => t_F2,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F2r
	);



Y_MultiF1F2: MultiDiffSz  Generic Map (N1=>N, N2=>N) PORT MAP(
						X1 =>t_F1r ,---s15.0
						X2 =>t_F2r,----s1.14
						F => t_Y	);	

t_YR<=t_Y(2*N-1) &  t_Y(get_Hlvl(2*N,N,N) downto get_Llvl(2*N,N-1,6));    --s16.6                     ---       t_Y(2*N-2 downto N-Nint-1);

P4b_RegYR: Reg Generic Map(N=>N+Nint+1) PORT MAP(
		d => t_YR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_YRr
	);






D_MultiDiffSzC: MultiDiffSz Generic Map (N1=>N+Nint+1, N2=>N) PORT MAP(
						X1 =>t_YRr ,---s16.6
						X2 =>t_Xr, ---s1.14
						F => t_exp	);		---s17.21	==39		

P5_Regexp: Reg Generic Map(N=>2*N) PORT MAP(
		d => t_exp(2*N+Nint downto  get_Llvl(2*N+Nint+1,N+Nint-1,N-2)),--s17.14,
		rst => rst,
		CE => '1',
		clk => clk,
		q => exp	);							
end RTL;


