library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_add_sub is
    generic(N : integer := 10);                         -- generate 5-bit binary
    port (
        a_i      : in std_logic_vector(N-1 downto 0);   -- a 5-bit binary (input)
        b_i      : in std_logic_vector(N-1 downto 0);   -- b 5-bit binary (input)
        Data_mode: in std_logic_vector(1 downto 0);     -- adder/subtractor controller (input)
        result   : out std_logic_vector(2*N-1 downto 0);-- 5-bit binary (output)
		  signed_bit: out std_logic := '0';
        overflow : out std_logic                        -- overflow (output)
    );
end entity full_add_sub;

architecture Behave of full_add_sub is

    signal carry : std_logic_vector(2*N downto 0);        -- 21-bit carry
    signal b_control : std_logic_vector(2*N-1 downto 0);  -- controlled b indicate add/sub
	 signal control : std_logic := '1';
	 signal Data_A, Data_B : std_logic_vector(2*N-1 downto 0);

begin
	 Data_A <= std_logic_vector(resize(signed(a_i), Data_A'length));	-- resize 10-bit to 20-bit
	 Data_B <= std_logic_vector(resize(signed(b_i), Data_B'length));
	 
	 process(Data_mode)
		begin
			if (Data_mode = "11") then
				control <= '0';
				
			elsif (Data_mode = "10") then
				control <= '1';
				
			end if;
	 end process;
	  
    carry(0) <= control;                                -- carry in, first_i carry

    fas : for i in 0 to 2*N-1 generate
        b_control(i) <= Data_B(i) xor control;
        fadder : entity work.full_adder(data_flow)      -- full-adder component
            port map (
                a => Data_A(i),
                b => b_control(i),
                c_in => carry(i),
                sum => result(i),
                c_out => carry(i+1)
            );
    end generate;
				
	 overflow <= carry(N) xor carry(N-1);

end architecture Behave;
