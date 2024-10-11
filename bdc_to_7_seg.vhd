library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bdc_to_7_seg is
    port (
        clk_i     : in std_logic;                       -- system clock (input)
        bcd       : in std_logic_vector(3 downto 0);    -- binary code (input)
		  rst_i     : in std_logic;                     -- button reset (input)
        overflow  : in std_logic;                       -- overflow (input)
        seven_seg : out std_logic_vector(6 downto 0)    -- 7-segment decoded (output)
    );
end entity bdc_to_7_seg;

architecture data_process of bdc_to_7_seg is
    
begin
    process(clk_i)
        begin
            if (clk_i'event and clk_i = '1') then
                if (overflow = '1') THEN                       -- overflow
                    seven_seg <= "0111000";                    -- display F
                else
                    case bcd is
                        when "0000" => seven_seg <= "1000000"; --7-segment display number 0
                        when "0001" => seven_seg <= "1111001"; --7-segment display number 1
                        when "0010" => seven_seg <= "0100100"; --7-segment display number 2
                        when "0011" => seven_seg <= "0110000"; --7-segment display number 3
                        when "0100" => seven_seg <= "0011001"; --7-segment display number 4 
                        when "0101" => seven_seg <= "0010010"; --7-segment display number 5
                        when "0110" => seven_seg <= "0000010"; --7-segment display number 6
                        when "0111" => seven_seg <= "1111000"; --7-segment display number 7
                        when "1000" => seven_seg <= "0000000"; --7-segment display number 8
                        when "1001" => seven_seg <= "0010000"; --7-segment display number 9
                        when others => seven_seg <= "0000110"; --7-segment display E
                    end case;
				end if;
            end if;
        end process;
    
    
    
end architecture data_process;