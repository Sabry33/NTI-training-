-- Decoder.vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(7 downto 0);
        ALU_Op     : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
begin
    process (Instruction)
    begin
        ALU_Op <= Instruction(7 downto 5); -- Assuming opcode is in bits [7:5]
    end process;
end Behavioral;
