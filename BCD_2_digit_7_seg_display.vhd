library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BCD_2_digit_7_seg_display is
    generic(N : integer := 5);                                       -- genrate 5-bit binary
    port(
        clk_i                    : in std_logic;                     -- system clock (input)
        rst_i                    : in std_logic;                     -- button reset (input)
        data_i                   : in std_logic_vector(2*N-1 downto 0);-- data (input)
        bcd_digit_1, bcd_digit_2,
		  bcd_digit_3, bcd_digit_4,
		  bcd_digit_5              : out std_logic_vector(3 downto 0); -- decimal in each digit (output
        bcd_digit_6              : out std_logic                     -- sign digit (output)
    );
end entity BCD_2_digit_7_seg_display;

architecture Behavioral of BCD_2_digit_7_seg_display is

    signal int_digit_1, int_digit_2,
			  int_digit_3, int_digit_4,
			  int_digit_5: integer := 0;            -- converted input binary to decimal
    signal data_2_com : std_logic_vector(2*N-1 downto 0);           -- input's complement
    
begin
    process(clk_i, rst_i)
    begin
        if (rst_i = '0') then                   -- on reset
            int_digit_1 <= 0;
            int_digit_2 <= 0;
				int_digit_3 <= 0;
				int_digit_4 <= 0;
				int_digit_5 <= 0;
            bcd_digit_6 <= '0';

        elsif (clk_i'event and clk_i = '1') then
            if (data_i(2*N-1) = '0') then                                        -- non-negative data
                int_digit_1 <= conv_integer(unsigned(data_i)) mod 10;       		 -- decimal digit 1
                int_digit_2 <= (conv_integer(unsigned(data_i)) / 10)mod 10 ;  -- decimal digit 2
					 int_digit_3 <= (conv_integer(unsigned(data_i)) / 100)mod 10 ;-- decimal digit 3
					 int_digit_4 <= (conv_integer(unsigned(data_i)) / 1000)mod 10;
					 int_digit_5 <= (conv_integer(unsigned(data_i))/ 10000)mod 10 ;		 -- decimal digit 4

            else                                                                   -- negative data
                data_2_com  <= not(data_i) + 1;                                    -- two's complement
                int_digit_1 <= conv_integer(unsigned(data_2_com)) mod 10;       		 -- decimal digit 1
                int_digit_2 <= (conv_integer(unsigned(data_2_com)) / 10)mod 10 ;  -- decimal digit 2
					 int_digit_3 <= (conv_integer(unsigned(data_2_com)) / 100)mod 10 ;-- decimal digit 3
					 int_digit_4 <= (conv_integer(unsigned(data_2_com)) / 1000)mod 10;
					 int_digit_5 <= (conv_integer(unsigned(data_2_com)) / 10000)mod 10 ;

            end if;

            bcd_digit_6 <= data_i(2*N-1);                                     -- sign digit 3

        end if;

        bcd_digit_1 <= conv_std_logic_vector(int_digit_1, 4);      -- convert decimal to binary
        bcd_digit_2 <= conv_std_logic_vector(int_digit_2, 4);
		  bcd_digit_3 <= conv_std_logic_vector(int_digit_3, 4);
		  bcd_digit_4 <= conv_std_logic_vector(int_digit_4, 4);
		  bcd_digit_5 <= conv_std_logic_vector(int_digit_5, 4);

    end process;
end architecture Behavioral;
