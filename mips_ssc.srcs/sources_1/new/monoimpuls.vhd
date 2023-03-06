
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;


entity mpg is
 Port ( en : out std_logic;
        input : in std_logic;
        clock : in std_logic);
 end mpg;

architecture Behavioral of mpg is
signal count : std_logic_vector(31 downto 0) :=x"00000000";
signal Q1 : std_logic := '0';
signal Q2 : std_logic := '0';
signal Q3 : std_logic := '0';
begin
    en <= Q2 AND (not Q3);
    process (clock) 
        begin
            if clock'event and clock = '1' then
                count <= count + 1;
            end if;
   end process;
   
   process (clock)
        begin
            if clock'event and clock='1' then 
                if count(15 downto 0) = "1111111111111111" then 
                    Q1 <= input;
                end if; 
            end if;
    end process;
    
    process (clock)
        begin
            if clock'event and clock='1' then 
                Q2 <= Q1;
            end if;
    end process;
    
    
    process (clock)
        begin
            if clock'event and clock='1' then 
                Q3 <= Q2;
            end if;
    end process;
end Behavioral;
