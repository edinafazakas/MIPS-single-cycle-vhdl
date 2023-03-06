library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity instructionFetch is
    Port(
        clk: in std_logic;
        en: in std_logic;
        rst: in std_logic;    
        PCsrc : in std_logic;
        jump: in std_logic;
        JumpAddress: in std_logic_vector(31 downto 0);
        BranchAdd: in std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0)
       );
end instructionFetch;

architecture Behavioral of instructionFetch is

 -- opcode(3) rs(3) rt(3) rd(3) sa(1) func(3) - r
 -- opcode(3) rs(3) rt(3) add/imm(7) - i
 -- opcode(3) targetadd(13) - j


 type ROM_type is array (0 to 255) of std_logic_vector(31 downto 0);
 constant rom_data: ROM_type:=(
   B"000000_00000_00000_00001_00000_000000", --add $1,$0,$0     --add $rd, $rs, $rt
   B"000011_00000_00100_0000000000000101", --addi $4,$0,5     --addi $rt, $rs, imm
   B"000011_00000_00110_0000000000000101", --addi $6,$0,5     --lw $rt, offset($rs)
   B"000000_00000_00000_00010_00000_000000", --add $2,$0,$0     --sw $rt, offset($rs)
   B"000000_00000_00000_00101_00000_000000", --add $5,$0,$0
   B"000101_00001_00100_0000000000000110", --beq $1,$4,6
   B"001010_00010_00011_0000000000001010", --lw $3,10($2)
   B"001010_00011_00110_0000000000000001", -- beq,$3,$6,1 
   B"000000_00101_00011_00101_00000_000000", --add $5,$5,$3
   B"000011_00010_00010_0000000000000001", --addi $2,$2,1
   B"000011_00001_00001_0000000000000001", --addi $1,$1,1
   B"001011_00000000000000000000000101", --j 5
   B"000010_00000_00101_0000000000000100", --sw $5,4($0)
   others => X"00000000"
   --suma numerelor diferite dintr-un sir din 3 elemente
   );
   
   signal pc_signal: std_logic_vector(31 downto 0):= (others => '0');
   signal pc_next: std_logic_vector(31 downto 0):= (others => '0');
   signal branch_out: std_logic_vector(31 downto 0):= (others => '0');
   signal jump_out: std_logic_vector(31 downto 0):= (others => '0');

   begin
   
   process(clk, rst)
    begin 
       if(rising_edge(clk)) then
           if(en = '1') then
              pc_signal <= jump_out;      
       
          elsif(rst = '1') then 
              pc_signal <= (others => '0');
          end if;
      end if;      
    end process;  
    
    pc_next <= pc_signal + 1;
    pc <= pc_next;
    instruction <= rom_data(conv_integer(pc_signal(7 downto 0)));
    
    
    branch_out <= pc_next when PCsrc = '0' else BranchAdd;
    jump_out <= branch_out when jump = '0' else JumpAddress;
    
   
end Behavioral;