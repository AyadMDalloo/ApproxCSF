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
	        clk,rst,c_sinh : in std_logic;
--			  Nr : out std_logic_vector(N-6 downto 0);
--			  Zn : out std_logic_vector(N+4 downto 0);
--			  Err: out std_logic_vector(N-1 downto 0);
--			  F1,F2: out std_logic_vector(N-1 downto 0);
--			  J:  out std_logic_vector(5 downto 0);
--			  X:  out std_logic_vector(N-1 downto 0);
--			  Y : out std_logic_vector(N+9 downto 0);
           cosh_sinh: out Std_logic_vector(3*N-1 downto 0));
			  
			 
end exp_pz;

architecture RTL of exp_pz is

constant Ri : STD_LOGIC_VECTOR(N-1 downto 0) :=frac2bin(32.0/log(2.0),N,Nint);
constant Ro : std_Logic_vector(N+1 downto 0) :=frac2bin(log(2.0)/32.0,N2,1);
constant C1 : real:=1.021897148654117;
constant C2 : real:=0.9785720620877;
constant LUTN : memory:=Gen_LUT(mem,C2);
constant LUTP : memory:=Gen_LUT(mem,C1);
signal t_Fx  : std_logic_vector(2*N-1 downto 0);
signal t_N,t_Nr : std_logic_vector(N-6 downto 0);

-----------------------------------------
signal t_Co,Tone1,Tone,Tone2 : std_logic;
signal t_Zn :std_logic_vector(2*N-4 downto 0);



signal t_Zr,t_Zn16,t_Zn16r,t_za : std_logic_vector(N+Nint-2 downto 0);
signal t_YNR,t_YNRr: std_logic_vector(N+2 downto 0);
signal t_YPR,t_YPRr: std_logic_vector(N+6 downto 0);
signal t_YN,t_YP: std_logic_vector( 2*N-1 downto 0);
--signal t_YR,t_YRr : std_logic_vector(N+Nint downto 0);
-----downto
signal t_XN,t_XNr,t_XP,t_XPr: std_logic_vector(N-1 downto 0);
signal t_mP,t_mN :std_logic_vector(M-1 downto 0);
signal t_F2N,t_F1Nr,t_F2Nr,t_F2P,t_F1Pr,t_F2Pr,t_one,t_err:std_logic_vector(N-1 downto 0);
signal  t_F1N,t_F1iN,t_F1P,t_F1iP:std_logic_vector(N-1 downto 0);
signal t_JN,t_JP: std_logic_vector(4 downto 0);

signal t_z,t_z1,t_z2: std_logic_vector(N-1 downto 0);
signal t_expN:std_logic_vector(2*N+2  downto 0);
signal tr_expN,t_expNr:std_logic_vector(2*N-1  downto 0);

signal t_expP,tr_expP,t_expPr:std_logic_vector(2*N+6  downto 0);
signal t_cosh_sinhr,t_cosh_sinh,tc_expNr,tc_expPr :std_logic_vector(3*N-1 downto 0);
begin

U_Reg3: Reg1 PORT MAP(
		d =>'1'  ,
		clk => clk,
		rst => rst,
		q => Tone1
	);	
U_Reg4: Reg1 PORT MAP(
		d =>Tone1  ,
		clk => clk,
		rst => rst,
		q => Tone2 
	);	
	U_Reg5: Reg1 PORT MAP(
		d =>Tone2  ,
		clk => clk,
		rst => rst,
		q => Tone 
	);	
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
--Nr<=t_Nr;---------------------------------------------------------------------------------------
--------------------------------------------------
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
	
	
--Zn<=t_Zn16r;---------------------------------------------------------	
t_za<=t_z & "00000";	
U_Sub_ker: Sub_ker Generic Map( N_Sub=>N+Nint-1) PORT MAP(
																		A => t_za,
																		B => t_Zn16r,
																		S =>t_Zr	);----t_X =21 bit (s4.16)

															
---------fraction of t_X s1.8	
t_one<=(N-2=>Tone,others=>'0');
t_err<=t_Zr(N+Nint-2) & t_Zr(get_Hlvl(N+Nint-1,Nint-2,1) downto get_Llvl(N+Nint-1,N,N-2));
--Err<=t_err;--------------------------------------------------------------------------------------------



--------------------------------------------------------------
------------------------exp(-z)--------------------------------
-----------------------------------------------------------------
UN_AddSub: AddSub Generic Map(Na=>N)PORT MAP(
		A => t_one,
		B => t_err,
		Control =>Tone  ,
		F =>t_XN	);----just fraction of t_Zr s1.14


P4aN_RegXR: Reg Generic Map(N=>N) PORT MAP(
		d => t_XN,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_XNr
	);

--X<=t_Xr;	-------------------------------------------------------------------


----------down
t_JN<=t_Nr(4 downto 0);
t_F2N<=LUTN(to_integer(unsigned(t_JN)));  ----s1.14
--J<=t_J;--------------------------------------------------------------
-----------------------------------------------------------------
t_mN<= not t_Nr(M+4 downto 5);

DN_Demux: DeMux Generic Map( N=>N,M=>M) PORT MAP(
		sel => t_mN,-----R
		F =>t_F1N	);	
	------------------------------------------------------------------------
t_F1iN<='0' & t_F1N(N-1 downto 1) ;--- s1.14

P3bN_RegF1: Reg Generic Map(N=>N) PORT MAP(
		d => t_F1iN,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F1Nr
	);
P3cN_RegF2: Reg Generic Map(N=>N) PORT MAP(
		d => t_F2N,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F2Nr
	);
--F1<=t_F1r;
--F2<=t_F2r;

YN_MultiF1F2: MultiDiffSz  Generic Map (N1=>N, N2=>N) PORT MAP(
						X1 =>t_F1Nr ,---s15.0 or s1.14
						X2 =>t_F2Nr,----s1.14
						F => t_YN	);	---s16.15 or s2.29

t_YNR<=t_YN(2*N-1) &  t_YN(get_Hlvl(2*N,2,1) downto get_Llvl(2*N,2*N-3,N+1));    --s1.17 =19                    ---       t_Y(2*N-2 downto N-Nint-1);

P4bN_RegYR: Reg Generic Map(N=>N+3) PORT MAP(
		d => t_YNR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_YNRr
	);
--Y<=t_YRr;---------------------------------------------------------------------------------------------

DN_MultiDiffSzC: MultiDiffSz Generic Map (N1=>N+3, N2=>N) PORT MAP(
						X1 =>t_YNRr ,-- s1.17=19
						X2 =>t_XNr, ---s1.14=16
						F => t_expN	);		---s2.32=19+16=35
						
tr_expN<=t_expN(2*N+2) & t_expN(get_Hlvl(2*N+3,2,1) downto get_Llvl(2*N+3,2*N,2*N-2)); --s1.30
P5N_Regexp: Reg Generic Map(N=>2*N) PORT MAP(
		d => tr_expN,--s1.30,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_expNr	);	


----------------------------------exp(z)
UP_AddSub: AddSub Generic Map(Na=>N)PORT MAP(
		A => t_one,
		B => t_err,
		Control =>'0'  ,
		F =>t_XP	);----just fraction of t_Zr s1.14


P4aP_RegXR: Reg Generic Map(N=>N) PORT MAP(
		d => t_XP,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_XPr
	);
t_JP<=t_Nr(4 downto 0);
t_F2P<=LUTP(to_integer(unsigned(t_JP)));  ----s1.14
--J<=t_J;--------------------------------------------------------------
-----------------------------------------------------------------
t_mP<= t_Nr(M+4 downto 5);

DP_Demux: DeMux Generic Map( N=>N,M=>M) PORT MAP(
		sel => t_mP,-----R
		F =>t_F1P	);	
	------------------------------------------------------------------------
t_F1iP<= t_F1P(N-1 downto 0) ;---s15.0 

P3bP_RegF1: Reg Generic Map(N=>N) PORT MAP(
		d => t_F1iP,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F1Pr
	);
P3cP_RegF2: Reg Generic Map(N=>N) PORT MAP(
		d => t_F2P,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_F2Pr
	);
	
YP_MultiF1F2: MultiDiffSz  Generic Map (N1=>N, N2=>N) PORT MAP(
						X1 =>t_F1Pr ,---s15.0 or s1.14
						X2 =>t_F2Pr,----s1.14
						F => t_YP	);	---s16.15 or s2.29

t_YPR<=t_YP(2*N-1) &  t_YP(get_Hlvl(2*N,N,N) downto get_Llvl(2*N,N-1,6));    --s16.6 =23                   ---       t_Y(2*N-2 downto N-Nint-1);

P4bP_RegYR: Reg Generic Map(N=>N+7) PORT MAP(
		d => t_YPR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_YPRr
	);	
	
DP_MultiDiffSzC: MultiDiffSz Generic Map (N1=>N+7, N2=>N) PORT MAP(
						X1 =>t_YPRr ,---s16.6 
						X2 =>t_XPr, ---s1.14
						F => t_expP	);		---s17.21	 ==17+22=39
						
--tr_expP<= t_expP(2*N+6) & t_expP(get_Hlvl(2*N+7,N+1,N+1) downto get_Llvl(2*N+3,N+5,N-2));--s17.14


P5P_Regexp: Reg Generic Map(N=>2*N+7) PORT MAP(
		d => t_expP,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_expPr);	
tc_expNr(3*N-1 downto 2*N)<=(others=>t_expNr(2*N-1));
tc_expNr(2*N-1 downto 0)<=t_expNr;		
tc_expPr(3*N-1 downto N-7)<=t_expPr;
tc_expPr(N-8 downto 0)<=(others=>'0');


UC_AddSub: AddSub Generic Map(Na=>3*N)PORT MAP(
		A => tc_expPr,--s17.14--->s17.30===48bit
		B => tc_expNr,--s1.30--->s17.30 
		Control =>c_sinh, 
		F =>t_cosh_sinh );
t_cosh_sinhr<='0' & t_cosh_sinh(3*N-1 downto 1);
P5Cosh_Regexp: Reg Generic Map(N=>3*N) PORT MAP(
		d => t_cosh_sinhr,
		rst => rst,
		CE => '1',
		clk => clk,
		q => cosh_sinh);		
		

end RTL;


