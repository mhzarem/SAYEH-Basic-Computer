----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:16:11 04/12/2017 
-- Design Name: 
-- Module Name:    FinalTB - Behavioral 
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

entity FinalTB is
end FinalTB;

architecture Behavioral of FinalTB is
	component memory
		port (clk, ReadMem, WriteMem : in std_logic;
		AddressBus: in std_logic_vector (15 downto 0);
		DataBus : inout std_logic_vector (15 downto 0);
		MemDataReady : out std_logic);
	end component;


component AddressUnit
		port ( Rside : in  STD_LOGIC_VECTOR (15 downto 0);
           Iside : in  STD_LOGIC_VECTOR (7 downto 0);
           Address : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           ResetPC : in  STD_LOGIC;
           PCplusI : in  STD_LOGIC;
           PCplus1 : in  STD_LOGIC;
           R0plusI : in  STD_LOGIC;
           R0plus0 : in  STD_LOGIC;
           EnablePC : in  STD_LOGIC);
   end component;

   component ArithmeticUnit
		port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
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
   end component;
	
   component RegisterFile
      port (
         input_file : in std_logic_vector (15 downto 0);
         clk : in std_logic;
         start : in std_logic_vector (5 downto 0);
         Laddr, Raddr : in std_logic_vector (1 downto 0);
         RFLwrite, RFHwrite : in std_logic;
         left_out, Right_out : out std_logic_vector (15 downto 0)
      );
   end component;

   component InstructionRegister
      port (
         input : in std_logic_vector (15 downto 0);
         IRload, clk : in std_logic;
         output : out std_logic_vector (15 downto 0)
      );
   end component;

   component StatusReg
		port ( Cin : in  STD_LOGIC;
           Zin : in  STD_LOGIC;
           CSet : in  STD_LOGIC;
           CReset : in  STD_LOGIC;
           ZSet : in  STD_LOGIC;
           ZReset : in  STD_LOGIC;
           SRLoad : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Zout : out  STD_LOGIC;
           clk : in  STD_LOGIC);
		
   end component;

   component WindowPointer
      port (
			clk : in std_logic;
         input : in std_logic_vector (5 downto 0);
         WPreset,WPadd : in std_logic;
         output : out std_logic_vector (5 downto 0)
      );
   end component;

component controller
	Port (  clk : in  STD_LOGIC;
           ShadowEn : in  STD_LOGIC;
           External_Reset : in  STD_LOGIC;
           MemDataReady : in  STD_LOGIC;
           Zout : in  STD_LOGIC;
           Cout : in  STD_LOGIC;
			  Instruction : in STD_LOGIC_VECTOR(7 downto 0);--contains the Instruction to be processed
           --Memory
			  ReadMem : out  STD_LOGIC;
           WriteMem : out  STD_LOGIC;
           --IR
			  IRLoad : out  STD_LOGIC;
           IR_on_LOpndBus : out  STD_LOGIC;
           IR_on_HOpndBus : out  STD_LOGIC;
           --Register File
			  RFright_on_OpndBus : out  STD_LOGIC;
           Rs_on_AddressUnitRSide : out  STD_LOGIC;
           Rd_on_AddressUnitRSide : out  STD_LOGIC;
           RFLwrite : out  STD_LOGIC;
           RFHwrite : out  STD_LOGIC;
			  --Arithmetic Unit
			  B15to0 : out  STD_LOGIC;
           AandB : out  STD_LOGIC;
           AorB : out  STD_LOGIC;
           NotB : out  STD_LOGIC;
           AaddB : out  STD_LOGIC;
           AsubB : out  STD_LOGIC;
           AmulB : out  STD_LOGIC;
           AcmpB : out  STD_LOGIC;
           ShrB : out  STD_LOGIC;
           ShlB : out  STD_LOGIC;
           ALUout_on_Databus : out  STD_LOGIC;
			  --Status Flag
			  CSet : out  STD_LOGIC;
           CReset : out  STD_LOGIC;
           ZSet : out  STD_LOGIC;
           ZReset : out  STD_LOGIC;
           SRLoad : out  STD_LOGIC;
			  --Address Logic
			  Address_on_Databus : out  STD_LOGIC;
			  EnablePC : out STD_LOGIC;
           ResetPC : out  STD_LOGIC;
           PCplus1 : out  STD_LOGIC;
           PCplusI : out  STD_LOGIC;
           R0plusI : out  STD_LOGIC;
           R0plus0 : out  STD_LOGIC;
           --Window Pointer
			  WPadd : out STD_LOGIC;
			  WPreset : out STD_LOGIC;
			  Shadow : out  STD_LOGIC);
end component;


signal Right,Left,OpndBus,ALUout,IRout,Address,AddressUnitRSideBus : std_logic_vector (15 downto 0);
signal SRCin,SRZin,SRZout,ALUZout,SRCout,ALUCout : std_logic; 
signal WPout : std_logic_vector (5 downto 0);
signal Laddr, Raddr : std_logic_vector (1 downto 0);

signal ResetPC : STD_LOGIC; 
signal PCplusI: STD_LOGIC; 
signal PCplus1: STD_LOGIC; 
signal R0plusI: STD_LOGIC; 
signal R0plus0: STD_LOGIC; 
signal Rs_on_AddressUnitRSide: STD_LOGIC; 
signal Rd_on_AddressUnitRSide: STD_LOGIC; 
signal EnablePC: STD_LOGIC; 
signal RFLwrite: STD_LOGIC; 
signal RFHwrite: STD_LOGIC;
signal B15to0: STD_LOGIC; 
signal AandB: STD_LOGIC; 
signal AorB: STD_LOGIC; 
signal notB: STD_LOGIC; 
signal shlB: STD_LOGIC; 
signal shrB: STD_LOGIC; 
signal AaddB: STD_LOGIC; 
signal AsubB: STD_LOGIC; 
signal AmulB: STD_LOGIC; 
signal AcmpB: STD_LOGIC;  
signal WPreset: STD_LOGIC;
signal WPadd: STD_LOGIC;
signal IRload: STD_LOGIC; 
signal SRload: STD_LOGIC; 
signal Address_on_Databus: STD_LOGIC; 
signal ALUout_on_Databus: STD_LOGIC; 
signal IR_on_LOpndBus: STD_LOGIC; 
signal IR_on_HOpndBus: STD_LOGIC; 
signal RFright_on_OpndBus: STD_LOGIC; 
		--Status Register
signal CSet: std_logic; 
signal CReset: std_logic; 
signal ZSet: std_logic; 
signal ZReset : std_logic; 
signal Shadow : std_logic;
signal instruction : std_logic_vector (7 downto 0);
signal Cout, Zout, ShadowEn : std_logic;


	
signal Databus,AddressBus : STD_LOGIC_VECTOR(15 downto 0);
signal MemDataReady,clk,ReadMem,WriteMem,External_Reset : STD_LOGIC;

-- Procedure for clock generation
  procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin

    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;
  
begin
	
	MEM : memory port map(clk,ReadMem,WriteMem,AddressBus,Databus,MemDataReady);


	RF : RegisterFile   port map (Databus,clk,WPout,Laddr,Raddr,RFLwrite,RFHwrite,Left,Right);
 
	IR : InstructionRegister port map (Databus,IRload,clk,IRout);
   
	SR : StatusReg  port map (SRCin,SRZin,Cset,Creset,Zset,Zreset,SRload,SRCout,SRZout,clk);
	
	AU : AddressUnit   port map (AddressUnitRSideBus,IRout(7 downto 0),Address,clk,ResetPC,PCplusI,PCplus1,
										  R0plusI,R0plus0,EnablePC);
							
   ALU : ArithmeticUnit  port map (Left,OpndBus,SRCout,B15to0,AandB,AorB,notB,AaddB,AsubB,AmulB,
											  AcmpB,shrB,shlB,ALUout,SRZin,SRCin);
		
	WP  : WindowPointer   port map (clk,IRout(5 downto 0),WPreset,WPadd,WPout);

   
   AddressUnitRSideBus <= Right when Rs_on_AddressUnitRSide='1' else Left when Rd_on_AddressUnitRSide='1' else (others => 'Z');
   
   Addressbus <= Address;
   
   Databus <= Address when Address_on_Databus = '1' else ALUout when ALUout_on_Databus = '1' else (others => 'Z');
   
   OpndBus (7 downto 0) <= IRout (7 downto 0) when IR_on_LOpndBus = '1' else (others => 'Z');

   OpndBus (15 downto 8) <= IRout (7 downto 0) when IR_on_HOpndBus = '1' else (others => 'Z');
   
   OpndBus <= Right when RFright_on_OpndBus = '1' else (others=>'Z');
  
   Zout <= SRZout;

   Cout <= SRCout;
   
   Instruction <= IRout(15 downto 8) when Shadow = '0' else IRout(7 downto 0);
	
   Laddr <= IRout (11 downto 10) when Shadow = '0' else IRout (3 downto 2);

   Raddr <= IRout (9 downto 8) when Shadow = '0' else IRout (1 downto 0);


	cntrl : Controller port map(clk,ShadowEn,External_Reset,MemDataReady,Zout,Cout,Instruction,ReadMem,WriteMem,
			  IRLoad,IR_on_LOpndBus,IR_on_HOpndBus,RFright_on_OpndBus,Rs_on_AddressUnitRSide,Rd_on_AddressUnitRSide,
			  RFLwrite,RFHwrite,B15to0,AandB,AorB,NotB,AaddB,AsubB,AmulB,AcmpB,ShrB,ShlB,ALUout_on_Databus,CSet,CReset,
           ZSet,ZReset,SRLoad,Address_on_Databus,EnablePC,ResetPC,PCplus1,PCplusI,R0plusI,R0plus0,WPadd,WPreset,Shadow);	
	clk_gen(clk,1.000E8);--to geterate the clock for the entire system with period 10ns ; GOOD LUCK
	process
	begin
		External_Reset <= '1';
		wait for 10ns;
		External_Reset <= '0';
		wait for 40000ns;
--		wait for 900ns;
		--finish
	end process;
end Behavioral;

