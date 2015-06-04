=begin
#=============================================================================== 
  Player Turn & Move (For: Khas Pixel Movement)(VXA) 
  Author : SirBilly (silentkingdom.com)
  Version : 1.0
  Date : 9 June 2013
--------------------------------------------------------------------------------
  This Script makes your character turn and face the direction to move before 
  moving in the chosen direction just like in the pokemon games. 
  
  *Overwrites pixel_move_by_input method in Game_Player class.
#===============================================================================
 Instructions
--------------------------------------------------------------------------------
  To install this script, open up your script editor and copy/paste this script
  to an open slot below Khas Pixel Movement script but above Main.
#===============================================================================
 Terms of Use
--------------------------------------------------------------------------------
 * Free to use for both commercial and non-commercial projects.
 * Do not claim this as your own.
 * Crediting me in the game's credits would be appreciated.
#===============================================================================
=end
#===============================================================================
# * Script Configuration *
#===============================================================================
module SK
  module TURNANDMOVE
 #------------------------------------------------------------------------------
 # This is the delay time between the directional keys imput default is 7. 
 #------------------------------------------------------------------------------
  Delay_Time = 7
 #------------------------------------------------------------------------------
 # Note: works best when kept over 5 and under 10.
 #------------------------------------------------------------------------------
  end
 end
#===============================================================================
# * End of Configuration *
#===============================================================================
class Game_Player < Game_Character
#-------------------------------------------------------------------------------
# Frame Update For Wait Time
#-------------------------------------------------------------------------------
 alias sirbilly_turn_and_move_update update
  def update
    sirbilly_turn_and_move_update
    @wait_time = SK::TURNANDMOVE::Delay_Time  unless @wait_time != nil
    @wait_time -= 1 unless @wait_time == 0
  end
#-------------------------------------------------------------------------------
# Movement via Input from Directional Buttons
#-------------------------------------------------------------------------------
   def pixel_move_by_input
    return if !movable? || $game_map.interpreter.running?
      case Input.dir8
	  when 1; move_dpixel(4,2)
      when 2; if Input.trigger?(:DOWN) 
         @wait_time = SK::TURNANDMOVE::Delay_Time 
         set_direction(2)
       elsif @wait_time == 0
         move_pixel(2,true)
        end
	  when 3; move_dpixel(6,2)
      when 4; if Input.trigger?(:LEFT) 
         @wait_time = SK::TURNANDMOVE::Delay_Time 
         set_direction(4)
       elsif @wait_time == 0
         move_pixel(4,true)
        end
      when 6; if Input.trigger?(:RIGHT) 
         @wait_time = SK::TURNANDMOVE::Delay_Time 
         set_direction(6)
       elsif @wait_time == 0
         move_pixel(6,true)
        end
	  when 7; move_dpixel(4,8)
      when 8; if Input.trigger?(:UP) 
         @wait_time = SK::TURNANDMOVE::Delay_Time 
         set_direction(8)
       elsif @wait_time == 0
         move_pixel(8,true)
        end
	  when 9; move_dpixel(6,8)
    end
   end 
 end
#==============================================================================#
#                      http://silentkingdom.com/                               #
#==============================================================================#