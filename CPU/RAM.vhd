-- RAM.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity RAM is
    Port (
        Address       : in  STD_LOGIC_VECTOR(3 downto 0);
        Data_in       : in  STD_LOGIC_VECTOR(7 downto 0);
        Write_enable  : in  STD_LOGIC;
        Clock         : in  STD_LOGIC;
        Data_out      : out STD_LOGIC_VECTOR(7 downto 0)
    );
end RAM;

architecture Behavioral of RAM is
    type memory_array is array (15 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal mem : memory_array := (others => (others => '0')); -- 16x4 RAM
begin
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Write_enable = '1' then
                mem(to_integer(unsigned(Address))) <= Data_in;
            end if;
            Data_out <= mem(to_integer(unsigned(Address)));
        end if;
    end process;
end Behavioral;

