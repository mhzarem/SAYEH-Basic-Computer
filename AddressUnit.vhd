----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:05:40 03/27/2017 
-- Design Name: 
-- Module Name:    AddressUnit - Behavioral 
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

entity AddressUnit is
    Port ( Rside : in  STD_LOGIC_VECTOR (15 downto 0);
           Iside : in  STD_LOGIC_VECTOR (7 downto 0);
           Address : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           ResetPC : in  STD_LOGIC;
           PCplusI : in  STD_LOGIC;
           PCplus1 : in  STD_LOGIC;
           R0plusI : in  STD_LOGIC;
           R0plus0 : in  STD_LOGIC;
           EnablePC : in  STD_LOGIC);
end AddressUnit;

architecture dataflow of AddressUnit is
	component ProgramCounter 
					port ( EnablePC : in  STD_LOGIC;
					input : in  STD_LOGIC_VECTOR (15 downto 0);
					clk : in  STD_LOGIC;
					output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component AddressLogic
					Port ( PCside : in  STD_LOGIC_VECTOR (15 downto 0);
					Rside : in  STD_LOGIC_VECTOR (15 downto 0);
					Iside : in  STD_LOGIC_VECTOR (7 downto 0);
					ALout : out  STD_LOGIC_VECTOR (15 downto 0);
					ResetPC : in  STD_LOGIC;
					PCplusI : in  STD_LOGIC;
					PCplus1 : in  STD_LOGIC;
					R0plusI : in  STD_LOGIC;
					R0plus0 : in  STD_LOGIC);
		
	end component;
	signal pcout : std_logic_vector (15 downto 0);
	signal AddressSignal : std_logic_vector (15 downto 0);
begin
	Address <= AddressSignal;
	I1 : ProgramCounter port map (EnablePC,AddressSignal,clk,pcout);
	I2 : AddressLogic port map (pcout,Rside,Iside,AddressSignal,
							ResetPC,PCplusI,PCplus1,R0plusI,R0plus0);


end dataflow;

