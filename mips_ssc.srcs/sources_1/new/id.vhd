library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity id is
    Port(
        clk: in std_logic;
        en: in std_logic;
        instruction: in std_logic_vector(25 downto 0);
        wd: in std_logic_vector(31 downto 0);
        RegDst: in std_logic;
        ExtOp: in std_logic; 
        RegWrite: in std_logic;
        Ext_Imm: out std_logic_vector(31 downto 0);
        rd1: out std_logic_vector(31 downto 0);
        rd2: out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0)
        );
end id;

architecture Behavioral of id is


type reg_type is array (0 to 7 ) of std_logic_vector (31 downto 0);
signal reg_array: reg_type := (others => X"00000000");


signal wa: std_logic_vector(4 downto 0);


begin
 wa <= instruction(20 downto 16) when RegDst = '0' else instruction(15 downto 11);
 

 process(clk) 
 begin
 if(rising_edge(clk)) then
   if RegWrite='1' and en = '1' then
       reg_array(conv_integer(wa)) <= wd;
   end if;
 end if;
 end process;


Ext_Imm(15 downto 0) <= instruction(15 downto 0); 

process(ExtOp, instruction) 
 begin
    if(ExtOp = '1') then
       Ext_Imm(31 downto 16) <= (others => instruction(15));
    else 
       Ext_Imm(31 downto 16) <= "0000000000000000";
    end if; 
 end process;



 rd1 <= reg_array(conv_integer(instruction(25 downto 21))); --rs 
 rd2 <= reg_array(conv_integer(instruction(20 downto 16)));   --rt

func <= instruction(5 downto 0);
sa <= instruction(10 downto 6);


end Behavioral;
