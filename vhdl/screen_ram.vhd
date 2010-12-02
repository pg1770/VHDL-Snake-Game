--------------------------------------------------------------------------------
-- Module Name:    VRAM - behavioral
--
-- Author: Aaron Storey
-- 
-- Description: This module generates the videoram to store the directional bits for the snake physics
--              and the character rom address data for the display.
-- 
-- 
-- Dependencies: 
-- 
-- 
-- Assisted by:
--
-- Anthonix the great.
-- 
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity screen_ram is
    port (clk50  : in std_logic;
          write_enable_a   : in std_logic;
          enable_a   : in std_logic;
          addr_a : in std_logic_vector(12 downto 0);
			 addr_b : in std_logic_vector(12 downto 0);
          data_input_a   : in unsigned(15 downto 0);
          data_output_a   : out unsigned(15 downto 0);
			 data_output_b   : out unsigned(15 downto 0)
			 );
end screen_ram;


architecture syn of screen_ram is

  type video_ram is array(0 to 8191) of unsigned(15 downto 0);
  
  impure function generate_static_display 
  return video_ram is
    variable temp_ram : video_ram;
  begin
	
    for i in 0 to 79 loop
		for j in 0 to 59 loop
			if (i=0 or i=79 or j=0 or j=59 or j=55) then
				temp_ram(j*80+i) := "0000000000001000"; -- BORDERS
		   elsif (i=2 and j=57) then
				temp_ram(j*80+i) := "0000000110100000"; -- S
			   elsif (i=3 and j=57) then
				temp_ram(j*80+i) := "0000000100100000"; -- C
				elsif (i=4 and j=57) then
				temp_ram(j*80+i) := "0000000110000000"; -- O
				elsif (i=5 and j=57) then
				temp_ram(j*80+i) := "0000000110011000"; -- R
				elsif (i=6 and j=57) then
				temp_ram(j*80+i) := "0000000100110000"; -- E	
				elsif ((i=8 and j=57) or (i=9 and j=57) or (i=10 and j=57) or (i=11 and j=57)) then
				temp_ram(j*80+i) := "0000000011000000"; -- 0		
			   elsif (i=66 and j=57) then
				temp_ram(j*80+i) := "0000000110111000"; -- V
				elsif (i=67 and j=57) then
				temp_ram(j*80+i) := to_unsigned(48*8, 16); -- H
				elsif (i=68 and j=57) then
				temp_ram(j*80+i) := "0000000100101000"; -- D
				elsif (i=69 and j=57) then
				temp_ram(j*80+i) := "0000000101101000"; -- L				
	   		elsif (i=71 and j=57) then
				temp_ram(j*80+i) := "0000000110100000"; -- S
			   elsif (i=72 and j=57) then
				temp_ram(j*80+i) := "0000000101111000"; -- N
				elsif (i=73 and j=57) then
				temp_ram(j*80+i) := "0000000100010000"; -- A
				elsif (i=74 and j=57) then
				temp_ram(j*80+i) := "0000000101100000"; -- K
				elsif (i=75 and j=57) then
				temp_ram(j*80+i) := "0000000100110000"; -- E	
				else
				temp_ram(j*80+i) := "0000000000000000";
		   end if;
		end loop;
    end loop;

    return temp_ram;
  end function;
  
  signal vidram: video_ram := generate_static_display; 
  
  

  
begin


process (clk50)
begin
   if (clk50'event and clk50 = '1') then
      if (enable_a = '1') then
         if (write_enable_a = '1') then
            vidram(to_integer(unsigned(addr_a))) <= data_input_a;
         end if;
         data_output_a <= vidram(to_integer(unsigned(addr_a)));
         data_output_b <= vidram(to_integer(unsigned(addr_b)));
      end if;
   end if;
end process;



end syn;
