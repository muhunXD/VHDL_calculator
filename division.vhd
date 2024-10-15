library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity division is
	generic(N : integer := 10);
	port(
			clk_i, rst_i, Start : in  std_logic;
			A, B                : in  std_logic_vector(N-1 downto 0)   := (others => '0');  -- dividend, divisor
			Quotient				  : out std_logic_vector(N-1 downto 0)   := (others => '0');
			Remainder			  : out std_logic_vector(2*N-1 downto 0) := (others => '0');
			signed_bit			  : out std_logic;
			DONE					  : out std_logic := '0';
			-- for debugging
			Data_A_Status, Data_B_Status : out std_logic_vector(2*N-1 downto 0) := (others => '0');
			Data_Q_Status : out std_logic_vector(N-1 downto 0) := (others => '0')
	);
end entity division;

architecture Behave of division is

	type state_type is (S0,S1);
	
	signal state        : state_type := S0;
	signal S_Start      : std_logic  := '0';
	signal A_sign_check, B_sign_check : std_logic_vector(N-1 downto 0);	-- check sign before the process
	signal Data_remainder, Data_divisor : std_logic_vector(2*N-1 downto 0)
;	signal Data_quotient: std_logic_vector(N-1 downto 0)   := (others => '0');
	signal bit_counter : integer := 0;

begin

	S_Start <= Start;
	
	process(clk_i, rst_i, Start) is
	
--	variable Data_quotient: std_logic_vector(N-1 downto 0)   := (others => '0');
	
	begin
		
		if (rst_i = '0') then		-- async, reset (active-high)
			state <= S0;
			Data_remainder <= (others => '0'); 
			Data_divisor <= (others => '0');
			Data_quotient <= (others => '0');
			bit_counter <= 0;
			signed_bit <= '0';
		
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
						Data_remainder(N-1 downto 0)   <= A_sign_check; -- keep data A that sign was checked
						Data_divisor(2*N-1 downto N) <= B_sign_check; -- keep data B that sign was checkeก
						state 					  <= S1;-- goto S1 when Start bit active
					else
						state <= S0;					 -- non active Start bit goto S1
						DONE 	<= '0';
					end if;
					
				when S1 =>								 -- multiply process
					
					Data_A_Status <= Data_remainder;	
					Data_B_Status <= Data_divisor;
					Data_Q_Status <= Data_quotient;
					
					if (bit_counter < (N+1)) then
						if (Data_remainder < Data_divisor) then
							Data_quotient <= std_logic_vector(shift_left(unsigned(Data_quotient), 1));
							Data_divisor        <= std_logic_vector(shift_right(unsigned(Data_divisor), 1));
						else
							Data_remainder <= Data_remainder - Data_divisor;
							Data_divisor        <= std_logic_vector(shift_right(unsigned(Data_divisor), 1));
							Data_quotient <= std_logic_vector(shift_left(unsigned(Data_quotient), 1));
							Data_quotient(0) <= '1';
						end if;
						bit_counter <= bit_counter+1;
					else
						if ((A(N-1) = '1' xor B(N-1) = '1')) then -- only one negative
							signed_bit <= '1';
						end if;
						
						Quotient <= Data_quotient;
						Remainder <= Data_remainder;
						
						Data_quotient <= (others => '0');
						Data_remainder <= (others => '0');
						Data_divisor <= (others => '0');
						state <= S0;
						DONE <= '1';
						bit_counter <= 0;	
					end if;
					
				when others =>
					state <= S0;
					
			end case;
			
		end if;
		
	end process;

end architecture Behave;