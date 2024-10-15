library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (
        a, b, c_in : in std_logic;          -- a, b, carry in (input)
        sum        : out std_logic;         -- summation of a and b (output)
        c_out      : out std_logic         -- carry out (output)
    );
end entity full_adder;

architecture data_flow of full_adder is
    
begin
    sum   <= (a xor b) xor c_in;
    c_out <= ((a xor b) and c_in) or (a and b);
    
end architecture data_flow;