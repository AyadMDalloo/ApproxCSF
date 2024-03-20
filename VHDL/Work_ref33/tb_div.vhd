--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:19:25 08/05/2022
-- Design Name:   
-- Module Name:   H:/codes/VHDL/Library Cordic/ipcore/tb_div.vhd
-- Project Name:  ipcore
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Exp_z_org
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Pkg_Exp.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_div IS
END tb_div;
 
ARCHITECTURE behavior OF tb_div IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Exp_z_org
    PORT(
         z : IN  std_logic_vector(15 downto 0);
         y : IN  std_logic_vector(15 downto 0);
         
         Q : OUT  std_logic_vector(15 downto 0);
         rfd : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal z : std_logic_vector(15 downto 0) := (others => '0');
   signal y : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ce : std_logic := '0';

 	--Outputs
  
   signal Q : std_logic_vector(15 downto 0);
   signal rfd : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Exp_z_org PORT MAP (
          z => z,
          y => y,
          
          Q => Q,
          rfd => rfd,
          clk => clk,
          rst => rst,
          ce => ce
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst<='1';
		 wait for clk_period;
		 rst<='0'; ce<='1';
		 z<=frac2bin(23.56,16,6);
		 y<=frac2bin(12.06,16,6);
		
 		 wait for clk_period*30;ce<='0';
--       assert false report "  fr= " & to_stringR(bin2frac(Fr,9,1),9,1) severity warning; 
		 assert false report "  Q= " & to_stringR(bin2frac(Q,16,7),16,7) severity warning; 
      -- insert stimulus here 

      wait;
   end process;

END;
