----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:16:51 03/29/2017 
-- Design Name: 
-- Module Name:    StatusReg - Behavioral 
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

entity StatusReg is
    Port ( Cin : in  STD_LOGIC;
           Zin : in  STD_LOGIC;
           CSet : in  STD_LOGIC;
           CReset : in  STD_LOGIC;
           ZSet : in  STD_LOGIC;
           ZReset : in  STD_LOGIC;
           SRLoad : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Zout : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end StatusReg;

architecture dataflow of StatusReg is

begin
	process(clk,CReset,CSet,ZSet,SRLoad) begin
		if (clk'Event and clk = '1') then
			if (CSet = '1') then
				Cout <= '1';
			elsif (CReset = '1') then
				Cout <= '0';
			elsif (ZSet = '1') then
				Zout <= '1';
			elsif (ZReset = '1') then
				Zout <= '0';
			elsif (SRLoad = '1') then
				Zout <= Zin;
				Cout <= Cin;
				
			end if;
		end if;
	end process;

end dataflow;