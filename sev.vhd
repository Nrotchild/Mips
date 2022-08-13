library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity sev is
port(
		clk:   in std_logic;
		rst:   in std_logic;
		pb:    in std_logic;
		dig1:  out std_logic;
		buz:   out std_logic;
		dig2:  out std_logic;
		dig3:  out std_logic;
		dig4:  out std_logic;
		ssout: out std_logic_vector(6 downto 0)
	);
end entity sev

architecture arc_sev of sev is

signal q1,q2,q3,q4,cnt_en:std_logic;
signal cnt17:std_logic_vector(16 downto 0);
signal cnt4: std_logic_vector(3 downto 0);
signal s_out_dec: std_logic_vector(6 downto 0);



begin
	process(clk,rst) is
	begin
		if(rst='0')then
			q1<='1';
			q2<='1';
			q3<='1';
			q4<='1';
			cnt17<=(others=>'0');
			cnt4<=(others=>'0');
			ssout<=(others=>'0');
			buz <= rst;
		elsif rising_edge(clk) then
			buz <= pb;
			q1<=pb;
			q2<=q1;
			q4<=q3;
			if(cnt17(16)='1') then       ----------- for bouncing when clk is 50meg ------- 
				q3<=q2;
			end if;
			if(cnt17(16)='1') then 
				cnt17<=(others=>'0');
			else
				cnt17<=cnt17+1;
			end if;
			if(cnt_en='1') then
				cnt4<=cnt4+1;
			end if;
			
		ssout<=s_out_dec;	
	
			
		end if;
		
	end process;
	
	cnt_en<=q3 AND (not q4);
	
	
	process(cnt4) is
	begin
		case cnt4 is
			when "0000" => s_out_dec <= "0000001"; -- "0"     
			when "0001" => s_out_dec <= "1001111"; -- "1" 
			when "0010" => s_out_dec <= "0010010"; -- "2" 
			when "0011" => s_out_dec <= "0000110"; -- "3" 
			when "0100" => s_out_dec <= "1001100"; -- "4" 
			when "0101" => s_out_dec <= "0100100"; -- "5" 
			when "0110" => s_out_dec <= "0100000"; -- "6" 
			when "0111" => s_out_dec <= "0001111"; -- "7" 
			when "1000" => s_out_dec <= "0000000"; -- "8"     
			when "1001" => s_out_dec <= "0000100"; -- "9" 
			when "1010" => s_out_dec <= "0001000"; -- a\
			when "1011" => s_out_dec <= "1100000"; -- b
			when "1100" => s_out_dec <= "0110001"; -- C
			when "1101" => s_out_dec <= "1000010"; -- d
			when "1110" => s_out_dec <= "0110000"; -- E
			when "1111" => s_out_dec <= "0111000"; -- F
		end case;
	end process;
				
end architecture arc_sev;
