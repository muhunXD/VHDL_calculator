library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cclt is
  generic ( N : integer := 10);
  port(
    start, clk ,clr          : in std_logic;
    input_switch            : in std_logic_vector(N-1 downto 0);
    result_out           : out std_logic_vector(2*N-1 downto 0);
    remainder_out            : out std_logic_vector(2*N-1 downto 0);
    done               : out std_logic;
    --overflow : out std_logic;
    seven_seg_digit_1, seven_seg_digit_2,
    seven_seg_digit_3, seven_seg_digit_4,
    seven_seg_digit_5, seven_seg_digit_6 : out STD_LOGIC_VECTOR (6 downto 0);
    led_done           : out std_logic := 0;
    );

end cclt;

architecture behave of cclt is

 type statetype is (s0, s1, s2 ,s3 ,s4 ,s5 ,s6);
 --signal data_a,data_b : std_logic_vector(N-1 downto 0) := (others =>'0');
 signal data_r : std_logic_vector(2*N-1 downto 0) := (others =>'0');
 signal state : statetype :=s0;
 signal m : std_logic:='0'; -- will use in subtract
 ---signal v : std_logic:='0'; --case overflow
 signal c : std_logic_vector (N downto 0);
 signal i : integer :=0;
 signal bcheck : integer ;
 signal overflow : std_logic:='0';
 signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_3 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_4 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_5 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_6 : STD_LOGIC_VECTOR (3 downto 0);
 signal Data_A : std_logic_vector( 2*N-1 downto 0 ):= (others => '0');
 signal Data_B : std_logic_vector( N-1 downto 0):= (others => '0');
 signal Data_product : std_logic_vector( 2*N-1 downto 0 ):= (others => '0');
 signal DATA_divisor : std_logic_vector(2*N-1 downto 0) := (others => '0');
 signal DATA_remainder : std_logic_vector(2*N-1 downto 0) := (others => '0');
 signal DATA_quotient : std_logic_vector(N-1 downto 0) := (others => '0');
 signal result,remainder: std_logic_vector(2*N-1 downto 0);
 
 signal Data_mode : std_logic_vector(1 downto 0);
  
begin
 
 process(clk,clr,start)
 begin
 
  if clr = '0' then
   --r <= (others => '0');
   data_a   <= (others => '0');
   data_b   <= (others => '0');
   data_r   <= (others => '0');
   result   <= (others => '0');
   remainder <= (others => '0');
   overflow  <= '0';
   done      <= '0';
   seven_seg_digit_1 <= "1100010";
   seven_seg_digit_2 <= "1100010";
   seven_seg_digit_3 <= "1100010";
   seven_seg_digit_4 <= "0011100";
   seven_seg_digit_5 <= "0011100";
   seven_seg_digit_6 <= "0011100";
   state <= s0;
   
  elsif rising_edge(clk) then
   case state is
   
    when s0 =>
     if (start = '0') then
      state <= s1;
     end if;
      
    when s1 =>
     if (start = '0') then
      Data_A <= input_switch;
      state <= s2;
     else
      result(N-1 downto 0) <= input_switch;
     end if;
     
    when s2 =>
     if (start = '0') then
      state <= s3;
     else
      seven_seg_digit_1 <= "1111111";
      seven_seg_digit_2 <= "1111111";
      seven_seg_digit_3 <= "1111111";
      seven_seg_digit_4 <= "1111111";
      seven_seg_digit_5 <= "1111111";
      seven_seg_digit_6 <= "1111111";
     end if;
     
    when s3 =>
     if (start = '0') then
      Data_B <= input_switch;
      state <= s4;
     else
      result(N-1 downto 0) <= input_switch;
     end if;
     
    when s4 =>
     if (start = '0') then
      state <= s5;
     else
      seven_seg_digit_1 <= "1111111";
      seven_seg_digit_2 <= "1111111";
      seven_seg_digit_3 <= "1111111";
      seven_seg_digit_4 <= "1111111";
      seven_seg_digit_5 <= "1111111";
      seven_seg_digit_6 <= "1111111";
     end if;
     
    when s5 =>
     if (start = '0') then
      Data_mode <= input_switch(1 downto 0);
      state <= s6;
     else
      result <= input_switch;
      seven_seg_digit_3 <= "1111111";
      seven_seg_digit_4 <= "1111111";
      seven_seg_digit_5 <= "1111111";
      seven_seg_digit_6 <= "1111111";
     end if;
     
    when s6
     case Data_mode is
      when "00" =>
      
      when "01" =>
      
      when "10" =>
      
      when "11" =>
     
     
     end case;
   end case;
  end if;
 end process;
 
 result_out <= result;
 remainder_out<= remainder;
 
 convert_binary_result:entity work.BCD_2_digit_7_seg_display(Behavioral)
         port map(
          clk_i => clk,
          rst_i => clr,
          data  => result,
          v => overflow,
          BCD_digit_1 => BCD_data_digit_1,
          BCD_digit_2 => BCD_data_digit_2,
          BCD_digit_3 => BCD_data_digit_3);
          
 convert_binary_remainder:entity work.BCD_2_digit_7_seg_display(Behavioral)
         port map(
          clk_i => clk,
          rst_i => clr,
          data  => remainder,
          v => overflow,
          BCD_digit_1 => BCD_data_digit_4,
          BCD_digit_2 => BCD_data_digit_5,
          BCD_digit_3 => BCD_data_digit_6);
          
 seven_seg_display_1:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_1,
          seven_seg  =>seven_seg_digit_1 );
          
 seven_seg_display_2:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_2,
          seven_seg  =>seven_seg_digit_2 );
          
 seven_seg_display_3:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_3,
          seven_seg  =>seven_seg_digit_3 );
          
 seven_seg_display_4:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_4,
          seven_seg  =>seven_seg_digit_4 );
          
 seven_seg_display_5:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_5,
          seven_seg  =>seven_seg_digit_5 );
          
 seven_seg_display_6:entity work. BDC_to_7_segmen(data_process)
         port map(
          clk_i => clk,
          BCD_i  => BCD_data_digit_6,
          seven_seg  =>seven_seg_digit_6 );
end behave ;