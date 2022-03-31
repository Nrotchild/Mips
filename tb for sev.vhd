library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------
entity pb_cnt_tb is
generic(test_mode: integer:=0); -- maybe 0 or 1
end entity pb_cnt_tb;	

architecture arc_pb_cnt_tb of pb_cnt_tb is
signal clk: std_logic:='0';
signal rst: std_logic:='0';
signal pb:  std_logic:='1';
signal ss:  std_logic_vector(6 downto 0);
signal t :  std_logic:='0';
signal pb_sel: integer:=0;
begin
    dut: entity work.pb_cnt
    port map
	    (
          clk=>clk,
          rst=>rst,
          pb=>pb,
          ss=> ss
         );
		 
	clk<=not clk after 20 ns;
    rst<='1' after 8 ns;
	t<=not t after 1 us;
    pb<= '1' when pb_sel=0 else t when pb_sel=1 else '0' when pb_sel=2 else '1';
	
	g1: if (test_mode=0) generate
	process is
	begin
	 wait for 1 us;
	 for i in 0 to 4 loop
		pb_sel<=1;
		wait for 800 us;
		pb_sel<=2;
		wait for 20 ms;
		pb_sel<=1;
		wait for 800 us;
		pb_sel<=0;
		wait for 50 ms;
	 end loop;
     wait;
    end process;
    end generate g1;	
	
    g2: if(test_mode=1) generate	
    process is
     begin
	 wait until rising_edge(rst);
	 wait for 50 ms;
	 l1: for j in 0 to 4 loop
		 l2: for i in 0 to 79 loop
			 pb<= not pb;
			 wait for 10 us;
		 end loop l2;
		 pb<='0';
		 wait for 50 ms;
		 l3: for k in 0 to 70 loop
			 pb<= not pb;
			 wait for 10 us;
		 end loop l3;
		 pb<='1';
		 wait for 100 ms;
	 end loop l1;
	 wait;
     end process;
    end generate g2;	 
end architecture arc_pb_cnt_tb;




     
	 