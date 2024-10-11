library ieee;
use ieee.std_logic_1164.all;

entity cal_main is 
generic ( N : integer := 10 );
port (	
    clock            : in std_logic;
    reset            : in std_logic;
    start            : in std_logic;
    data_in          : in std_logic_vector(N-1 downto 0); --10x slide switch
    done_na          : out std_logic := '1';
	 aadd					: out std_logic_vector(N-1 downto 0) := (others => '1');
	 bbdd					: out std_logic_vector(N-1 downto 0);
	 aaaa					: out std_logic_vector(N-1 downto 0);
	 bbbb					: out std_logic_vector(N-1 downto 0);
	 dot					: out std_logic_vector(5 downto 0) := (others => '1');
	 state_check		: out std_logic_vector(3 downto 0);
    seven_seg_digit_1: out std_logic_vector(6 downto 0);
    seven_seg_digit_2: out std_logic_vector(6 downto 0);
    seven_seg_digit_3: out std_logic_vector(6 downto 0);
    seven_seg_digit_4: out std_logic_vector(6 downto 0);
    seven_seg_digit_5: out std_logic_vector(6 downto 0);
    seven_seg_digit_6: out std_logic_vector(6 downto 0)
);
end calculator2;

architecture behave of calculator2 is
    -- Declare the components
    component full_add_sub
        port (   
            CLK, RST_N, START: in std_logic;
            a,b              : in std_logic_vector(N-1 downto 0);
            M                : in std_logic;
            C                : out std_logic;
            sum              : out std_logic_vector(N-1 downto 0);
            V                : out std_logic;
            DONE             : out std_logic
        );
    end component;
	 
	 component multiplication
			port (
					CLK, RST_N, START: in std_logic;
					A, B				: in std_logic_vector(N-1 downto 0);
					R					: out std_logic_vector(2*N-1 downto 0);
					DONE				: out std_logic
				  );
	 end component;
	 
	 component division
			port (
					CLK, RST_N, START: in std_logic;
					A, B : in std_logic_vector( N-1 downto 0);
					real_remainder : out std_logic_vector ( 2*N-1 downto 0);
					real_quotient : out std_logic_vector ( N-1 downto 0);
					overflow : out std_logic := '0';
					done : out std_logic := '1'
					);
	 end component;
	 
	 component signbit_check
			port (
					CLK, RST_N, START: in std_logic;
					data_a, data_b	: in std_logic_vector(N-1 downto 0);
					sign_bit			: out std_logic;
					a_out, b_out   : out std_logic_vector(N-1 downto 0)
				  );
    end component;
	 
    component BCD_2_digit_7_seg_display	
        port (
            clk_i, rst_i      : in std_logic;
            data              : in std_logic_vector(N-1 downto 0);
				
				data_mul				: in std_logic_vector(2*N-1 downto 0);
				
				data_remainder : in std_logic_vector(2*N-1 downto 0);
				data_quotient  : in std_logic_vector(N-1 downto 0);
				
				init					: in std_logic;
				dis_op				: in std_logic_vector(1 downto 0);
				sign_bit				: in std_logic;
				overflow_check_add    : in std_logic;
				turn_off				: in std_logic;
            BCD_digit_1       : out std_logic_vector(3 downto 0);
            BCD_digit_2       : out std_logic_vector(3 downto 0);
            BCD_digit_3       : out std_logic_vector(3 downto 0);
            BCD_digit_4       : out std_logic_vector(3 downto 0);
            BCD_digit_5       : out std_logic_vector(3 downto 0);
				BCD_digit_6       : out std_logic_vector(3 downto 0)
        );
    end component;				
    
    component BDC_to_7_segmen
        port (
            clk_i     : in std_logic;
            BCD_i     : in std_logic_vector(3 downto 0);
            seven_seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- State type
    type state_type is (s0, s1, s2, s21, s22, s3, s4, s41, s42, s43, s44, s5);
	 
	 -- Done state
	 signal done_s0     : std_logic := '0';
	 signal done_s1     : std_logic := '0';
	 signal done_s2     : std_logic := '0';
	 signal done_s21     : std_logic := '0';
	 signal done_s22    : std_logic := '0';
	 signal done_s3    : std_logic := '0';
	 signal done_s4     : std_logic := '0';
	 signal done_s41     : std_logic := '0';
	 signal done_s42    : std_logic := '0';
	 signal done_s43    : std_logic := '0';
	 signal done_s44    : std_logic := '0';
	 signal done_s5     : std_logic := '0';
	 
    
    -- Signal declarations
    signal data_show   : std_logic_vector(N-1 downto 0);
	 signal data_a  	  : std_logic_vector(N-1 downto 0);
	 signal data_b  	  : std_logic_vector(N-1 downto 0);
	 signal done		  : std_logic;
	 
	 -- add signal
    signal data_a_add  : std_logic_vector(N-1 downto 0);
    signal data_b_add  : std_logic_vector(N-1 downto 0);
	 signal add_sub  	  : std_logic;
	 signal add_result  : std_logic_vector(N-1 downto 0);
	 signal a_saved     : std_logic;
	 signal b_saved     : std_logic;
	 signal add_done    : std_logic;
	 
	 -- Multiplication signal
	 signal multiplication_result : std_logic_vector(2*N-1 downto 0);
	 signal data_a_mul  : std_logic_vector(N-1 downto 0);
	 signal data_b_mul  : std_logic_vector(N-1 downto 0);
	 signal mul_done    : std_logic;
	 
	 -- Signbit Check
	 signal data_a_sign : std_logic_vector(N-1 downto 0);
	 signal data_b_sign : std_logic_vector(N-1 downto 0);
	 signal data_a_sign_out : std_logic_vector(N-1 downto 0);
	 signal data_b_sign_out : std_logic_vector(N-1 downto 0);
	 signal sign_bit_check : std_logic;
	 
	 -- Division signal
	 signal data_a_divi : std_logic_vector(N-1 downto 0);
	 signal data_b_divi : std_logic_vector(N-1 downto 0);
	 signal remainder_result : std_logic_vector(2*N-1 downto 0);
	 signal quotient_result  : std_logic_vector(N-1 downto 0);
	 signal divi_zero   : std_logic;
	 signal divi_done   : std_logic;
	 -- Signal BCD divi
	 signal bcd_remainder : std_logic_vector(2*N-1 downto 0);
	 signal bcd_quotient  : std_logic_vector(N-1 downto 0);
	 
    signal s_start     : std_logic := '1';
    signal state       : state_type := s0;
	 signal operand     : std_logic_vector(1 downto 0);
	 signal dis_op   	  : std_logic_vector(1 downto 0);
    signal BCD_data_1  : std_logic_vector(3 downto 0);
    signal BCD_data_2  : std_logic_vector(3 downto 0);
    signal BCD_data_3  : std_logic_vector(3 downto 0);
    signal BCD_data_4  : std_logic_vector(3 downto 0);
    signal BCD_data_5  : std_logic_vector(3 downto 0);
	 signal BCD_data_6  : std_logic_vector(3 downto 0);
	 
	 signal operand_check : std_logic_vector(1 downto 0);
	 signal sign_dis_check : std_logic;
	 signal sign_check  : std_logic;
	 signal init_check  : std_logic;
	 signal turn_off_check : std_logic;
	 signal add_overflow	  : std_logic;
	 signal overflow	  : std_logic;
	 signal data_multiplier : std_logic_vector(2*N-1 downto 0);

begin
    -- Correct component instantiation and port mapping
	 adder       : full_add_sub
			port map (
				CLK       => clock,
				RST_N     => reset,
				START     => start,
				a			 => data_a_add,
				b  		 => data_b_add,
				M			 => add_sub,
				sum 		 => add_result,
				V 			 => add_overflow,
				DONE      => add_done
			);
	 
	 multiplication_na : multiplication
			port map (
				CLK 		 => clock,
				RST_N     => reset,
				START     => start,
				A			 => data_a_mul,
				B			 => data_b_mul,
				R         => multiplication_result,
				DONE      => mul_done
			);
			
	 division_na       : division
			port map (
				CLK 		 => clock,
				RST_N     => reset,
				START     => start,
				A			 => data_a_divi,
				B         => data_b_divi,
				real_remainder => remainder_result,
				real_quotient  => quotient_result,
				overflow  => divi_zero,
				done      => divi_done
			);
					
	 sign_bit_check_na : signbit_check
			port map (
				CLK 		 => clock,
				RST_N     => reset,
				START     => start,
				data_a    => data_a_sign,
				data_b    => data_b_sign,
				sign_bit  => sign_bit_check,
				a_out     => data_a_sign_out,
				b_out     => data_b_sign_out
			);
				
	 bcd_display : BCD_2_digit_7_seg_display 
        port map (
            clk_i     => clock, 
            rst_i     => reset, 
            data      => data_show, 
				
				data_mul  => data_multiplier,
				
				data_remainder => bcd_remainder,
				data_quotient  => bcd_quotient,
				
				init      => init_check,
				dis_op    => operand_check,
				sign_bit  => sign_dis_check,
				overflow_check_add => overflow,
				turn_off  => turn_off_check,
            BCD_digit_1 => BCD_data_1,
            BCD_digit_2 => BCD_data_2,
            BCD_digit_3 => BCD_data_3,
            BCD_digit_4 => BCD_data_4,
            BCD_digit_5 => BCD_data_5,
				BCD_digit_6 => BCD_data_6
        );
		  
    segment_1 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_1,
            seven_seg => seven_seg_digit_1
        );	
        
    segment_2 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_2,
            seven_seg => seven_seg_digit_2
        );							
    
    segment_3 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_3,
            seven_seg => seven_seg_digit_3
        );

    segment_4 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_4,
            seven_seg => seven_seg_digit_4
        );	

    segment_5 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_5,
            seven_seg => seven_seg_digit_5
        );

	 segment_6 : BDC_to_7_segmen  
        port map (
            clk_i     => clock,
            BCD_i     => BCD_data_6,
            seven_seg => seven_seg_digit_6
        );

    -- Process block
    process (reset, clock, start)
    begin
        if reset = '0' then
            -- Reset all states and outputs
            data_a <= (others => '0');
            data_b <= (others => '0');
            state      <= s0;
            done       <= '1';
            overflow   <= '0';
				data_show  <= (others => '0');
            
        elsif rising_edge(clock) then
            case state is 
                when s0 =>
							state_check <= "0000";
                    -- Initial display setup
						  

                     if start = '0' then
								 init_check <= '0';
                         state <= s1;
                     else 
                         state <= s0;
						  		 init_check <= '1';
                     end if;
                    
                when s1 =>
							state_check <= "0001";
                    -- Show data input on 7-seg display
                     data_show <= data_in;
							operand_check <= "11";
                    
                     if start = '0' then
                        state <= s2;
								data_a <= data_in;
								aaaa <= data_a;
								
                     else
                         state <= s1;
								 
                     end if;
                
					 when s2 =>
								state_check <= "0010";
								turn_off_check <= '1';
								
								if start = '0' then
									state <= s21;
									turn_off_check <= '0';
								else
									state <= s2;
								end if;
								
					 when s21 =>
								state_check <= "0011";
								data_show <= data_in;
								operand_check <= "11";
								
								if start = '0' then 
									state <= s22;
									data_b <= data_in;
									bbbb <= data_b;
								else
									state <= s21;
									
								end if;
								
					 when s22 =>
								state_check <= "0100";
								turn_off_check <= '1';
								
								if start = '0' then
									state <= s3;
									aadd <= data_a_add;
									bbdd <= data_b_add;
									turn_off_check <= '0';
								else
									state <= s22;
								end if;
					 
					 when s3 =>
								state_check <= "0101";
								data_show <= "00000000" & data_in(1) & data_in(0);
								
								if start = '0' then
									operand <= data_in(1) & data_in(0);
									state <= s4;
								else
									state <= s3;
								end if;
											
					 when s4 =>
								state_check <= "0110";
								case operand is
									when "11" =>
										state <= s41;
									when "10" =>
										state <= s42;
									when "01" =>
										state <= s43;
									when "00" =>
										state <= s44;
									when others =>
										state <= s4;
								end case;
								
					 when s41 =>
								state_check <= "0111";
								data_a_add <= data_a;
								data_b_add <= data_b;
								add_sub <= '0';
								
								if add_done = '0' then
									state <= s5;
								else
									state <= s41;
								end if;
								
					 when s42 =>
								state_check <= "1000";
								data_a_add <= data_a;
								data_b_add <= data_b;
								add_sub <= '1';
								
								if add_done = '0' then 
									state <= s5;
								else
									state <= s42;
								end if;
								
					 when s43 =>
								state_check <= "1001";
								data_a_sign <= data_a;
								data_b_sign <= data_b;
								
								data_a_mul <= data_a_sign_out;
								data_b_mul <= data_b_sign_out;
								
								if mul_done = '0' then
									state <= s5;
								else
									state <= s43;
								end if;
								
					 when s44 =>
								state_check <= "1010";
								data_a_sign <= data_a;
								data_b_sign <= data_b;
					 
								data_a_divi <= data_a_sign_out;
								data_b_divi <= data_b_sign_out;
								
								if divi_done = '0' then
									state <= s5;
								else
									state <= s44;
								end if;
								
					 when s5 =>
								state_check <= "1011";
								case operand is 
								when "11" =>
									if add_overflow = '1' then
										overflow <= '1';
									else
										data_show <= add_result;
										operand_check <= "11";
									end if;
								when "10" =>
									data_show <= add_result;
									operand_check <= "11";
								when "01" =>
									data_multiplier <= multiplication_result;
									operand_check <= "01";
									sign_dis_check <= sign_bit_check;
								when "00" =>
									if divi_zero = '1' then
										overflow <= '1';
									else
										bcd_remainder <= remainder_result;
										bcd_quotient  <= quotient_result;
									end if;
									
										
								when others =>
									state <= s0;
							end case;
									

								
                when others =>
                    state <= s0;
            end case;
        end if;
    end process;

end behave;
