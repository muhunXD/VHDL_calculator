library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.statetype_package.all;

entity bdc_to_7_seg is
    port (
        clk_i     : in std_logic;                       -- system clock (input)
        bcd       : in std_logic_vector(3 downto 0);    -- binary code (input)
        overflow  : in std_logic := '0';                -- overflow (input)
		  digit		: in integer := 0;						  -- digit 1-6
		  state 		: in statetype := s0;					  -- state status
		  Data_mode : in std_logic_vector (1 downto 0);	  -- operation
        seven_seg : out std_logic_vector(6 downto 0)    -- 7-segment decoded (output)
    );
end entity bdc_to_7_seg;

architecture data_process of bdc_to_7_seg is
    
begin
    process(clk_i)
        begin
            if (clk_i'event and clk_i = '1') then
					case state is
						when s0 =>						-- default
							case digit is
								when 1 | 2 | 3 => seven_seg <= "0100011";
								when 4 | 5 | 6 => seven_seg <= "0011100";
								when others => seven_seg <= "0001110";                    -- display F
							end case;
							
						when s2 | s4 =>				-- display nothing
							seven_seg <= "1111111";
							
						when s5 =>						-- oeration mode
							if digit = 2 or digit = 1 then
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
									when others => seven_seg <= "0001110";                    -- display F
								end case;
								
							else
								seven_seg <= "1111111"; -- 7 segment displays notihng
								
							end if;
							
						when s1 | s3 => 				-- input A and B
							if (digit = 6) then
								case bcd is
									when "0000" => seven_seg <= "1111111"; --7-segment display nothing
									when "0001" => seven_seg <= "0111111"; --7-segment display number 1
									when others => seven_seg <= "0001110"; --7-segment display F
								end case;
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
									when others => seven_seg <= "0001110";                    -- display F
								end case;
							end if;

						when s6 =>					-- display
								if (overflow = '1') THEN                       -- overflow
									  seven_seg <= "0001110";                    -- display F
								else
									case Data_mode is
										when "11" | "01" | "10" =>				-- addition / subtraction / multiplication
											if (digit = 6) then
												case bcd is
													when "0000" => seven_seg <= "1111111"; --7-segment display nothing
													when "0001" => seven_seg <= "0111111"; --7-segment display number 1
													when others => seven_seg <= "0001110";                    -- display F
												end case;
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
														when others => seven_seg <= "0001110";                    -- display F
												  end case;
											end if;
											
										when "00" =>								-- division
											case digit is
												when 3 => seven_seg <= "0110110"; --7-segment display =
												when 1 | 2| 4 | 5 =>
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
															when others => seven_seg <= "0001110";                 -- display F
													  end case;
												when 6 =>
													if (bcd = "0000") then
														seven_seg <= "1111111"; --7-segment display nothing
													elsif (bcd = "0001") then
														seven_seg <= "0111111"; --7-segment display number 1
													else
														seven_seg <= "0111000";      -- display F
													end if;
												when others => seven_seg <= "0001110";                    -- display F
											end case;
										
										end case;
									end if;
						
						when others =>
							seven_seg <= "0001110";                    -- display F
							
					end case;	
            end if;
        end process;
end architecture data_process;