----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:03:53 03/27/2017 
-- Design Name: 
-- Module Name:    AddressLogic - Behavioral 
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AddressLogic is
    Port ( PCSide : in  STD_LOGIC_VECTOR (15 downto 0);
           Rside : in  STD_LOGIC_VECTOR (15 downto 0);
           Iside : in  STD_LOGIC_VECTOR (7 downto 0);
           ALout : out  STD_LOGIC_VECTOR (15 downto 0);
           ResetPC : in  STD_LOGIC;
           PCplusI : in  STD_LOGIC;
           PCplus1 : in  STD_LOGIC;
           R0plusI : in  STD_LOGIC;
           R0plus0 : in  STD_LOGIC);
end AddressLogic;

architecture dataflow of AddressLogic is
	constant one : std_logic_vector(4 downto 0) := "10000";
	constant two : std_logic_vector(4 downto 0) := "01000";
	constant three : std_logic_vector(4 downto 0) := "00100";
	constant four : std_logic_vector(4 downto 0) := "00010";
	constant five : std_logic_vector(4 downto 0) := "00001";
begin
	process (PCside,Rside,Iside,ResetPC,
				PCplusI,PCplus1,R0plusI,R0plus0)
				variable temp : std_logic_vector(4 downto 0);
			begin
				temp := (ResetPC & PCplusI & PCplus1 & R0plusI & R0plus0);
				case temp is
					when one => ALout <= (others => '0');
					when two => ALout <= PCside + Iside;
					when three => ALout <= PCside + 1;
					when four => ALout <= Rside + Iside;
					when five => ALout <= Rside;
					when others => ALout <= PCside;
											--(others => '0');
				end case;
			end process;	
end dataflow;