----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:37:38 03/30/2017 
-- Design Name: 
-- Module Name:    Arithmetic_Unit - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ArithmeticUnit is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           Cin : in  STD_LOGIC;
           B15to0 : in  STD_LOGIC;
           AandB : in  STD_LOGIC;
           AorB : in  STD_LOGIC;
           NotB : in  STD_LOGIC;
           AaddB : in  STD_LOGIC;
           AsubB : in  STD_LOGIC;
           AmulB : in  STD_LOGIC; --optional
           AcmpB : in  STD_LOGIC;
           ShrB : in  STD_LOGIC;
           ShlB : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (15 downto 0);
           Zout : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end ArithmeticUnit;
	--can perform 11 arithmetic and logic operations on the input(s)
	
architecture dataflow of ArithmeticUnit is
	component Generic_Mult 
		generic (n : integer := 8);--to multiply X and Y as n bit numbers . Using 4 as default length of X and Y
		port(X,Y : in STD_LOGIC_VECTOR(7 downto 0);
	     Output : out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	signal Mult_Res : STD_LOGIC_VECTOR(15 downto 0);
	
	constant ALU_B15to0 : STD_LOGIC_VECTOR(9 downto 0) := "1000000000";
	constant ALU_AandB : STD_LOGIC_VECTOR(9 downto 0) := "0100000000";
	constant ALU_AorB : STD_LOGIC_VECTOR(9 downto 0) := "0010000000";
	constant ALU_NotB : STD_LOGIC_VECTOR(9 downto 0) := "0001000000";
	constant ALU_AaddB : STD_LOGIC_VECTOR(9 downto 0) := "0000100000";
	constant ALU_AsubB : STD_LOGIC_VECTOR(9 downto 0) := "0000010000";
	constant ALU_AmulB : STD_LOGIC_VECTOR(9 downto 0) := "0000001000";
	constant ALU_AcmpB : STD_LOGIC_VECTOR(9 downto 0) := "0000000100";
	constant ALU_ShrB : STD_LOGIC_VECTOR(9 downto 0) := "0000000010";
	constant ALU_ShlB : STD_LOGIC_VECTOR(9 downto 0) := "0000000001";
	
	
begin
	
	Mult_8bit : Generic_Mult generic map (n => 8) port map(A(7 downto 0),B(7 downto 0),Mult_Res);
	
	process(A,B,B15to0,Cin,AandB,AorB,NotB,AaddB,
	AsubB,AmulB,AcmpB,ShrB,ShlB)
		
	variable OutputH : STD_LOGIC_VECTOR(16 downto 0);
	variable control : STD_LOGIC_VECTOR(9 downto 0); 	
	variable Help : STD_LOGIC_VECTOR(16 downto 0);
	variable interZ,interC : STD_LOGIC;
	begin
		Zout <= '0';
		Cout <= '0';
		OutputH := (others => '0');
		Help := (16 downto 1 => '0',0 => Cin);
		control := (B15to0 & AandB & AorB & NotB & AaddB & AsubB & AmulB & AcmpB & ShrB & ShlB);	
		case(control) is
			when ALU_B15to0 =>
				Output <= B(15 downto 0);
			when ALU_AandB =>
				Output <= A and B;	
			when ALU_AorB =>
				Output <= A or B;
			when ALU_NotB =>
				Output <= not(B);
			when ALU_AaddB =>
				OutputH :=
				('0' & A) 
				+ 
				('0' & B) 
				+
				Help
				;
				Output <= OutputH(15 downto 0);
				Cout <= OutputH(16);
				
			when ALU_AsubB =>
				OutputH := ('0' & A) - ('0' & B) - Help;
				Output <= OutputH(15 downto 0);
				Cout <= OutputH(16);
			when ALU_AmulB =>
				Output <= Mult_Res;
			when ALU_ShrB =>
				Output <= B(15) & B(15 downto 1);
			when ALU_ShlB =>
				Output <= B(14 downto 0) & B(0);
			when ALU_AcmpB =>
				if (A = B) then Zout <= '1';
				elsif (A > B) then Cout <= '1';
				--else Cout and Zout retain their values and do not change as both were set to '0'	
				else
					Cout <= '0';
					Zout <= '0';
				end if;
			
			when others =>		
			end case;
			
	end process;
	
end dataflow;

