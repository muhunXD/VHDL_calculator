-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "10/15/2024 17:48:19"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          Calculator
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Calculator_vhd_vec_tst IS
END Calculator_vhd_vec_tst;
ARCHITECTURE Calculator_arch OF Calculator_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_i : STD_LOGIC;
SIGNAL input_switch : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL led_done : STD_LOGIC;
SIGNAL rst_i : STD_LOGIC;
SIGNAL seven_seg_digit_1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL seven_seg_digit_2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL seven_seg_digit_3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL seven_seg_digit_4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL seven_seg_digit_5 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL seven_seg_digit_6 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL start : STD_LOGIC;
COMPONENT Calculator
	PORT (
	clk_i : IN STD_LOGIC;
	input_switch : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	led_done : BUFFER STD_LOGIC;
	rst_i : IN STD_LOGIC;
	seven_seg_digit_1 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	seven_seg_digit_2 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	seven_seg_digit_3 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	seven_seg_digit_4 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	seven_seg_digit_5 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	seven_seg_digit_6 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);
	start : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : Calculator
	PORT MAP (
-- list connections between master ports and signals
	clk_i => clk_i,
	input_switch => input_switch,
	led_done => led_done,
	rst_i => rst_i,
	seven_seg_digit_1 => seven_seg_digit_1,
	seven_seg_digit_2 => seven_seg_digit_2,
	seven_seg_digit_3 => seven_seg_digit_3,
	seven_seg_digit_4 => seven_seg_digit_4,
	seven_seg_digit_5 => seven_seg_digit_5,
	seven_seg_digit_6 => seven_seg_digit_6,
	start => start
	);

-- clk_i
t_prcs_clk_i: PROCESS
BEGIN
LOOP
	clk_i <= '0';
	WAIT FOR 5000 ps;
	clk_i <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk_i;

-- rst_i
t_prcs_rst_i: PROCESS
BEGIN
	rst_i <= '1';
	WAIT FOR 750000 ps;
	rst_i <= '0';
	WAIT FOR 10000 ps;
	rst_i <= '1';
WAIT;
END PROCESS t_prcs_rst_i;
-- input_switch[9]
t_prcs_input_switch_9: PROCESS
BEGIN
	input_switch(9) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_9;
-- input_switch[8]
t_prcs_input_switch_8: PROCESS
BEGIN
	input_switch(8) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_8;
-- input_switch[7]
t_prcs_input_switch_7: PROCESS
BEGIN
	input_switch(7) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_7;
-- input_switch[6]
t_prcs_input_switch_6: PROCESS
BEGIN
	input_switch(6) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_6;
-- input_switch[5]
t_prcs_input_switch_5: PROCESS
BEGIN
	input_switch(5) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_5;
-- input_switch[4]
t_prcs_input_switch_4: PROCESS
BEGIN
	input_switch(4) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_4;
-- input_switch[3]
t_prcs_input_switch_3: PROCESS
BEGIN
	input_switch(3) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_3;
-- input_switch[2]
t_prcs_input_switch_2: PROCESS
BEGIN
	input_switch(2) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_2;
-- input_switch[1]
t_prcs_input_switch_1: PROCESS
BEGIN
	input_switch(1) <= '0';
	WAIT FOR 90000 ps;
	input_switch(1) <= '1';
	WAIT FOR 60000 ps;
	input_switch(1) <= '0';
	WAIT FOR 90000 ps;
	input_switch(1) <= '1';
	WAIT FOR 70000 ps;
	input_switch(1) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_1;
-- input_switch[0]
t_prcs_input_switch_0: PROCESS
BEGIN
	input_switch(0) <= '0';
WAIT;
END PROCESS t_prcs_input_switch_0;

-- start
t_prcs_start: PROCESS
BEGIN
	start <= '1';
	WAIT FOR 50000 ps;
	start <= '0';
	WAIT FOR 20000 ps;
	start <= '1';
	WAIT FOR 40000 ps;
	start <= '0';
	WAIT FOR 10000 ps;
	start <= '1';
	WAIT FOR 70000 ps;
	start <= '0';
	WAIT FOR 10000 ps;
	start <= '1';
	WAIT FOR 70000 ps;
	start <= '0';
	WAIT FOR 10000 ps;
	start <= '1';
	WAIT FOR 70000 ps;
	start <= '0';
	WAIT FOR 10000 ps;
	start <= '1';
	WAIT FOR 80000 ps;
	start <= '0';
	WAIT FOR 10000 ps;
	start <= '1';
WAIT;
END PROCESS t_prcs_start;
END Calculator_arch;
