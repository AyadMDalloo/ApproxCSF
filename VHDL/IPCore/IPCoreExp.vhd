----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:40:09 08/14/2022 
-- Design Name: 
-- Module Name:    IPCoreExp - RTL 
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
use work.Pkg_IP.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IPCoreExp is
Generic (N:integer:=16);
         PORT (
						 phase_in : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
						 expz,x_out,y_out : OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
						 rdy : OUT STD_LOGIC;
						 clk : IN STD_LOGIC;
						 ce : IN STD_LOGIC;
						 rst : IN STD_LOGIC
					  );
end IPCoreExp;

architecture RTL of IPCoreExp is
signal t_x_out, t_y_out,t_F : STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
signal t_rdy :std_logic;
begin
U_ExpIP : ExpIP  PORT MAP (
    phase_in => phase_in,
    x_out => t_x_out,
    y_out => t_y_out,
    rdy => t_rdy,
    clk => clk,
    ce => ce,
    sclr => rst
  );
U_Addereta: Addereta Generic Map(N=>2*N) PORT MAP(
		R1 =>t_x_out ,
		R2 => t_y_out,
		F => t_F
	);
U_Reg: Reg Generic Map(N=>2*N)PORT MAP(
		d => t_F,
		rst => rst,
		CE =>t_rdy,
		clk => clk,
		q => expz
	);	
rdy<=t_rdy;	
x_out<=t_x_out;
y_out<=t_y_out;
end RTL;

