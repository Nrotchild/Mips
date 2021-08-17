library ieee;
use ieee.std_logic_1164.all;

entity mux is
 port
 ( 
 a0, a1, a2, a3 : in std_logic; 
 sel : in integer range 0 TO 3; 
 o : out std_logic); 
end mux; 

architecture behave of mux is
begin
 
 with s select
 o <= a0 when 0, 
 a1 when 1, 
 a2 when 2, 
 a3 when 3; 
 
END behave;