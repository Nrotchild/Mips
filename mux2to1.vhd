library ieee;
use ieee.std_logic_1164.all;

entity MUX is
	port(
	a: in std_logic;
	b: in std_logic;
	s: in std_logic;
	o: out std_logic
	);
end MUX;

architecture MUX1 of MUX is
begin
	o<= ((NOT s)AND a)OR(s AND b);
end MUX1;
	
