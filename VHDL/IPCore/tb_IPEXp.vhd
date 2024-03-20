--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:55:51 08/14/2022
-- Design Name:   
-- Module Name:   H:/codes/VHDL/Library Cordic/IPCore4/tb_IPEXp.vhd
-- Project Name:  IPCore4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IPCoreExp
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
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
use work.Pkg_IP.all;
 
ENTITY tb_IPEXp IS
END tb_IPEXp;
 
ARCHITECTURE behavior OF tb_IPEXp IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IPCoreExp
    PORT(
         phase_in : IN  std_logic_vector(15 downto 0);
         expz,x_out,y_out : OUT  std_logic_vector(2*N-1 downto 0);
         
         rdy : OUT  std_logic;
         clk : IN  std_logic;
         ce : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal phase_in : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal expz,x_out,y_out : std_logic_vector(2*N-1  downto 0);
   signal rdy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IPCoreExp PORT MAP (
          phase_in => phase_in,
          expz => expz,
          x_out=>x_out,
			 y_out=>y_out,
          rdy => rdy,
          clk => clk,
          ce => ce,
          rst => rst
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
      file inA : text open read_mode is "A.txt";
		file outB : text open write_mode is "OUT.txt";
		variable Lin,Lout : line;
		variable Ka,Kb : integer;
		variable T: real;
		variable Rs:std_logic_vector(N-1 downto 0);
	begin		
		rst<='1'; 
		wait for clk_period;	
		rst<='0';
      while not endfile(inA) loop --till the end of file is reached continue.
       
		     readline (inA,Lin);
			  read(Lin,Ka); 
           assert false report "  in = " & integer'image(Ka) severity warning; 
			  ce<='1';
           
			  T:=-real(Ka)/1000.0;
			  Rs:=frac2bin(T,N,1);
			  phase_in<=Rs;
			 	
		     
			  wait for clk_period*23;
			  assert false report "   x= " & to_stringR(bin2frac(x_out,2*N,1),2*N,1) severity warning;
			  assert false report "   y= " & to_stringR(bin2frac(y_out,2*N,1),2*N,1) severity warning;
			  assert false report "   expz= " & to_stringR(bin2frac(expz,2*N,1),2*N,1) severity warning; 
           Kb := integer(bin2frac( expz,2*N,1)*10.0**4);
			   
           WRITE(Lout,Kb);
           WRITELINE(outB, Lout);
		end loop; 

      -- insert stimulus here 

      wait;
   end process;

END;
