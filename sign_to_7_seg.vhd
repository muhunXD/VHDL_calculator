library ieee;
use ieee.std_logic_1164.all;

entity sign_to_7_seg is
     port(
        clk_i 		: in std_logic;                         -- system clock (input) 
        sign_i 	 	: in std_logic;                         -- binary code (input)
        rst_i                    : in std_logic;                     -- button reset (input)
		  overflow    : in std_logic;                         -- binary overflow (input)
        seven_seg   : out std_logic_vector (6 downto 0)     -- 7-segment decoded (output)
        );
end sign_to_7_seg;

architecture data_process of sign_to_7_seg is
begin

  process(clk_i, overflow)                                   -- sensitivity list
	 begin
		if (clk_i'event and clk_i='1') THEN   
            if (overflow = '1') THEN                         -- overflow
                seven_seg <= "1111111";                      -- gfedcba

            else
				case sign_i is                               -- gfedcba
					when '0' => seven_seg <= "1111111";      -- display nothing
					when '1' => seven_seg <= "0111111";      -- display minus sign
					when others => seven_seg <= "0000110";   -- 7-segment display E
				end case;

            end if;
		end if;
	end process;
end data_process;


