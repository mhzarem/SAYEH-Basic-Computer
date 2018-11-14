----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:52 03/30/2017 
-- Design Name: 
-- Module Name:    Generic_Mult - Behavioral 
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

entity Generic_Mult is
	generic(n : integer := 8);--to multiply X and Y as n bit numbers . Using 4 as default length of X and Y
	port(X,Y : in STD_LOGIC_VECTOR(n - 1 downto 0);
	     Output : out STD_LOGIC_VECTOR(2 * n - 1 downto 0));
end Generic_Mult;

architecture dataflow of Generic_Mult is
	component bit_Mult 
		port ( X : in  STD_LOGIC;
           Y : in  STD_LOGIC;
           Pi : in  STD_LOGIC;
			  Ci : in  STD_LOGIC;
           Xo : out STD_LOGIC;
			  Yo : out STD_LOGIC;
			  Po : out  STD_LOGIC;
			  Co : out  STD_LOGIC
			 );
	end component;
	--as the first step we should create two dimensional arrays
	type Array2D is array(n downto 0 , n downto 0) of STD_LOGIC;
	signal x2d,y2d,p2d,c2d : Array2D ;

begin
	initialization: for i in n - 1 downto 0 generate
		x2d(i,0) <= X(i);
		y2d(0,i) <= Y(i);
		p2d(0,i + 1) <= '0';--ingoing p2d for (0,i)-th cell
		c2d(i,0) <= '0';--Cin for (0,i)-th cell
		p2d(i + 1,n) <= c2d(i,n);
		Output(i) <= p2d(i + 1,0);
		Output(n + i) <= p2d(n,i + 1);
	end generate;
	
	OUTER: for i in n - 1 downto 0 generate
		INNER: for j in n - 1 downto 0 generate
			bm : bit_Mult port map(x2d(i,j),y2d(i,j),p2d(i,j + 1),c2d(i,j),--ingoing signals for bit_Mult cell 
																				  --located at i-th row and j-th column
							       	  x2d(i,j + 1),y2d(i + 1,j),p2d(i + 1,j),c2d(i,j + 1)	--outgoing signals for bit_Mult cell 
																	--located at i-th row and j-th column
								 );
								 
		end generate;
	end generate;

end dataflow;