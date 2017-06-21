LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


PACKAGE mypack IS
	CONSTANT idle : std_logic_vector(3 DOWNTO 0) :="0000";
	CONSTANT load : std_logic_vector(3 DOWNTO 0) :="0001";
	CONSTANT move : std_logic_vector(3 DOWNTO 0) :="0010";
	CONSTANT addx : std_logic_vector(3 DOWNTO 0) :="0011";
	CONSTANT subp : std_logic_vector(3 DOWNTO 0) :="0100";
	CONSTANT andp : std_logic_vector(3 DOWNTO 0) :="0101";
	CONSTANT orp : std_logic_vector(3 DOWNTO 0) :="0110";
	CONSTANT xorp : std_logic_vector(3 DOWNTO 0) :="0111";
	CONSTANT shrp : std_logic_vector(3 DOWNTO 0) :="1000";
	CONSTANT shlp : std_logic_vector(3 DOWNTO 0) :="1001";
	CONSTANT swap : std_logic_vector(3 DOWNTO 0) :="1010";
	CONSTANT jmp : std_logic_vector(3 DOWNTO 0) :="1011";
	CONSTANT jz : std_logic_vector(3 DOWNTO 0) :="1100";
	CONSTANT read : std_logic_vector(3 DOWNTO 0) :="1101";
	CONSTANT write : std_logic_vector(3 DOWNTO 0) :="1110";
	CONSTANT stop : std_logic_vector(3 DOWNTO 0) :="1111";
END mypack;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE WORK.mypack.ALL;



------------------------cpu ʵ������---------------------------------
ENTITY cpu IS
PORT(
	reset : IN std_logic; --�����źŵ���Ч
	clock : IN std_logic; --ʱ���ź�
	Write_Read: OUT std_logic; --��д�ź�,'1'Ϊд
	M_address: OUT std_logic_vector(11 DOWNTO 0); --��ַ��
	M_data_in: IN std_logic_vector(7 DOWNTO 0); -- ����������
	M_data_out: OUT std_logic_vector(7 DOWNTO 0); -- ���������
	overflow: OUT std_logic); -- �����־
END cpu;
------------------------cpuRTL ����Ϊ����--------------------------------




ARCHITECTURE RTL of cpu IS
	SIGNAL IR: std_logic_vector(15 DOWNTO 0); --ָ��Ĵ���
	SIGNAL MDR: std_logic_vector(7 DOWNTO 0); -- ���ݼĴ���
	SIGNAL MAR: std_logic_vector(11 DOWNTO 0); --��ַ�Ĵ���
	SIGNAL status: integer RANGE 0 TO 6; --״̬�Ĵ���
	BEGIN
		status_change: PROCESS(reset, clock, status )
			BEGIN
				IF reset = '0' THEN status <= 0 ;
				ELSIF clock'EVENT AND clock = '0' THEN
					CASE status IS
						WHEN 0 =>status <= 1;
						WHEN 1 =>
							IF IR(15 DOWNTO 12) = Stop THEN
								status <= 1;
							ELSE
								status <= 2;
							END IF;
						WHEN 2 =>
							CASE IR(15 DOWNTO 12) IS
								WHEN Read|Write|Jmp|Jz|Swap =>status <= 3;
								WHEN OTHERS =>status <= 0;
							END CASE;
						WHEN 3 =>IF IR(15 DOWNTO 12)= Swap THEN
									status <= 0;
								ELSE
									status <= 4;
								END IF;
						WHEN 4 =>status <= 5;
						WHEN 5 =>
							CASE IR(15 DOWNTO 12) IS
								WHEN Read|Write =>status <= 6;
								WHEN OTHERS =>status <= 0;
							END CASE;
						WHEN OTHERS =>status <= 0;
					END CASE;
				ELSE
					NULL;
				END IF;
	END PROCESS status_change;
	
seq: PROCESS(reset,clock)
	VARIABLE PC:std_logic_vector(11 DOWNTO 0); --���������
	VARIABLE R0,R1,R2,R3: std_logic_vector(7 DOWNTO 0); -- ͨ�üĴ���
	VARIABLE A: std_logic_vector(7 DOWNTO 0); --��ʱ�Ĵ���
	VARIABLE temp: std_logic_vector(8 DOWNTO 0); --��ʱ����
	BEGIN
		IF(reset='0') THEN -- ����
			IR <= (OTHERS=>'0');
			PC := (OTHERS=>'0');
		R0 := (OTHERS=>'0');
		R1 := (OTHERS=>'0');
		R2 := (OTHERS=>'0');
		R3 := (OTHERS=>'0');
		A := (OTHERS=>'0');
		MAR <= (OTHERS=>'0');
		MDR <= (OTHERS=>'0');
		ELSIF(clock'event AND clock='1') THEN
		overflow <= '0';
CASE status IS
WHEN 0=> -- ״̬0
IR <= M_data_in & "00000000"; --ȡָ��
PC := PC+1; --�����������1
WHEN 1=> --״̬1
IF (IR(15 DOWNTO 12) /= stop) THEN
MAR <= PC;
END IF;
CASE IR(15 DOWNTO 12) IS
WHEN load =>
R0:= "0000" & IR(11 DOWNTO 8);
WHEN shlp|shrp =>
CASE IR(11 DOWNTO 10) IS -- Rx to A
WHEN "00"=> A:= R0;
WHEN "01"=> A:= R1;
WHEN "10"=> A:= R2;
WHEN OTHERS => A:= R3;
END CASE;
WHEN Move|addx|subp|andp|orp|xorp|Swap=>
CASE IR(9 DOWNTO 8) IS -- Ry to A
WHEN "00"=> A:=R0;
WHEN "01"=> A:=R1;
WHEN "10"=> A:=R2;
WHEN OTHERS=> A:=R3;
END CASE;
WHEN OTHERS => NULL;
END CASE;
WHEN 2=> -- ״̬2
CASE IR(15 DOWNTO 12) IS
WHEN addx => -- Rx:= Rx + A;
CASE IR(11 DOWNTO 10) IS
WHEN "00"=>
temp := (R0(7) & R0(7 DOWNTO 0)) + (A(7) & A(7 DOWNTO
0));
R0:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
WHEN "01"=>
temp :=(R1(7) & R1(7 DOWNTO 0)) + (A(7) & A(7 DOWNTO
0));
R1:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
WHEN "10"=>
temp :=(R2(7) & R2(7 DOWNTO 0)) + (A(7) & A(7 DOWNTO
0));
R2:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
WHEN OTHERS=>
temp :=(R3(7) & R3(7 DOWNTO 0)) + (A(7) & A(7 DOWNTO
0));
R3:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
END CASE;
WHEN subp => -- Rx:= Rx - A;
CASE IR(11 DOWNTO 10) IS
WHEN "00"=>
temp :=(R0(7) & R0(7 DOWNTO 0)) + NOT(A(7) & A(7
DOWNTO 0)) + 1;
R0:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
WHEN "01"=>
temp :=(R1(7) & R1(7 DOWNTO 0)) + NOT(A(7) & A(7
DOWNTO 0)) + 1;
R1:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
WHEN "10"=>
temp :=(R2(7) & R2(7 DOWNTO 0)) + NOT(A(7) & A(7
DOWNTO 0)) + 1;
R2:=temp(7 DOWNTO 0);
overflow <= temp(8) xor temp(7);
WHEN OTHERS=>
temp :=(R3(7) & R3(7 DOWNTO 0)) + NOT(A(7) & A(7
DOWNTO 0)) + 1;
R3:=temp(7 DOWNTO 0);
overflow <= temp(8) XOR temp(7);
END CASE;
WHEN move =>
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:= A;
WHEN "01"=> R1:= A;
WHEN "10"=> R2:= A;
WHEN OTHERS=> R3:= A;
END CASE;
WHEN shrp =>
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:= '0' & A( 7 DOWNTO 1 );
WHEN "01"=> R1:= '0' & A( 7 DOWNTO 1 );
WHEN "10"=> R2:= '0' & A( 7 DOWNTO 1 );
WHEN OTHERS=> R3:= '0' & A( 7 DOWNTO 1 );
END CASE;
WHEN shlp =>
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:= A( 6 DOWNTO 0 ) & '0';
WHEN "01"=> R1:= A( 6 DOWNTO 0 ) & '0';
WHEN "10"=> R2:= A( 6 DOWNTO 0 ) & '0';
WHEN OTHERS=> R3:= A( 6 DOWNTO 0 ) & '0';
END CASE;
WHEN andp => --Rx:= Rx AND A;
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:=R0 AND A;
WHEN "01"=> R1:=R1 AND A;
WHEN "10"=> R2:=R2 AND A;
WHEN OTHERS=> R3:=R3 AND A;
END CASE;
WHEN orp => --Rx:= Rx OR A;
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:=R0 OR A;
WHEN "01"=> R1:=R1 OR A;
WHEN "10"=> R2:=R2 OR A;
WHEN OTHERS=> R3:=R3 OR A;
END CASE;
WHEN xorp => --Rx:= Rx XOR A;
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:=R0 XOR A;
WHEN "01"=> R1:=R1 XOR A;
WHEN "10"=> R2:=R2 XOR A;
WHEN OTHERS=> R3:=R3 XOR A;
END CASE;
WHEN Swap => --Swap: Rx to Ry;
CASE IR(11 DOWNTO 8) IS
WHEN "0100"=> R0:=R1;
WHEN "1000"=> R0:=R2;
WHEN "1100"=> R0:=R3;
WHEN "0001"=> R1:=R0;
WHEN "1001"=> R1:=R2;
WHEN "1101"=> R1:=R3;
WHEN "0010"=> R2:=R0;
WHEN "0110"=> R2:=R1;
WHEN "1110"=> R2:=R3;
WHEN "0111"=> R3:=R1;
WHEN "1011"=> R3:=R2;
WHEN "0011"=> R3:=R0;
WHEN OTHERS=> NULL;
END CASE;
WHEN OTHERS => NULL;
END CASE;
WHEN 3=> -- ״̬3
CASE IR(15 DOWNTO 12) IS
WHEN Swap=> -- Swap: A to Rx
CASE IR(11 DOWNTO 10) IS
WHEN "00"=> R0:=A;
WHEN "01"=> R1:=A;
WHEN "10"=> R2:=A;
WHEN OTHERS=> R3:=A;
END CASE;
WHEN jmp|Jz|Read|Write =>
IR(7 DOWNTO 0)<= M_data_in; -- ȡ˫�ֽ�ָ��ĺ�벿��
PC := PC+1;
WHEN OTHERS => NULL;
END CASE;
WHEN 4=> -- ״̬4
CASE IR(15 DOWNTO 12) IS
WHEN jmp => -- ������ת��ָ��
PC := IR(11 DOWNTO 0);
MAR <= IR(11 DOWNTO 0);
WHEN Jz => -- ����ת��ָ��
IF(R0="00000000") then
PC := IR(11 DOWNTO 0);
MAR <= IR(11 DOWNTO 0);
else
MAR <= PC;
END IF;
WHEN Read =>
MAR <= IR(11 DOWNTO 0);
WHEN Write =>
MAR <= IR(11 DOWNTO 0);
MDR <= R0;
WHEN OTHERS => NULL;
END CASE;
WHEN 5 => --״̬5
MAR <= PC;
WHEN 6 => --״̬6
CASE IR(15 DOWNTO 12) IS
WHEN Read => R0 := M_data_in;
WHEN OTHERS=> NULL;
END CASE;
END CASE;
END IF;
END process seq;
comb: PROCESS (reset, status)
BEGIN
IF (reset = '1' AND status = 5 AND IR(15 DOWNTO 12)= Write ) THEN
Write_Read <= '1';
ELSE
Write_Read <= '0';
END IF;
END PROCESS comb;
M_address <= MAR;
M_data_out <= MDR;
END RTL;