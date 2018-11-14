library IEEE;
use IEEE.std_logic_1164.all;

entity controller is port (
  clk: in std_logic;
  address: in std_logic_vector(9 downto 0);
  write: in std_logic;
  read: in std_logic;
  hit: in std_logic;
  ram_ready:in std_logic;
  --write_data:in std_logic_vector(31 downto 0);--
  invalidate: out std_logic;
  read_ram: out std_logic;
  read_cache: out std_logic;
  write_cache_enable: out std_logic;
  write_ram_enable: out std_logic
  --data: out std_logic_vector(31 downto 0)--
  );
end controller;

architecture dataflow of controller is

type type_name is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9 ,s10);
SIGNAL state   : type_name :=s0;


begin

	process (clk)

	begin
		if(rising_edge(clk)) then
			case state is
			  when s0 =>             --request sent to cache--
			 invalidate<='0';
          read_ram <='0';
          read_cache<='0';
          write_cache_enable <='0';
          write_ram_enable <='0'; 
          
				if(write='1') and (read='0') then
					state <=s1;
					
				elsif(write='0') and (read='1') then
					state<=s4;
					
				end if;
				
				
				
				when s4 =>
				  invalidate<='0';   
				  read_ram <='0';
          read_cache<='0';
          write_cache_enable <='0';
          write_ram_enable <='0';  
				  
				  
				if (hit='1') then
					state <=s5;
					
				elsif (hit='0') then
					state<=s6;
					
				end if;
				
				when s5 => 
				  invalidate<='0';   
				  read_ram <='0';
          read_cache<='1';
          write_cache_enable <='0';
          write_ram_enable <='0'; 
            
					state <=s0;
					
				
				when s6 => 
				  invalidate <='0';
				  read_ram <='1';
          read_cache <='0';
          write_cache_enable <='0';
          write_ram_enable <='0'; 
            
					state <=s7;
				
				when s7 => 
				  invalidate<='0';   
				  read_ram <='1';
          read_cache<='0';
          write_cache_enable <='1';
          write_ram_enable <='0'; 
            
					state <=s8;    --delay to write complete--
					
				when s8 => 
				  invalidate<='0';   
				  read_ram <='1';
          read_cache<='0';
          write_cache_enable <='1';
          write_ram_enable <='0'; 
            
					state <=s9;    --delay to write complete--
					
				when s9 => 
				  invalidate<='0';   
				  read_ram <='1';
          read_cache<='0';
          write_cache_enable <='0';
          write_ram_enable <='0'; 
            
					state <=s10;
					
				when s10 => 
				  invalidate<='0';   
				  read_ram <='1';
          read_cache<='0';
          write_cache_enable <='0';
          write_ram_enable <='0'; 
					state <=s0;
						
					when s1 => 
				invalidate<='0';
				read_ram <='0';
                  read_cache<='0';
                  write_cache_enable <='0';
				  write_ram_enable <='0'; 
				
				  
				if (hit='1') then
					state <=s2;
					
				elsif(hit='0') then
					state<=s3;
					
				end if;
				
				when s2 =>
				  invalidate<='1';
				  read_ram <='0';
                  read_cache<='0';
                  write_cache_enable <='0';
                  write_ram_enable <='1';   
				if(ram_ready='1') then
					state <=s0;
				
				end if;
				
				when s3 => 
				  invalidate<='0';
				  read_ram <='0';
          read_cache<='0';
          write_cache_enable <='0';
          write_ram_enable <='1';   
				if(ram_ready='1') then
					state <=s0;
					
				end if;
					
				
				when others => 
				state <= s0;

			  
		end case;

			
		end if;
	end process;


end dataflow;