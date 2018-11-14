--------------------------------------------------------------------------------
-- Author:        Parham Alvani (parham.alvani@gmail.com)
--
-- Create Date:   16-03-2017
-- Module Name:   memory.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
	generic (blocksize : integer := 1024);

	port (clk, ReadMem, WriteMem : in std_logic;
		AddressBus: in std_logic_vector (15 downto 0);
		DataBus : inout std_logic_vector (15 downto 0);
		MemDataReady : out std_logic);
end entity memory;

architecture behavioral of memory is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
begin
	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
		--some initiation
			init := false;
		end if;

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(AddressBus));

			if readmem = '1' then -- Reading :)
				MemDataReady <= '0';
				if ad >= blocksize then
					DataBus <= (others => 'Z');
				else
					DataBus <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				MemDataReady <= '0';
				if ad < blocksize then
					buffermem(ad) := DataBus;
				end if;
			else
				Databus <= (others => 'Z');
			end if;
			MemDataReady <= '1';
		end if;
	end process;
end architecture behavioral;