----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:17:22 03/30/2017 
-- Design Name: 
-- Module Name:    bit_Mult - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit_Mult is
    port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Pi : in  STD_LOGIC;
			  Ci : in  STD_LOGIC;
           Xo : out STD_LOGIC;
			  Yo : out STD_LOGIC;
			  Po : out  STD_LOGIC;
			  Co : out  STD_LOGIC);
			  
end bit_Mult;

architecture Behavioral of bit_Mult is
	component bit_Adder 
	port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
	end component;
Signal XandY : std_logic;	
begin
	XandY <= X and Y;
	Xo <= X;
	Yo <= Y;
	adder1 : bit_Adder port map (Pi,XandY,Ci,Po,Co);
end Behavioral;

