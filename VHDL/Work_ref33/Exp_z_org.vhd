----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:18 08/05/2022 
-- Design Name: 
-- Module Name:    Exp_z_org - RTL 
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
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Exp_z_org is
Generic (N:integer:=16);
    Port ( z   : in    STD_LOGIC_VECTOR (N-1 downto 0);
--	        Ni    : out   std_logic_vector(2*Nint downto 0);
--			  r    : out   std_logic_vector(N-1 downto 0);
--			  mo    : out   std_logic_vector(2*Nint downto 0);
--			  j    : out   std_logic_vector(4 downto 0);
--			  Zn ,F1,F2 ,r2 : out  std_logic_vector(N-1 downto 0);
--	        X,Y : out   STD_LOGIC_VECTOR (N-1 downto 0);
           QF  : out   STD_LOGIC_VECTOR (N-1 downto 0);
			  rfd :out std_logic;
			  clk,rst,ce : in  STD_LOGIC);
end Exp_z_org;

architecture RTL of Exp_z_org is

-----Center part
signal t_No,t_J  : std_logic_vector(2*Nint downto 0);
signal t_zo1: std_logic_vector(N-1 downto 0);
------------PIP_Zn_J
signal t_Zn: std_logic_vector(N-1 downto 0);
signal  t_No2  : std_logic_vector(2*Nint downto 0);
signal t_zo2: std_logic_vector(N-1 downto 0);
---------------------------------------------
----------PIP_M_J_r---------
signal t_r: std_logic_vector(N-1 downto 0);
signal t_m : std_logic_vector(2*Nint downto 0);
signal t_js :std_logic_vector(4 downto 0);
-------------------------------------------
-------------------------------------------
signal t_F1,t_F2,t_ro,t_r2:std_logic_vector(N-1 downto 0);

-------------------------------------------------
signal t_X,t_Y,t_QF :std_logic_vector(N-1 downto 0);
signal t_Q: STD_LOGIC_VECTOR (N-1 downto 0);
signal t_Fr: STD_LOGIC_VECTOR (N-1 downto 0); 

begin
--------------------------------------
U_CenterPart: CenterPart Generic Map(N=>N) PORT MAP(
		zi => z,
		clk => clk,
		rst => rst,
		zo => t_zo1,
		No => t_No
	);
	
--Ni<=t_No;
--------------------------
U_PIP1_Zn: PIP1_Zn Generic Map(N=>N) PORT MAP(
		zi =>t_zo1 ,
		Ni => t_No,
		clk => clk,
		rst => rst,
		Zn => t_Zn,
		J => t_J,
		No => t_No2,
		zo => t_zo2
	);
--Zn<=t_Zn;
U_PIP2_r_m_j: PIP2_r_m_j Generic Map(N=>N)PORT MAP(
		z => t_zo2,
		zn => t_Zn,
		Ni => t_No2,
		Ji => t_J,
		clk => clk,
		rst => rst,
		r => t_r,
		m => t_m,
		j => t_js
	);
--r<=t_r;
--j<=t_js;
--mo<=t_m;
-----------------------------------------
U_PIP3_r_LUT_m: PIP3_r_LUT_m PORT MAP(
		r =>t_r ,
		mi => t_m,
		j => t_js,
		clk => clk,
		rst => rst,
		ro => t_ro,
		r2 => t_r2,
		F1 => t_F1,
		F2 => t_F2
	);
--r2<=t_r2;
--F1<=t_F1;
--F2<=t_F2;


U_PIP4_X_Y: PIP4_X_Y PORT MAP(
		r => t_ro,
		r2 => t_r2,
		F1 => t_F1,
		F2 => t_F2,
		clk => clk,
		rst => rst,
		X => t_X,
		Y => t_Y
	);
--X<=t_X;
--Y<=t_Y;



	



											
 
U_Divi : divi
		port map (
			clk => clk,
			ce => ce,
			sclr => rst,
			rfd => rfd,
			dividend => t_Y,
			divisor => t_X,
			quotient => t_Q,
			fractional => t_Fr);
			
			

t_QF<=t_Q(N-1) & t_Q(0) & t_Fr(N-2 downto 1);

U_RegQF: Reg Generic Map(N=>N) PORT MAP(
		d => t_QF,
		rst => rst,
		CE => '1',
		clk => clk,
		q => QF
	);
end RTL;

