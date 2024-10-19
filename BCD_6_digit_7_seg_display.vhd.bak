library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.statetype_package.all;

entity BCD_2_digit_7_seg_display is
    generic(N : integer := 10);                                      	-- genrate 10-bit binary
    port(
        clk_i                    : in std_logic;                     	-- system clock (input)
        rst_i                    : in std_logic;                     	-- button reset (input)
		  state						   : in statetype;							-- state status
		  input_receive				: in std_logic_vector(N-1 downto 0);	-- input displayer
		  Data_mode						: in std_logic_vector(1 downto 0);		-- operation
        result							: in STD_LOGIC_VECTOR(2*N-1 downto 0);	-- addition, subtraction's result
		  product						: in STD_LOGIC_VECTOR(2*N-1 downto 0);	-- multiplication's result
		  quotient						: in STD_LOGIC_VECTOR(N-1 downto 0);	-- division's result
		  remainder						: in STD_LOGIC_VECTOR(2*N-1 downto 0);	-- division's remainder
		  signed_bit_check			: in std_logic;								-- signed bit
		  overflow						: out std_logic := '0';						-- out of range 7-segment displayer
        bcd_digit_1, bcd_digit_2,
		  bcd_digit_3, bcd_digit_4,
		  bcd_digit_5, bcd_digit_6 : out std_logic_vector(3 downto 0)		-- binary decode
    );
end entity BCD_2_digit_7_seg_display;

architecture Behavioral of BCD_2_digit_7_seg_display is

    signal int_digit_1, int_digit_2,
			  int_digit_3, int_digit_4,
			  int_digit_5, int_digit_6					: integer := 0; -- converted input binary to decimal
	 signal int_digit_6_overflow						: integer := 0; -- out of range checker
	 
	 -- input's complement
    signal input_receive_2_com						: std_logic_vector(N-1 downto 0)		:= (others => '0');
	 signal result_2_com 								: std_logic_vector(2*N-1 downto 0)	:= (others => '0');
	 signal product_2_com								: std_logic_vector(2*N-1 downto 0)	:= (others => '0');
	 
	 -- binary decoder to decimal
	 signal data_mode_bit_1, data_mode_bit_0,
			  signed_bit									: std_logic_vector(N-1 downto 0) 	:= (others => '0');

    
begin
    process(clk_i, rst_i)
    begin
        if (rst_i = '0') then                   -- on reset
            int_digit_1 <= 0;
            int_digit_2 <= 0;
				int_digit_3 <= 0;
				int_digit_4 <= 0;
				int_digit_5 <= 0;
            int_digit_6 <= 0;
				
        elsif (clk_i'event and clk_i = '1') then
				case state is
					when s1 | s3 =>
						if (input_receive(N-1) = '0') then                                       -- non-negative data
							 int_digit_1 <= conv_integer(unsigned(input_receive)) mod 10;       	
							 int_digit_2 <= (conv_integer(unsigned(input_receive)) / 10) mod 10 ;  
							 int_digit_3 <= (conv_integer(unsigned(input_receive)) / 100) mod 10 ;
							 int_digit_4 <= (conv_integer(unsigned(input_receive)) / 1000) mod 10;
							 int_digit_5 <= (conv_integer(unsigned(input_receive)) / 10000);		

						else                                                                   -- negative data
							 input_receive_2_com  <= not(input_receive) + 1;                                    
							 int_digit_1 <= conv_integer(unsigned(input_receive_2_com)) mod 10;       		 
							 int_digit_2 <= (conv_integer(unsigned(input_receive_2_com)) / 10)mod 10 ;  
							 int_digit_3 <= (conv_integer(unsigned(input_receive_2_com)) / 100)mod 10 ;
							 int_digit_4 <= (conv_integer(unsigned(input_receive_2_com)) / 1000)mod 10;
							 int_digit_5 <= (conv_integer(unsigned(input_receive_2_com)) / 10000);
						end if;
						signed_bit(0) <= input_receive(N-1);
						int_digit_6 <= conv_integer(unsigned(signed_bit));                        -- signed digit 6
								
					
					when s5 =>
						data_mode_bit_0(0) <= input_receive(0);
						data_mode_bit_1(0) <= input_receive(1);
						int_digit_1 <= conv_integer(unsigned(data_mode_bit_0));
						int_digit_2 <= conv_integer(unsigned(data_mode_bit_1));
						int_digit_3 <= 0;
						int_digit_4 <= 0;
						int_digit_5 <= 0;
						int_digit_6 <= 0;
						
					when s6 =>
						
						case Data_mode is
							when "11" | "10" =>
								if (result(2*N-1) = '0') then                                        -- non-negative data
									 int_digit_1 <= conv_integer(unsigned(result)) mod 10;       		 
									 int_digit_2 <= (conv_integer(unsigned(result)) / 10) mod 10 ; 
									 int_digit_3 <= (conv_integer(unsigned(result)) / 100) mod 10 ;
									 int_digit_4 <= (conv_integer(unsigned(result)) / 1000) mod 10;
									 int_digit_5 <= (conv_integer(unsigned(result))/ 10000);

								else                                                                   -- negative data
									 result_2_com  <= not(result) + 1;                                    
									 int_digit_1 <= conv_integer(unsigned(result_2_com)) mod 10;       	
									 int_digit_2 <= (conv_integer(unsigned(result_2_com)) / 10) mod 10 ;  
									 int_digit_3 <= (conv_integer(unsigned(result_2_com)) / 100) mod 10 ;
									 int_digit_4 <= (conv_integer(unsigned(result_2_com)) / 1000) mod 10;
									 int_digit_5 <= (conv_integer(unsigned(result_2_com)) / 10000);

								end if;
								
								signed_bit(0) <= signed_bit_check;
								int_digit_6 <= conv_integer(unsigned(signed_bit));        -- signed digit 6
								
						
							when "01" =>
								if (product(2*N-1) = '0') then                              -- non-negative data
									 int_digit_1 <= conv_integer(unsigned(product)) mod 10;       		 
									 int_digit_2 <= (conv_integer(unsigned(product)) / 10) mod 10 ;  
									 int_digit_3 <= (conv_integer(unsigned(product)) / 100) mod 10 ;
									 int_digit_4 <= (conv_integer(unsigned(product)) / 1000) mod 10;
									 int_digit_5 <= (conv_integer(unsigned(product)) / 10000) mod 10;
									 int_digit_6_overflow <= conv_integer(unsigned(product)) / 100000;

								else                                                           -- negative data
									 product_2_com  <= not(product) + 1;                               
									 int_digit_1 <= conv_integer(unsigned(product_2_com)) mod 10;       	
									 int_digit_2 <= (conv_integer(unsigned(product_2_com)) / 10)mod 10 ;  
									 int_digit_3 <= (conv_integer(unsigned(product_2_com)) / 100)mod 10 ;
									 int_digit_4 <= (conv_integer(unsigned(product_2_com)) / 1000)mod 10;
									 int_digit_5 <= (conv_integer(unsigned(product_2_com)) / 10000)mod 10;
									 int_digit_6_overflow <= conv_integer(unsigned(product_2_com)) / 100000;

								end if;
								
								signed_bit(0) <= signed_bit_check;
								int_digit_6 <= conv_integer(unsigned(signed_bit));         		-- signed digit 6
								
							when "00" =>
								 signed_bit(0) <= signed_bit_check;
								 int_digit_1 <= conv_integer(unsigned(remainder))mod 10;
								 int_digit_2 <= (conv_integer(unsigned(remainder))/ 10) mod 10;
								 int_digit_4 <= conv_integer(unsigned(quotient))mod 10;
								 int_digit_5 <= (conv_integer(unsigned(quotient))/ 10) mod 10;
								 int_digit_6 <= conv_integer(unsigned(signed_bit));
								 int_digit_6_overflow <= (conv_integer(unsigned(quotient)) / 100);
								 
								 
						when others =>
							int_digit_1 <= 0;
							int_digit_2 <= 0;
							int_digit_3 <= 0;
							int_digit_4 <= 0;
							int_digit_5 <= 0;
							int_digit_6 <= 0;
								 
						end case;
								 
					when others =>
						int_digit_1 <= 0;
						int_digit_2 <= 0;
						int_digit_3 <= 0;
						int_digit_4 <= 0;
						int_digit_5 <= 0;
						int_digit_6 <= 0;
					
					end case;
						
			end if;
			
			if (int_digit_6_overflow > 0) then							-- check out of range 7-segment displayer
				overflow <= '1';
			else
				overflow <= '0';
			end if;
			
    end process;

	 bcd_digit_1 <= conv_std_logic_vector(int_digit_1, 4);      -- convert decimal to binary
    bcd_digit_2 <= conv_std_logic_vector(int_digit_2, 4);
    bcd_digit_3 <= conv_std_logic_vector(int_digit_3, 4);
    bcd_digit_4 <= conv_std_logic_vector(int_digit_4, 4);
    bcd_digit_5 <= conv_std_logic_vector(int_digit_5, 4);
    bcd_digit_6 <= conv_std_logic_vector(int_digit_6, 4);
	 
end architecture Behavioral;
