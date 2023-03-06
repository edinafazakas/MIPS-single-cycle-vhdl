library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;


entity mem is
    Port(
        clk: in std_logic;
        en: in std_logic;
        MemAddress: in std_logic_vector(31 downto 0);
        MemWrite: in std_logic;
        rd2: in std_logic_vector(31 downto 0);
        MemReadData: out std_logic_vector(31 downto 0);
        ALUres: out std_logic_vector(31 downto 0)
        );
end mem;


architecture Behavioral of mem is
type data_mem is array (0 to 31) of std_logic_vector (31 downto 0);
signal ram: data_mem := (
   X"0000000A",
   X"0000000B",
   X"0000000C",
   X"0000000D",
   X"0000000E",
   X"0000000F",
   X"00000009",
   X"00000008",
   X"00000007",
   X"00000006",
   X"00000005",
   X"00000004",
   X"00000003",
   X"00000002",
   X"00000001",
   others => X"00000000"
  );

begin
 process(clk)
    begin
        if(rising_edge(clk)) then
            if MemWrite='1' and en = '1' then
                ram(conv_integer(MemAddress(31 downto 0))) <= rd2;
            end if;
        end if;
 end process;
 
   
  MemReadData <= ram(conv_integer(MemAddress(31 downto 0))); --when (mem_read='1') else x"0000";
  ALUres <= MemAddress;

end Behavioral;
