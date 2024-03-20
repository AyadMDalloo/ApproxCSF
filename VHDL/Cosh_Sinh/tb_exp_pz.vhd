--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:16:35 09/07/2022
-- Design Name:   
-- Module Name:   H:/codes/VHDL/Library Cordic/exp_pZ/tb_exp_pz.vhd
-- Project Name:  exp_pZ
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: exp_pz
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
use IEEE.Math_real.all;
use work.Pkg_Exp.all;
--use ieee.fixed_pkg.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL; 
 
ENTITY tb_exp_pz IS
END tb_exp_pz;
 
ARCHITECTURE behavior OF tb_exp_pz IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT exp_pz
    PORT(
         z : IN  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         rst,c_sinh : IN  std_logic;
--          Nr : out std_logic_vector(N-6 downto 0);
--			  Zn : out std_logic_vector(N+4 downto 0);
--			  Err: out std_logic_vector(N-1 downto 0);
--			  F1,F2: out std_logic_vector(N-1 downto 0);
--			  J:  out std_logic_vector(5 downto 0);
--			  X:  out std_logic_vector(N-1 downto 0);
--			  Y : out std_logic_vector(N+9 downto 0);
         cosh_sinh : OUT  std_logic_vector(3*N-1  downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal z : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst,c_sinh : std_logic := '0';
   

 	--Outputs
   signal cosh_sinh : std_logic_vector(3*N-1 downto 0);
--   signal Nr :  std_logic_vector(N-6 downto 0);
--	signal Zn :  std_logic_vector(N+4 downto 0);
--	signal Err:  std_logic_vector(N-1 downto 0);
--   signal F1,F2:  std_logic_vector(N-1 downto 0);
--	signal J:  std_logic_vector(5 downto 0);
--	signal X:   std_logic_vector(N-1 downto 0);
--	signal Y :  std_logic_vector(N+9 downto 0);
   -- Clock period definitions
   constant clk_period : time := 5 ns;
   constant D: time := 5 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: exp_pz PORT MAP (
          z => z,
          clk => clk,
          rst => rst,
          c_sinh=>c_sinh,
--			 Nr=>Nr,
--			 Zn=>Zn,
--			 Err=>Err,
--			 F1=>F1,
--			 F2=>F2,
--			 J=>J,
--			 X=>X,
--			 Y=>Y,
			 cosh_sinh => cosh_sinh
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
   file inA1 : text open read_mode is "A.txt";
	file inA2 : text open read_mode is "A.txt";
	file outB1 : text open write_mode is "P.txt";
	file outB2 : text open write_mode is "N.txt";
	variable Lin,Lout : line;
	variable Ka,Kb,c : integer;
	variable T: real;
	variable Rs:std_logic_vector(N-1 downto 0);
	begin		
	     rst<='1';c:=0;
        wait for D; 
		  rst<='0'; 
		  

--	ka:=3256;
--	assert false report "  R = " & integer'image(Ka) severity warning; 
--				 T:=real(Ka)/1000.0;
--				 Rs:=frac2bin(T,N,Nint-2);
--	 assert false report "  Rs = " & to_string(Rs) severity warning; 
--	 assert false report "  Z= " & to_stringR(bin2frac(Rs,N,Nint-2),N,Nint-2) severity warning; 
--			    z<=Rs;
--			  wait for 2*D;
--	 assert false report "  N= " & to_string(Nr) severity warning; 
--	 assert false report "  N= " & to_stringR(bin2frac(Nr,N-5,N-6),N-5,N-6) severity warning;	
--	  
--	  assert false report "  J= " & to_string(J) severity warning; 
--	 assert false report "  J= " & to_stringR(bin2frac('0' & J,7,6),7,6) severity warning; 
--	 
--	  wait for 1*D;
--	  assert false report " F1= " & to_string(F1) severity warning; 
--	 assert false report "  F1= " & to_stringR(bin2frac(F1,N,15),N,15) severity warning;
--	 assert false report "  F2= " & to_string(F2) severity warning; 
--	 assert false report "  F2= " & to_stringR(bin2frac(F2,N,1),N,1) severity warning;		
--	 assert false report "  Zn= " & to_string(Zn) severity warning; 
--	 assert false report "  Zn= " & to_stringR(bin2frac(Zn,N,4),N,4) severity warning; 
--	  wait for 1*D;
--	 assert false report "  r= " & to_string(Err) severity warning; 
--	 assert false report "  r= " & to_stringR(bin2frac(Err,N,1),N,1) severity warning; 
----	 wait for 1*D;
--	 assert false report "  Y= " & to_string(Y) severity warning; 
--	 assert false report "  Y= " & to_stringR(bin2frac(Y,N+10,16),N+10,16) severity warning;
--	  
--    assert false report "  X= " & to_string(X) severity warning; 
--	 assert false report "  X= " & to_stringR(bin2frac(X,N,1),N,1) severity warning; 	
--   
--	 
--   
----	  wait for 1*D;
--    
--    
--	 wait for 1*D;	 
-- assert false report "  exp= " & to_string(exp) severity warning; 	 
--	assert false report "  exp= " & to_stringR(bin2frac(exp,2*N+10,17),2*N+10,17) severity warning; 	
--                    Kb := integer(bin2frac(exp,2*N+10,17)*10.0**6);
--						  WRITE(Lout,Kb);
--						  WRITELINE(outB1, Lout);
    c_sinh<='0';
		  while not endfile(inA2) loop --till the end of file is reached continue.
              c:=c+1;
				  readline (inA2,Lin);
				  read(Lin,Ka); 
--				  assert false report "  in2 = " & integer'image(Ka) severity warning; 
				  T:=real(Ka)/1000.0;
				  Rs:=frac2bin(T,N,Nint-2);
--				  assert false report "  inf2= " & to_stringR(bin2frac(Rs,N,Nint-2),N,Nint-2) severity warning; 
				  z<=Rs;
				  wait for D;
				  if (c>=6) then 
				  
				    	  assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
				  end if;
		  end loop; 
		  
		  wait for D;
		  
                assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
		  wait for D;
					  assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
		 
			wait for D;
					 assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
			wait for D;
					 assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
		wait for D;
					 assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB2, Lout);
		
c_sinh<='1';				  
        while not endfile(inA1) loop --till the end of file is reached continue.
              c:=c+1;
				  readline (inA1,Lin);
				  read(Lin,Ka); 
--				  assert false report "  in1 = " & integer'image(Ka) severity warning; 
				  T:=real(Ka)/1000.0;
				  Rs:=frac2bin(T,N,Nint-2);
--				  assert false report "  inf1= " & to_stringR(bin2frac(Rs,N,Nint-2),N,Nint-2) severity warning; 
				  z<=Rs;
				  wait for D;
				  if (c>=6) then 
				  
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
				  end if;
		  end loop; 
		   wait for D;
		  
                 
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
		  
		  wait for D;
					 
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
			wait for D;
				
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
			wait for D;
					  
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
		  
--		  
			wait for D;
					  
--				    	   assert false report "  cosh_sinh= " & to_stringR(bin2frac(cosh_sinh,3*N ,N+1),3*N ,N+1) severity warning; 
						  Kb := integer(bin2frac(cosh_sinh,3*N ,N+1)*10.0**5);
						  WRITE(Lout,Kb);
						  WRITELINE(outB1, Lout);
		  
      wait;
   end process;

END;
