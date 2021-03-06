library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity multti is
    Port (CLK : IN STD_LOGIC;
            a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
           o : buffer  STD_LOGIC_VECTOR (3 downto 0);
           o0 : buffer  STD_LOGIC_VECTOR (3 downto 0);
           o1 : buffer  STD_LOGIC_VECTOR (3 downto 0);
           o2 : buffer  STD_LOGIC_VECTOR (3 downto 0);
           o3 : buffer  STD_LOGIC_VECTOR (3 downto 0);
           C: BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
           LED7S: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
end multti;
architecture Behavioral of multti is
signal s:std_logic_vector(16 downto 0);
begin
process(a,b,s)
variable t,temp2,b1:std_logic_vector(7 downto 0);
variable e:std_logic;
variable temp1:std_logic_vector(8 downto 0);
variable r:bit_vector(16 downto 0);
variable p,s:std_logic_vector(16 downto 0);
variable i:integer;
begin
t:="00000000";
b1:=b;
for i in 0 to 7 loop 
if b1(0)='1' then
temp1:=('0'&a)+('0'&t);
temp2:=temp1(7 downto 0);
e:=temp1(8);
p:=e & temp2 & b1;
else
p:='0' & t & b1;
end if;
r:=to_bitvector(p);
s:=to_stdlogicvector(r srl 1);
t:=s(15 downto 8);
b1:=s(7 downto 0);
end loop;
o0<=s(15 downto 12);
o1<=s(11 downto 8);
o2<=s(7 downto 4);
o3<=s(3 downto 0);
end process;
P1:PROCESS(CLK)
BEGIN
	IF CLK'EVENT AND CLK='1' THEN
		IF C < "011" THEN 
			C <= C+1;
		ELSE
			C<="000";	`
		END IF;
	END IF;
	IF C = "000" THEN
		o <= o0;
	END IF;
	IF C = "001" THEN
		o <= o1;
	END IF;
	IF C = "010" THEN
		o <= o2;
	END IF;
	IF C = "011" THEN
		o <= o3;
	END IF;
END PROCESS P1;

PROCESS(o)
 BEGIN
 CASE o IS
 WHEN"0000"=>LED7S<="0111111";
 WHEN"0001"=>LED7S<="0000110";
 WHEN"0010"=>LED7S<="1011011";
 WHEN"0011"=>LED7S<="1001111";
 WHEN"0100"=>LED7S<="1100110";
 WHEN"0101"=>LED7S<="1101101";
 WHEN"0110"=>LED7S<="1111101";
 WHEN"0111"=>LED7S<="0000111";
 WHEN"1000"=>LED7S<="1111111";
 WHEN"1001"=>LED7S<="1101111";
 WHEN"1010"=>LED7S<="1110111";
 WHEN"1011"=>LED7S<="1111100";
 WHEN"1100"=>LED7S<="0111001";
 WHEN"1101"=>LED7S<="1011110";
 WHEN"1110"=>LED7S<="1111001";
 WHEN"1111"=>LED7S<="1110001";
 WHEN OTHERS=>NULL;
 END CASE;
 END PROCESS;
end Behavioral;