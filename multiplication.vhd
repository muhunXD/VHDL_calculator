library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity multiplication is
	generic(N : integer := 10);
	port(
			clk_i, rst_i, Start : in  std_logic;
			A, B                : in  std_logic_vector(N-1 downto 0)   := (others => '0');
			R						  : out std_logic_vector(2*N-1 downto 0) := (others => '0');
			DONE					  : out std_logic := '0'
	);
end entity multiplication;

architecture Behave of multiplication is

	type state_type is (S0,S1);
	signal Data_A       : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal Data_B       : std_logic_vector(N-1 downto 0)   := (others => '0');
	signal Data_Product : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal bit_counter  : integer    := 0;
	signal state        : state_type := S0;	
	signal S_Start      : std_logic  := '0';
	
	signal A_sign_check, B_sign_check : std_logic_vector(N-1 downto 0);	-- check sign before the process

begin

	S_Start <= Start;
	
	process(clk_i, rst_i, Start)
	begin
		
		if (rst_i = '0') then		-- async, reset (active-high)
			state <= S0;
			Data_A <= (others => '0');
			Data_B <= (others => '0');
			Data_Product <= (others => '0');
			R <= (others => '0');
		
		elsif rising_edge(clk_i) then
			case state is
				when S0 =>								 				
																			-- signed check
					if ((A(N-1) xor B(N-1)) = '1') then	-- only one negative
						if (A(N-1) = '1') then
							A_sign_check <= not(A) + 1;
						else
							A_sign_check <= A;
						end if;
						if (B(N-1) = '1') then
							B_sign_check <= not(B) + 1;
						else
							B_sign_check <= B;
						end if;
					elsif ((A(N-1) and B(N-1)) = '1') then -- both negative
						A_sign_check <= not(A) + 1;
						B_sign_check <= not(B) + 1;
					else													 -- non-negative
						A_sign_check <= A;
						B_sign_check <= B;
					end if;

				
					if (S_Start = '1') then							-- check start for multiply process
						Data_A(N-1 downto 0)  <= A_sign_check; -- keep data A that sign was checked
						Data_B 					 <= B_sign_check; -- keep data B that sign was checked		
						state 					 <= S1;-- goto S1 when Start bit active
					else
						state <= S0;					 -- non active Start bit goto S1
						DONE 	<= '0';
					end if;
				
				when S1 =>								 -- multiply process
					if (bit_counter < (N+1)) then
						state <= S1;
						
						if (Data_B(bit_counter) = '1') then
							Data_Product <= Data_Product + Data_A;
							Data_A <= std_logic_vector(shift_left(unsigned(Data_A), 1));-- shift_left Data_A 1 bit
							--R <= Data_Product;
							bit_counter <= bit_counter + 1;
							
						else
							Data_A <= std_logic_vector(shift_left(unsigned(Data_A), 1));-- shift_left Data_A 1 bit
							--R <= Data_Product;
							bit_counter <= bit_counter + 1;
						
						end if;
						
						
					else
						-- result
												 -- last bit check (negative product)
						if (A(N-1) = '1' xor B(N-1) = '1') then -- only one negative
							R <= not(Data_Product) + 1;
						else
							R <= Data_Product;
						end if;

						-- result
					
						bit_counter <= 0;
						Data_Product <= (others => '0');
						Data_A <= (others => '0');
						Data_B <= (others => '0');
						state <= S0;
						DONE <= '1';
						
					end if;
					
				when others =>
					state <= S0;
					
			end case;
			
		end if;
		
	end process;

end architecture Behave;