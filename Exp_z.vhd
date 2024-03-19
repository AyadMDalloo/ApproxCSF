----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:17 07/05/2022 
-- Design Name: 
-- Module Name:    Exp_z - RTL 
-- PROJECT INFORMATION
-- ==============================================================================
-- Designer: Ayad Dalloo
-- Project: PhD Research
-- University: University of Technology
-- Collaboration: Hill University and Brunel University London
-- Description: This code models the implementation of the exponential function
-- for negative inputs using an Approximate Composited-Stair Function approach.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.Math_real.all;
use work.Pkg_Exp.all;
------------------------------------
----procedure-----
--Step1
--t_z=z;
--t_Fx=t_z*C0;
--t_N=Int(t_Fx);t_Nr=Reg(t_N);
--T_zr=
--t_Zn=t_zr*C1;

entity Exp_z is
     Port ( z : in  STD_LOGIC_VECTOR (N-1 downto 0);
	         clk,rst :std_logic;
           exp : out  STD_LOGIC_VECTOR (2*N-1 downto 0));
end Exp_z;

architecture RTL of Exp_z is
---------------------------------------------------------------------------------------------------------
----Function frac2bin(real value, total length of  data in bits, length of Integer in bits), for example,
---- frac2bin(10.345,16,4)
----------------------------------------------------------------------------------------------------------
constant Ri : STD_LOGIC_VECTOR(N-1 downto 0) :=frac2bin(32.0/log(2.0),N,Nint);----Constant C0
constant Ro : std_Logic_vector(N+1 downto 0) :=frac2bin(log(2.0)/32.0,N2,1);  ----Constant C1
-------------------------------------------------------------------------------------------------------------
signal t_Fx  : std_logic_vector(2*N-1 downto 0);       ------t_Fx is the output of first Multiplier 
signal t_N,t_Nr  : std_logic_vector(2*Nint-2 downto 0);------t_N is only the integer of t_Fx and t_Nr is t_N after Register
----------------------------------------------------------------------------------------------------------------------
signal t_z,t_zr,t_zo: std_logic_vector(N-1 downto 0); ---- input after registering 
signal t_Zn :std_logic_vector(2*N-4 downto 0);        ---- output of the second mutiplier 
signal t_Znr,t_Znr1,t_Znr2 : std_logic_vector(N+Nint-2 downto 0);--- t_Zn after registering
------------------------------------------------------------------------------------------


signal t_X: std_logic_vector(N+Nint-2 downto 0);
signal t_Y : std_logic_vector(2*N-1 downto 0);
signal t_Co : std_logic;


signal t_XR,t_XRr : std_logic_vector(N+1 downto 0);
-----downto
signal t_YR,t_YRr : std_logic_vector(N2 downto 0);

-----downto

signal t_m :std_logic_vector(M-1 downto 0);
signal t_F1,t_F2,t_F1r,t_F2r:std_logic_vector(N-1 downto 0);
----------------------------REGs------

signal t_exp:std_logic_vector(2*N+4 downto 0);
signal t_expr :std_logic_vector(2*N-1 downto 0);

constant LUT : memory:=Gen_LUT(mem);
begin
-- Input z
U_Regz: Reg Generic Map(N=>N) PORT MAP(
		d => z,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_z
	);
--------------------------------------Mult1-------------------------------------------------------------------------
-- Fx=t_z*C0, where t_z: input and C0: constant
--------------------------------------------------------------------------------------------------------------------
U_MultipKer1: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
						X1 =>t_z ,---s4.11
						X2 => Ri,---s6.9
						F => t_Fx	);--s10.21
--------------------------------------------------------------------------------------------------------------------
------Integer of Z----------------------------------------	
--t_N=s+2*Nint-2=1+2*6-2=11 bits
t_N<=t_Fx(2*N-1) & t_Fx(get_Hlvl(2*N,2*Nint-2,2*Nint-2)downto get_Llvl(2*N,2*Nfrac+3,0));---s10.0


--------------------pipeline 1---------------------------
------pipeline registered input t_z and intger t_N
U_Part1: Part Generic Map(Nc=>N,Nd=>2*Nint-1)PORT MAP(
		zi => t_z,
		Ni => t_N,
		clk =>clk ,
		rst => rst,
		zo => t_zo,
		No =>t_Nr 
	);
----------------------------------------------Mult2----------------------------------------------------------------	
--- using multiplier of two values with different lengths of bits
--- t_Zn(29 bits)=t_Nr(11 bits)*Ro(18bits), Ro : constant C1
-------------------------------------------------------------------------------------------------------------------
U_MultiDiffSz: MultiDiffSz Generic Map (N1=>N-5, N2=>N2) PORT MAP(
						X1 =>t_Nr ,---s10.0=11
						X2 => Ro,--- s1.16=18
						F => t_Zn	); --11+18=29 bit---s11.17


---N1=13, N2=18 = 28 bits without sign bit
--- Sgin-bit(29), integer=4 bits (due to our range [-10.397,10.397]), fraction=16 bits
---t_Znr : approximate input z
t_Znr<=t_Zn(N1+N2-3) & t_Zn(get_Hlvl(N1+N2-2,2*Nint-1,4) downto get_Llvl(N1+N2-2,2*Nfrac-1,2*Nfrac-2));--s4.16=21
-----------------------PIP2---------------------------------------------------------------------------------------
---
U_Part2: Part Generic Map(Nc=>N,Nd=>N+Nint-1)PORT MAP(
		zi => t_zo,
		Ni => t_Znr,
		clk =>clk ,
		rst => rst,
		zo => t_zr,
		No =>t_Znr1 
	);
------------------------------------------------------------------------------------------------------------------------

----------------First part of circuit to Compute X-------------------------------------------------------------------
--------------------calculation r-----------------------------------------------------------------------------------
------------r(integer)=r (integer)+1
U_Incx: Incx  generic map (Nx =>Nint-1) Port MAP(  a =>t_Znr1(N+Nint-2 downto N) ,
		                                              H => t_Znr2(N+Nint-2 downto N)	);
-----extend r with fractions
t_Znr2(N-1 downto 0)<=t_Znr1(N-1 downto 0);		
---------------------------------------------------------------------------------------------------------------------
---------------------------------Sub---------------------------------------------------------------------------------
---- t_X=t_Znr2-t_zr-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
U_Sub_ker: Sub_ker Generic Map( N_Sub=>N) PORT MAP(  A =>  t_Znr2(N+Nint-2 downto Nint-1) ,
		                                               B =>t_zr,
		                                               S =>t_X(N+Nint-2 downto Nint-1) 	);---s4.16

t_X(Nint-2 downto 0)<=t_Znr2(Nint-2 downto 0);
---------------------------------------------------------------------------------------------------------------------
---------------t_XR(18 bit)=Sign bit t_X(1 bit,20) integer t_X(1 bit,16) fraction(16 bits,15 to 0)-------------------
t_XR<=t_X(N+Nint-2) & t_X(get_Hlvl(N+Nint-1,4,1) downto get_Llvl(N+Nint-1,N,N));---s1.16

 U_RegX: Reg Generic Map(N=>N2) PORT MAP(
		d => t_XR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_XRr	);---s1.16

--------------------------------------------------------------
----------Second part of circuit to Compute Y---------------------------------
---------Compute F1 and F2 	 
-----N/32= 5 bits  remainder and 4 bits  quotient
--------F2------------------------------------------
t_F2<=LUT(to_integer(unsigned(t_Nr(4 downto 0))));-----Lookup table
--------------------------------------------------------------------
-----M=log2(N)=4 and 4 bits  quotient
t_m<=t_Nr(M+4 downto 5);-----extract only 4 bits from 8 to 5 
------------F1-------------------------------
D_Demux: DeMux Generic Map( N=>N,M=>M) PORT MAP(
		sel => t_m,
		F =>t_F1	);	
	---------------------pip3----------------------------------------------
U_RegF1: Reg Generic Map(N=>N) PORT MAP(		d => t_F1,---s1.14
															rst => rst,
															CE => '1',
															clk => clk,
															q => t_F1r
														);
U_RegF2: Reg Generic Map(N=>N) PORT MAP(  	d => t_F2,---s1.14
															rst => rst,
															CE => '1',
															clk => clk,
															q => t_F2r
														);
-----------------------------------------------------------------------------
--------------Mult3----------------------------------------------------------
-----------Compute Y---------------------------------------------------------
D_MultipKer1: MultipKer Generic Map (N_Mulker=>N) PORT MAP(
						X1 =>t_F1r ,---s1.14
						X2 =>t_F2r,---s1.14
						F => t_Y	);	---s2.29
-------------- Y<2--------------------------------------------------------
t_YR<=t_Y(2*N-1) & t_Y(get_Hlvl(2*N,2,1) downto get_Llvl(2*N,2*N-3,17));---s1.17

U_RegYR: Reg Generic Map(N=>N2+1) PORT MAP(
		d => t_YR,
		rst => rst,
		CE => '1',
		clk => clk,
		q => t_YRr
	);
------------------Mult4---------------------------------------------------------
-----------------t_exp=t_Y*t_X--------------------------------------------------
D_MultipKerC: MultiDiffSz Generic Map (N1=>N2+1, N2=>N+2)  PORT MAP(
						X1 =>t_YRr ,--s1.17
						X2 =>t_XRr,---s1.16
						F => t_exp	);	--s2.34	
---------------------------------------------------------------------------------
------------Reduce the length od output------------------------------------------						
t_expr<=t_exp(2*N+4) & t_exp(2*N+2 downto 4);
P2_Regexp: Reg Generic Map(N=>2*N) PORT MAP(
		d => t_expr,
		rst => rst,
		CE => '1',
		clk => clk,
		q => exp
	);											
end RTL;

