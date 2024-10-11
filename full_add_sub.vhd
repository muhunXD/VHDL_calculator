library ieee;
use ieee.std_logic_1164.all;

entity full_add_sub is
    generic(N : integer := 10);                          -- generate 5-bit binary
    port (
        a_i      : in std_logic_vector(N-1 downto 0);   -- a 5-bit binary (input)
        b_i      : in std_logic_vector(N-1 downto 0);   -- b 5-bit binary (input)
        control  : in std_logic;                        -- adder/subtractor controller (input)
        result   : out std_logic_vector(N-1 downto 0);  -- 5-bit binary (output)
        overflow : out std_logic                        -- overflow (output)
    );
end entity full_add_sub;

architecture rtl of full_add_sub is

    signal carry : std_logic_vector(N downto 0);        -- 6-bit carry
    signal b_control : std_logic_vector(N-1 downto 0);  -- controlled b indicate add/sub

begin
    
    carry(0) <= control;                                -- carry in, first_i carry

    fas : for i in 0 to N-1 generate
        
        b_control(i) <= b_i(i) xor control;             -- b controlled before full-adder
        
        fadder : entity work.full_adder(data_flow)      -- full-adder component
            port map (
                a => a_i(i),
                b => b_control(i),
                c_in => carry(i),
                sum => result(i),
                c_out => carry(i+1)
            );

    end generate;
	 
	 overflow <= carry(N) xor carry(N-1);

end architecture rtl;
