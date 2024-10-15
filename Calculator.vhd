library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Calculator is
  generic ( N : integer := 10);
  port(
    start, clk_i ,rst_i          			: in std_logic;
    input_switch            					: in std_logic_vector(N-1 downto 0);

    seven_seg_digit_1, seven_seg_digit_2,
    seven_seg_digit_3, seven_seg_digit_4,
    seven_seg_digit_5, seven_seg_digit_6 	: out STD_LOGIC_VECTOR (6 downto 0);
    led_done           							: out std_logic := '0'
    );

end Calculator;

architecture behave of Calculator is

	 type statetype is (s0, s1, s2 ,s3 ,s4 ,s5 ,s6);
	 signal state 					: statetype 				:=s0;
	 signal state_int 			: integer range 0 to 6	:= 0;

	 signal Data_A 				: std_logic_vector(N-1 downto 0)		:= (others => '0');
	 signal Data_B 				: std_logic_vector(N-1 downto 0)		:= (others => '0');
	 signal Data_mode 			: std_logic_vector(1 downto 0) 		:= (others => '0');
	 signal input_receive      : std_logic_vector(N-1 downto 0)    := (others => '0');
	 
	 signal Data_result 			: std_logic_vector(2*N-1 downto 0) 	:= (others =>'0');
	 signal overflow 				: std_logic									:= '0';
	 signal Data_product 		: std_logic_vector(2*N-1 downto 0)  := (others => '0');
	 signal Data_divisor 		: std_logic_vector(2*N-1 downto 0) 	:= (others => '0');
	 signal Data_remainder 		: std_logic_vector(2*N-1 downto 0) 	:= (others => '0');
	 signal Data_quotient 		: std_logic_vector(N-1 downto 0) 	:= (others => '0');
	 signal done  					: std_logic 								:= '0';
	 signal signed_bit			: std_logic									:= '0';
	 signal start_prev			: std_logic									:= '1';	
	 
	 signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
	 signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
	 signal BCD_data_digit_3 : STD_LOGIC_VECTOR (3 downto 0);
	 signal BCD_data_digit_4 : STD_LOGIC_VECTOR (3 downto 0);
	 signal BCD_data_digit_5 : STD_LOGIC_VECTOR (3 downto 0);
	 signal BCD_data_digit_6 : STD_LOGIC_VECTOR (3 downto 0);
  
begin

	 signed_bit_check:entity work.signed_bit_checker(Behave)
				port map(
					clk_i => clk_i,
					rst_i => rst_i,
					A		=> Data_A,
					B		=> Data_B,
					Data_mode	=> Data_mode,
					signed_bit	=> signed_bit
				);
	

	 full_adder_subtractor_componen:entity work.full_add_sub(Behave)
				port map(
				  a_i      	=> Data_A,
				  b_i      	=> Data_B,
				  Data_mode => Data_mode,
				  result   	=> Data_result
				);
				
	 multiplication_component:entity work.multiplication(Behave)
				port map(
					clk_i			=> clk_i,
					rst_i			=> rst_i,
					Start 		=> start,
					A				=> Data_A,
					B           => Data_B,
					R				=> Data_product
				);
				
	 division_component:entity work.division(Behave)
				port map(
					clk_i			=> clk_i,
					rst_i			=> rst_i,
					Start			=> start,
					A				=> Data_A,
					B          	=> Data_B,
					Quotient		=> Data_quotient,
					Remainder	=> Data_remainder
				);
				
	 convert_binary_result:entity work.BCD_2_digit_7_seg_display(Behavioral)
				port map(
					clk_i 		=> clk_i,
					rst_i 		=> rst_i,
					input_receive => input_receive,
					Data_mode 	=> Data_mode,
					state_int	=> state_int,
					result 		=> Data_result,
					product 		=> Data_product,
					quotient 	=> Data_quotient,
					remainder 	=> Data_remainder,
					signed_bit_check  => signed_bit,
					overflow		=> overflow,
					BCD_digit_1 => BCD_data_digit_1,
					BCD_digit_2 => BCD_data_digit_2,
					BCD_digit_3 => BCD_data_digit_3,
					BCD_digit_4 => BCD_data_digit_4,
					BCD_digit_5 => BCD_data_digit_5,
					BCD_digit_6 => BCD_data_digit_6
				 );
				 
	 seven_seg_display_1:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_1,
				 overflow => overflow,
				 digit => 1,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_1 );
				 
	 seven_seg_display_2:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_2,
				 overflow => overflow,
				 digit => 2,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_2 );
				 
	 seven_seg_display_3:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_3,
				 overflow => overflow,
				 digit => 3,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_3 );
				 
	 seven_seg_display_4:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_4,
				 overflow => overflow,
				 digit => 4,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_4 );
				 
	 seven_seg_display_5:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_5,
				 overflow => overflow,
				 digit => 5,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_5 );
				 
	 seven_seg_display_6:entity work.bdc_to_7_seg(data_process)
				port map(
				 clk_i => clk_i,
				 bcd   => BCD_data_digit_6,
				 overflow => overflow,
				 digit => 6,
				 state_int => state_int,
				 Data_mode => Data_mode,
				 seven_seg  =>seven_seg_digit_6 );
				 
	 led_done <= done;																-- led displays done
 
	 process(clk_i,rst_i,start)
	 begin
	 
		  if (rst_i = '0') then														-- reset
				Data_A   <= (others => '0');
				Data_B   <= (others => '0');
				start_prev <= '1';
				done      <= '0';
				state <= s0;
				state_int <= 0;
			
		  elsif rising_edge(clk_i) then
				case state is
				
				 when s0 =>
					  if (start = '0') then											-- display as default
							state <= s1;
							state_int <= 1;
					  end if;
					
				 when s1 =>
					  if (start = '0' and start_prev = '1') then				-- store input A
							Data_A <= input_switch;
							state <= s2;
							state_int <= 2;
					  else
							input_receive <= input_switch;
					  end if;
				  
					 when s2 =>
					  if (start = '0' and start_prev = '1') then				-- display nothing
							state <= s3;
							state_int <= 3;
					  end if;
				  
				 when s3 =>
					  if (start = '0' and start_prev = '1') then				-- store input B
							Data_B <= input_switch;
							state <= s4;
							state_int <= 4;
					  else
							input_receive <= input_switch;
					  end if;
				  
				 when s4 =>
					  if (start = '0' and start_prev = '1') then				-- display nothing
							state <= s5;
							state_int <= 5;
					  end if;	
				  
				 when s5 =>
					  if (start = '0' and start_prev = '1') then				-- store operation
							Data_mode <= input_switch(1 downto 0);
							state <= s6;
							state_int <= 6;
							done      <= '1';
					  else
							input_receive(1 downto 0) <= input_switch(1 downto 0);
					  end if;
				  
				 when s6 =>
						if (rst_i ='0') then											-- display the result
							state <= s0;
							state_int <= 0;
						end if;
						
				 when others =>
						state <= s0;
						state_int <= 0;
						
				end case;
				
				start_prev <= start;													-- store previous start signal
		  end if;
	 end process;
				 
end behave ;