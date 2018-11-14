----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:29 03/27/2017 
-- Design Name: 
-- Module Name:    ProgramCounter - Behavioral 
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

entity ProgramCounter is
    Port ( EnablePC : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end ProgramCounter;

architecture dataflow of ProgramCounter is

begin
	process(clk) begin
		if(clk = '1') then
			if(EnablePC = '1') then
				output <= input;
			end if;
		end if;
	end process;	
end dataflow;

