class Game
  attr_accessor :com, :hum

  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @player_options = ["X", "O"]
    @com = nil # the computer's marker
    @hum = nil # the user's marker
  end

  def game_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
  end

  def choose_player
    puts "Would you like to be X or O?"
    @hum = gets.chomp.upcase
    if @hum.match(/[XO]/)
      @hum = @player_options.delete(@hum)
      @com = @player_options[0]
      puts "Great, you will be #{@hum} and the Computer will be #{@com}"
    else
      choose_player
    end
  end

  def start_game
    #player chooses X or O using choose_player method
    choose_player
    # start by printing the board
    puts game_board
    puts "Enter [0-8] to make the first move:"
    # loop through until the game was won or tied
    until game_is_over(@board) || tie(@board)
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        eval_board
      end
      puts game_board
      puts "Enter [0-8] to make the next move:"
    end
    puts "Game over"
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != @hum && @board[spot] != @com
        @board[spot] = @hum
      else
        spot = nil
        puts "Invalid Entry, please enter [0-8] to make a move:"
        puts game_board
      end
    end
  end

  def eval_board
    spot = get_best_move(@board, @com)
    if @board[spot] != @hum && @board[spot] != "O"
      @board[spot] = @com
    else
      spot = nil
    end
  end

  def get_best_move(board, next_player)
    available_spaces = []
    best_move = nil
    board.each do |space|
      if space != @hum && space != @com
        available_spaces << space
      end
    end
    available_spaces.each do |available_space|
      board[available_space.to_i] = @com
      if game_is_over(board)
        best_move = available_space.to_i
        board[best_move] = available_space
        return best_move
      else
        board[available_space.to_i] = @hum
        if game_is_over(board)
          best_move = available_space.to_i
          board[best_move] = available_space
          return best_move
        else
          board[available_space.to_i] = available_space
        end
      end
    end
    if best_move
      return best_move
    else
      number = rand(0..available_spaces.count)
      return available_spaces[number].to_i
    end
  end

  def game_is_over(board_spaces)

    [board_spaces[0], board_spaces[1], board_spaces[2]].uniq.length == 1 ||
    [board_spaces[3], board_spaces[4], board_spaces[5]].uniq.length == 1 ||
    [board_spaces[6], board_spaces[7], board_spaces[8]].uniq.length == 1 ||
    [board_spaces[0], board_spaces[3], board_spaces[6]].uniq.length == 1 ||
    [board_spaces[1], board_spaces[4], board_spaces[7]].uniq.length == 1 ||
    [board_spaces[2], board_spaces[5], board_spaces[8]].uniq.length == 1 ||
    [board_spaces[0], board_spaces[4], board_spaces[8]].uniq.length == 1 ||
    [board_spaces[2], board_spaces[4], board_spaces[6]].uniq.length == 1
  end

  def tie(board_spaces)
    board_spaces.all? { |space| space == @hum || space == @com }
  end

end

game = Game.new
game.start_game
