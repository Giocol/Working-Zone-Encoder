----------------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineer: Giorgio Colomban, Stefan Djokovic  
-- 
-- Create Date: 08/27/2020 11:28:54 AM
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: Prova Finale di Reti Logiche
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
    port (
        i_clk: in std_logic;
        i_start: in std_logic;
        i_rst: in std_logic;
        i_data: in std_logic_vector(7 downto 0);
        o_address: out std_logic_vector(15 downto 0);
        o_done: out std_logic;
        o_en: out std_logic;
        o_we: out std_logic;
        o_data: out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state is (INIT0, INIT1, INIT2, INIT3, INIT4, INIT5, INIT6, INIT7, END_INIT, RESET, START, WZ_CHECK, WZ_DECIDE, WZ_CALC_OFF, WZ_WRITE, WZ_DONE, NO_WZ_WRITE, NO_WZ_DONE);
    constant WZ_0: std_logic_vector(15 downto 0):= "0000000000000000";
    constant WZ_1: std_logic_vector(15 downto 0):= "0000000000000001";
    constant WZ_2: std_logic_vector(15 downto 0):= "0000000000000010"; 
    constant WZ_3: std_logic_vector(15 downto 0):= "0000000000000011"; 
    constant WZ_4: std_logic_vector(15 downto 0):= "0000000000000100"; 
    constant WZ_5: std_logic_vector(15 downto 0):= "0000000000000101"; 
    constant WZ_6: std_logic_vector(15 downto 0):= "0000000000000110"; 
    constant WZ_7: std_logic_vector(15 downto 0):= "0000000000000111"; 
    constant ADDR_IN: std_logic_vector(15 downto 0):= "0000000000001000";
    constant ADDR_OUT: std_logic_vector(15 downto 0):= "0000000000001001";
    constant WZ_SIZE: unsigned(7 downto 0) := "00000011";
    
    signal next_state: state := RESET;
    signal curr_state: state := RESET;
    signal WZ_0_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_1_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_2_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_3_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_4_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_5_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_6_START: std_logic_vector(7 downto 0):= "00000000";
    signal WZ_7_START: std_logic_vector(7 downto 0):= "00000000";
    signal CURR_WZ: std_logic_vector(7 downto 0):= "00000000";  
    signal WZ_NUM: std_logic_vector(2 downto 0) := "000";       
    signal WZ_BIT: std_logic := '0';
    signal WZ_OFF: std_logic_vector(3 downto 0) := "0000";
    
begin

    --Updates the FSM state every clock cycle (on the rising edge of the clock signal
   FSM_state_update: process(i_clk, i_rst)
   begin
       if(i_rst = '1') then
           curr_state <= RESET;
       elsif rising_edge(i_clk) then
          curr_state <= next_state;
       end if;
    end process;
    
    FSM_state_sequence: process(i_data, i_start, curr_state)
    begin
            case curr_state is
                when INIT0 =>
                    next_state <= INIT1;
                when INIT1 =>
                    next_state <= INIT2;
                when INIT2 =>
                    next_state <= INIT3;
                when INIT3 =>
                    next_state <= INIT4;
                when INIT4 =>
                    next_state <= INIT5;
                when INIT5 =>
                    next_state <= INIT6;
                when INIT6 =>
                    next_state <= INIT7;                                                                                                                     
                when INIT7 =>
                    next_state <= END_INIT;
                when END_INIT =>
                    next_state <= START;
                when RESET =>
                    if i_start = '1' then
                        next_state <= INIT0;
                    else
                        next_state <= RESET;
                    end if;
                when START =>
                        next_state <= WZ_CHECK;
                when WZ_CHECK =>
                         next_state <= WZ_DECIDE;
                when WZ_DECIDE =>
                    if WZ_BIT = '0' then
                        next_state <= NO_WZ_WRITE;
                    elsif WZ_BIT = '1' then
                        next_state <= Wz_CALC_OFF;
                     end if;                
                when NO_WZ_WRITE =>
                    next_state <= NO_WZ_DONE;
                when NO_WZ_DONE =>
                    next_state <= RESET;
                when WZ_CALC_OFF =>
                    next_state <= WZ_WRITE;
                when WZ_WRITE =>
                    next_state <= WZ_DONE;
                when WZ_DONE =>
                    next_state <= RESET;
            end case;
     end process;
     
    
    MAIN: process(i_clk)
    variable DATA: std_logic_vector(7 downto 0) := "00000000";
    variable WZ_DIFF: unsigned(7 downto 0) := "00000000";
    begin
        if falling_edge(i_clk) then
            case curr_state is
                when INIT0 =>
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_0;
               when INIT1 =>
                    WZ_0_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_1;
                when INIT2 =>
                    WZ_1_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_2;
                when INIT3 =>
                    WZ_2_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_3;
                when INIT4 =>
                    WZ_3_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_4;  
                when INIT5 =>
                    WZ_4_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_5;
                when INIT6 =>
                    WZ_5_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_6;  
                when INIT7 =>
                    WZ_6_START <= i_data;
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= WZ_7;
                when END_INIT =>
                    WZ_7_START <= i_data;
                    o_en <= '0';
                    o_we <= '0';
                when RESET =>
                    o_done <= '0';
                when START =>
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= ADDR_IN;
                when WZ_CHECK =>
                    DATA := i_data;
                    if (unsigned(DATA) - unsigned(WZ_0_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_0_START));
                        WZ_NUM <= "000";
                        WZ_BIT <= '1';
                    elsif (unsigned(DATA) - unsigned(WZ_1_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_1_START));                        
                        WZ_NUM <= "001";
                        WZ_BIT <= '1';                    
                    elsif (unsigned(DATA) - unsigned(WZ_2_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_2_START));                    
                        WZ_NUM <= "010";
                        WZ_BIT <= '1';  
                    elsif (unsigned(DATA) - unsigned(WZ_3_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_3_START));                    
                        WZ_NUM <= "011";
                        WZ_BIT <= '1';  
                     elsif (unsigned(DATA) - unsigned(WZ_4_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_4_START));                     
                        WZ_NUM <= "100";
                        WZ_BIT <= '1';  
                    elsif (unsigned(DATA) - unsigned(WZ_5_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_5_START));                    
                        WZ_NUM <= "101";
                        WZ_BIT <= '1';  
                    elsif (unsigned(DATA) - unsigned(WZ_6_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_6_START));                    
                        WZ_NUM <= "110";
                        WZ_BIT <= '1';  
                    elsif (unsigned(DATA) - unsigned(WZ_7_START)) <= WZ_SIZE then
                        WZ_DIFF := (unsigned(DATA) - unsigned(WZ_7_START));
                        WZ_NUM <= "111";
                        WZ_BIT <= '1';  
                    else 
                        WZ_BIT <= '0';                                                                                                                                               
                    end if;
                when WZ_DECIDE =>
                    o_en <= '0'; --NO
                when NO_WZ_WRITE =>
                    o_en <= '1';
                    o_we <= '1';
                    o_address <= ADDR_OUT;
                    o_data <= WZ_BIT & DATA(6 downto 0);
                when NO_WZ_DONE =>
                    o_en <= '0';
                    o_we <= '0';
                    o_done <= '1';
                when WZ_CALC_OFF =>
                    if WZ_DIFF =  "00000000" then 
                        WZ_OFF <= "0001";
                    elsif WZ_DIFF = "00000001" then
                        WZ_OFF <= "0010";
                    elsif WZ_DIFF = "00000010" then
                        WZ_OFF <= "0100";
                    elsif WZ_DIFF = "00000011" then
                        WZ_OFF <= "1000";
                    end if;                                                    
                when WZ_WRITE =>
                    o_en <= '1';
                    o_we <= '1';
                    o_address <= ADDR_OUT;
                    o_data <= WZ_BIT & WZ_NUM & WZ_OFF;                    
                when WZ_DONE =>  
                    o_en <= '0';
                    o_we <= '0'; 
                    o_done <='1';
            end case;
        end if;
    end process;
    
end Behavioral;
