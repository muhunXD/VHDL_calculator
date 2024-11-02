library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity signed_bit_detector is
	generic(N : integer := 10);
	port(
		clk_i, rst_i	: in std_logic;
		A, B : in std_logic_vector(N-1 downto 0);
		Data_mode		: in std_logic_vector(1 downto 0);
		signed_bit		: out std_logic
	);
	
end entity;

architecture Behave of signed_bit_detector is


begin
	process(clk_i, rst_i) is
	begin
		if rst_i = '0' then
			signed_bit <= '0';
			
		elsif rising_edge(clk_i) then
			
			case Data_mode is
				when "11" =>							-- addition
					if (A(N-1) = '0' and B(N-1) = '0') then	-- all non-negative
						signed_bit <= '0';

					elsif A(N-1) = '1' and B(N-1) = '1' then	-- all negative
						signed_bit <= '1';
						
					else													-- only one negative
						if A >= B then
							signed_bit <= A(N-1);
							
						else
							signed_bit <= B(N-1);
							
						end if;
					end if;

				when "10" =>							-- subtraction
					if A(N-1) = B(N-1) then							-- same MSB
                    if unsigned(A(N-2 downto 0)) >= unsigned(B(N-2 downto 0)) then  -- abs(A) >= abs(B)
                        signed_bit <= '0';  														-- non-negative
								
                    else
                        signed_bit <= '1';  														-- negative
								
                    end if;
                else
                    signed_bit <= A(N-1);								-- Different signs, A's sign dominates
						  
                end if;
							
				when "01" | "00" =>					-- multiplication, division
					if (A(N-1) = '1' xor B(N-1) = '1') then
						signed_bit <= '1';
					else
						signed_bit <= '0';
					end if;
				
				when others => signed_bit <= '0';
				
			end case;
		end if;
	end process;
end Behave;