#===============================================================================
# Rock Paper Scissors (VXA)
# Author : SirBilly (silentkingdom.com)
# Version : 1.0
# Date : 20 January 2014
#===============================================================================
# Description
#-------------------------------------------------------------------------------
# This script provides the mini-game Rock, Paper, Scissors for your game.
# The players wins and losses are saved to a variable to give you more options 
# to use with in your game. For example you can set up an event that you need so 
# many wins in order for it to start. 
#
#===============================================================================
# Instructions
#-------------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below Materials but above Main.
#
# To open the RPS game scene from an event, you use the following 
#   code in the Script event command.
# 
#   SceneManager.call(SK_RPS_Scene)
#
# All of the configuration is done in the RPS module.
#===============================================================================
module SK
 module RPS
#-------------------------------------------------------------------------------
#  SETUP OPTIONS
#-------------------------------------------------------------------------------
 WELCOME_TEXT = "Lets play some \n Rock Paper Scissors"
  # Text to show whem the scene is opened. \n is the code for a newline.
 WINDOW_SKIN = nil
  # The windowskin to use for the windows "file name". 
  #Located in /Graphics/System/ Set to nil to disable.
 BGM = true
  # Play BGM when scene is opened. 
 MENU_BGM = ["Audio/BGM/Town1", 60, 100]
  # BGM file to play if set to true. file name, volume, and pitch
 BG_COLOR = [0, 0, 0, 200]
  # Set the color for background. rgba(255,255,255,255)
 BACKGROUND = "Actor_RPS"
  # An image used for the background. Located in /Graphics/Pictures/
 BG_X = 0
  # X horizontal value on screen to show background.
 BG_Y = 0
  # Y vertical value on screen to show background.
 ACTOR_VAL = 1  
  # Variable ID. to keep count of your wins.
 COMP_VAL = 2
  # Variable ID. to keep count of the computers wins.
 COST_GOLD = true
  # If set to true you need to pay to play and will display a window for gold.
 GOLD_X = 1
  # X horizontal value on screen to show gold window.
 GOLD_Y = 4
  # Y vertical value on screen to show gold window.
 GOLD_AMOUNT = 10
  # The amount it will cost in order to play if COST_GOLD is ture.
 WIN_AMOUNT = 2
  # The GOLD_AMOUNT to play times WIN_AMOUNT amount. i.e. 10x2 = 20 gold for wining.
 NO_MONEY_TEXT = "You don't have any money \n come back and see me when you do."
  # Text to display if you don't have enough money to play
 NO_MONEY_SE = ["Audio/SE/Buzzer1", 60, 100]
  # SE if yes is clicked when you have no money. file name, volume, and pitch
#-------------------------------------------------------------------------------
# END SETUP
#=============================================================================== 
  end
end
#==============================================================================
# ** SK_RPS_Scene
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================
class SK_RPS_Scene < Scene_MenuBase
  def start
    super
    create_command_window
    create_rps_window
    create_action_window
    create_gold_window if SK::RPS::COST_GOLD
    bgm = SK::RPS::MENU_BGM
    Audio.bgm_play(bgm[0], bgm[1], bgm[2]) if SK::RPS::BGM
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    bgc = SK::RPS::BG_COLOR
    @background_sprite.color.set(bgc[0], bgc[1], bgc[2], bgc[3])
    background
  end
  def background
    @background = Sprite.new
    @background.bitmap = Cache.picture(SK::RPS::BACKGROUND)
    @background.x = SK::RPS::BG_X
    @background.y = SK::RPS::BG_Y
  end
  def dispose_background
    @background_sprite.dispose
    @background.dispose
  end
  def create_rps_window
    @rps_window = SK_RPS_Window.new
	@rps_window.windowskin = Cache.system(SK::RPS::WINDOW_SKIN) unless SK::RPS::WINDOW_SKIN.nil?
    @rps_window.x = 0
    @rps_window.y = Graphics.height - @rps_window.height - 70
  end
  def create_command_window
    @command_window = SK_RPS_Command_Window.new
	@command_window.windowskin = Cache.system(SK::RPS::WINDOW_SKIN) unless SK::RPS::WINDOW_SKIN.nil?
    @command_window.hide.deactivate
    @command_window.set_handler(:rock,     method(:command))
    @command_window.set_handler(:paper,     method(:command))
    @command_window.set_handler(:scissors,    method(:command))
  end
  def create_action_window
    @action_window = SK_RPS_Action_Window.new
    @action_window.x = 410
    @action_window.y = Graphics.height - @rps_window.height - @command_window.height - 20
    @action_window.opacity = 0
    @action_window.activate
    @action_window.select(0)
    @action_window.set_handler(:ok,     method(:yes))
    @action_window.set_handler(:no,   method(:no))
    @action_window.set_handler(:cancel,    method(:return_scene))
  end
  def create_gold_window
    @gold_window = Window_Gold.new
	@gold_window.windowskin = Cache.system(SK::RPS::WINDOW_SKIN) unless SK::RPS::WINDOW_SKIN.nil?
    @gold_window.x = SK::RPS::GOLD_X
    @gold_window.y = SK::RPS::GOLD_Y
  end
  def command
   case @command_window.current_symbol
     when :rock
      $val = 1
      @rps_window.refresh
      @rps_window.run_game
      @command_window.unselect
      @gold_window.refresh if SK::RPS::COST_GOLD
      @command_window.hide
      @action_window.show
      @action_window.activate
      @action_window.select(0)
     when :paper
      $val = 2
      @rps_window.refresh
      @rps_window.run_game
      @command_window.unselect
      @gold_window.refresh if SK::RPS::COST_GOLD
      @command_window.hide
      @action_window.show
      @action_window.activate
      @action_window.select(0)
     when :scissors
      $val = 3
      @rps_window.refresh
      @rps_window.run_game
      @command_window.unselect
      @gold_window.refresh if SK::RPS::COST_GOLD
      @command_window.hide
      @action_window.show
      @action_window.activate
      @action_window.select(0)
     end
   end
  def yes
    if SK::RPS::COST_GOLD != $game_party.gold < SK::RPS::GOLD_AMOUNT
     $game_party.lose_gold(SK::RPS::GOLD_AMOUNT) 
     @action_window.unselect
     @action_window.hide
     @rps_window.refresh
     @rps_window.play_again
     @command_window.show
     @command_window.activate
     @command_window.select(0)
   elsif SK::RPS::COST_GOLD != $game_party.gold > SK::RPS::GOLD_AMOUNT
     Audio.se_stop
     se = SK::RPS::NO_MONEY_SE
     Audio.se_play(se[0], se[1], se[2])
     @rps_window.refresh
     @rps_window.no_money
     @action_window.activate
    else
     @action_window.unselect
     @action_window.hide
     @rps_window.refresh
     @rps_window.play_again
     @command_window.show
     @command_window.activate
     @command_window.select(0)
   end
  end 
  def no
    SceneManager.goto(Scene_Map)
  end
  def terminate
    super()
    dispose_background
    Audio.bgm_fade(5)
  end
end
#==============================================================================
# ** SK_RPS_Window
#------------------------------------------------------------------------------
#  This window displays the play screen.
#==============================================================================
class SK_RPS_Window < Window_Help
  def initialize
    super(3)
    welcome_text
    @options = ["rock", "paper", "scissors"]
  end
  def welcome_text
    draw_text_ex(1, 1, SK::RPS::WELCOME_TEXT)
  end
  def run_game 
    @val = $val
    @r = rand(3) + 1
     
   if @val == @r
	  out_come; draw_text_ex(1, line_height * 2, " It's a Tie, next Throw?")
     if SK::RPS::COST_GOLD
      $game_party.gain_gold(SK::RPS::GOLD_AMOUNT)
     end
   elsif @val == 1 and @r == 3
	  out_come; draw_text_ex(1, line_height * 2, " Rock blunts scissors, you Win. Throw again?"); $game_variables[SK::RPS::ACTOR_VAL] += 1 
     if SK::RPS::COST_GOLD
      $game_party.gain_gold(SK::RPS::GOLD_AMOUNT * SK::RPS::WIN_AMOUNT)
     end
	 elsif @val == 3 and @r == 1
	  out_come; draw_text_ex(1, line_height * 2, " Rock blunts scissors, you Loose. Throw again?"); $game_variables[SK::RPS::COMP_VAL] += 1
	 elsif @val == 3 and @r == 2
	  out_come; draw_text_ex(1, line_height * 2, " Scissors cut paper, you Win. Throw again?"); $game_variables[SK::RPS::ACTOR_VAL] += 1
     if SK::RPS::COST_GOLD
      $game_party.gain_gold(SK::RPS::GOLD_AMOUNT * SK::RPS::WIN_AMOUNT)
     end
   elsif @val == 2 and @r == 3
	  out_come; draw_text_ex(1, line_height * 2, " Scissors cut paper, you Loose. Throw again?"); $game_variables[SK::RPS::COMP_VAL] += 1
	 elsif @val == 2 and @r == 1
	  out_come; draw_text_ex(1, line_height * 2, " Paper covers rock, you Win. Throw again?"); $game_variables[SK::RPS::ACTOR_VAL] += 1
     if SK::RPS::COST_GOLD
      $game_party.gain_gold(SK::RPS::GOLD_AMOUNT * SK::RPS::WIN_AMOUNT)
     end
	 elsif @val == 1 and @r == 2
	  out_come; draw_text_ex(1, line_height * 2, " Paper covers rock, you Loose. Throw again?"); $game_variables[SK::RPS::COMP_VAL] += 1
   end
  end
  def out_come
    computer = @options[@r-1]
    human = @options[@val-1]
    draw_text_ex(1, 1, "I have #{computer}, you have #{human}.")
  end
  def play_again
    human = $game_variables[SK::RPS::ACTOR_VAL]
    computer = $game_variables[SK::RPS::COMP_VAL]
    draw_text_ex(1, 1, "Wins \\C[11]#{human}\\C[0], losses \\C[18]#{computer}\\C[0].")
    draw_text_ex(1, line_height * 2, "Rock-Paper-Scissors")
  end
  def no_money
    draw_text_ex(1, 1, SK::RPS::NO_MONEY_TEXT)
  end
 end
#==============================================================================
# ** SK_RPS_Command_Window
#------------------------------------------------------------------------------
#  This window displays the menu screen.
#==============================================================================
class SK_RPS_Command_Window < Window_HorzCommand
  def initialize
    super(22, 353)
  end
  def window_width
    return Graphics.width - 160
  end
  def window_height
    return 50
  end
  def line_height
    return 42
  end
  def standard_padding
    return 4
  end
  def col_max
    return 3
  end
  def make_command_list
    add_main_commands
  end
  def add_main_commands
    add_command("Rock",   :rock)
    add_command("Paper", :paper)
    add_command("Scissors", :scissors)
  end
end  
#==============================================================================
# ** SK_RPS_Action_Window
#------------------------------------------------------------------------------
#  This window displays secondary menu screen.
#==============================================================================
class SK_RPS_Action_Window < Window_Command
  def initialize
    super(0, 0)
  end
  def window_width
    return 130
  end
  def standard_padding
    return 8
  end
  def make_command_list
    add_main_commands
  end
  def add_main_commands
    add_command("Yes",   :yes)
    add_command("No", :no)
  end
end  