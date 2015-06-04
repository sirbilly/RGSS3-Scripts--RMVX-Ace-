#===============================================================================
# Play Time HUD (VXA)
# Author : SirBilly (silentkingdom.com)
# Thanks : Galv ( learned a lot from his scripts ) 
# Version : 1.0
# Date : 12 January 2013
#-------------------------------------------------------------------------------
#  A simple play time window that is displayed on the map screen.
# 
#===============================================================================
# Instructions
#-------------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Materials but above Main.
#===============================================================================
module SK
 module TIME
#-------------------------------------------------------------------------------
#  SETUP OPTIONS
#-------------------------------------------------------------------------------
 # Switch ID. When ON, time window is visible. When OFF its not.
  SWITCH = 5       
 # Windowskin for window. File that is located in /Graphics/System/
  SKIN = "Window"    
 # This allows you to set the opacity of the window skin.
  OPACITY = 255
 # X value on map to draw window.
  X = 8
 # Y value on map to draw window.
  Y = 10
 # Show an icon with the time. 
  ICON_SHOW = true
 # Index number for icon to show if set to true.
  ICON = 280
#-------------------------------------------------------------------------------
# END SETUP
#=============================================================================== 
  end
end
#===============================================================================
# ** Scene_Map
#-------------------------------------------------------------------------------
#  This class performs the map screen processing.
#===============================================================================
class Scene_Map < Scene_Base
alias sirbilly_gametime_create_spriteset      create_spriteset
  def create_spriteset
    sirbilly_gametime_create_spriteset
    @wintime = Window_Time.new 
    @wintime.opacity = SK::TIME::OPACITY
    @wintime.hide if !$game_switches[SK::TIME::SWITCH]
  end
  
alias sirbilly_gametime_update       update
  def update
   hide_time if !$game_switches[SK::TIME::SWITCH]
   show_time if $game_switches[SK::TIME::SWITCH]
    sirbilly_gametime_update
  end
      
  def hide_time
   if @wintime.visible
    @wintime.hide
  end
 end
  
  def show_time
   if !@wintime.visible
    @wintime.show
  end
 end
  
alias sirbilly_gametime_dispose_spriteset        dispose_spriteset
  def dispose_spriteset
    sirbilly_gametime_dispose_spriteset
    @wintime.dispose
  end
end
#===============================================================================
# ** Window_Time
#-------------------------------------------------------------------------------
#  Window used to display time.
#===============================================================================
class Window_Time < Window_Base
  def initialize
    super(SK::TIME::X, SK::TIME::Y, 130, 38)
    self.openness = 255
    self.windowskin = Cache.system(SK::TIME::SKIN)
    create_contents
    refresh
  end
  
  def standard_padding
   return 6
  end

  def refresh
    self.contents.clear
    contents.clear
  if SK::TIME::ICON_SHOW == false
    draw_text(20, 0, contents.width, 25, $game_system.playtime_s)
  elsif SK::TIME::ICON_SHOW == true
    draw_text(35, 0, 126, 25, $game_system.playtime_s)
    draw_icon(SK::TIME::ICON, 5, 0)
    end
  end

  def update
    super
    self.visible = $game_switches[SK::TIME::SWITCH]
    return if !self.visible
    refresh
  end
end