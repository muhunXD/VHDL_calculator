library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity division is
	generic(N : integer := 4);
	port(
			clk_i, rst_i, Start : in  std_logic;
			A, B                : in  std_logic_vector(N-1 downto 0)   := (others => '0');  -- dividend, divisor
			Quotient				  : out std_logic_vector(N-1 downto 0)   := (others => '0');
			Remainder			  : out std_logic_vector(2*N-1 downto 0) := (others => '0');
			DONE					  : out std_logic := '0';
			Data_A_Status, Data_B_Status : out std_logic_vector(2*N-1 downto 0) := (others => '0');
			Data_Q_Status, dd : out std_logic_vector(N-1 downto 0) := (others => '0')
	);
end entity division;

architecture Behave of division is

	type state_type is (S0,S1);
	signal test : std_logic_vector(N-1 downto 0) := (others => '0');
	signal Data_A       : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal Data_B       : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal Data_quotient, dq: std_logic_vector(N-1 downto 0)   := (others => '0');
	signal state        : state_type := S0;
	signal S_Start      : std_logic  := '0';
	signal A_sign_check, B_sign_check : std_logic_vector(N-1 downto 0);	-- check sign before the process
	signal Data_quotient_int, Data_B_int : integer := 0;

begin

	S_Start <= Start;
	
	process(clk_i, rst_i, Start) is
	begin
		
		if (rst_i = '0') then		-- async, reset (active-high)
			state <= S0;
			Data_A <= (others => '0'); 
			Data_B <= (others => '0');
--			Data_quotient <= (others => '0');
			dq <= (others => '0');
		
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
						Data_A(N-1 downto 0)   <= A_sign_check; -- keep data A that sign was checked
						Data_B(2*N-1 downto N) <= B_sign_check; -- keep data B that sign was checked
--						Data_A_output_debug <= A_sign_check;
--						Data_B_output_debug <= B_sign_check;
						
						
--						Data_A_debug(N-1 downto 0)   <= A_sign_check; -- keep data A that sign was checked
--						Data_B_debug(2*N-1 downto N) <= B_sign_check; -- keep data B that sign was checked	
						
						state 					  <= S1;-- goto S1 when Start bit active
					else
						state <= S0;					 -- non active Start bit goto S1
						DONE 	<= '0';
					end if;
				
				when S1 =>								 -- multiply process
					
					Data_B_int <= conv_integer(std_logic_vector(unsigned(Data_B)));
--					Data_quotient_int <= conv_integer(std_logic_vector(unsigned(Data_quotient)));
					Data_quotient_int <= conv_integer(std_logic_vector(unsigned(dq)));
					
					if (Data_quotient_int <= Data_B_int) then
						
						if (Data_A >= Data_B) then
							Data_A <= Data_A - Data_B;
--							Data_quotient <= Data_quotient + 1;
							test <= test + 1;
							dq <= dq + 1;
							
						end if;
						
						Data_B        <= std_logic_vector(shift_right(unsigned(Data_B), 1));
--						Data_quotient <= std_logic_vector(shift_left(unsigned(Data_quotient), 1));
						dq <= std_logic_vector(shift_left(unsigned(dq), 1));
						
						Data_A_Status <= Data_A;
						Data_B_Status <= Data_B;
--						Data_Q_Status <= Data_quotient;
						Data_Q_Status <= dq;
						dd <= test;
						
					else
						-- result
												 -- last bit check (negative product)
						if (A(N-1) = '1' xor B(N-1) = '1') then -- only one negative
--							Quotient <= not(Data_quotient) + 1;
							Quotient <= not(dq) + 1;
						else
--							Quotient <= Data_quotient;
							Quotient <= dq;
						end if;
						
						Remainder <= Data_A;

						-- result
					
--						Data_quotient <= (others => '0');
						dq <= (others => '0');
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