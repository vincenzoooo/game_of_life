class GameBoardController < ApplicationController
  before_action :authenticate_user!

  # Get the initial startup file from the disk
  def setup
    send_file __dir__ + '\..\assets\setup\gol_startup.txt'
  end

  def startup
    if params[:game_config]
      @game_config = GameConfig.new(game_config_params)
      if @game_config.valid?
        @game_config.startup
        @game_board = GameBoard.new(@game_config)
        render "startup"
      else
        render "startup"
      end
    else
      @game_config = GameConfig.new
    end
  end

  def run
    game_board = YAML.load(JSON.parse(params[:game_board]))
    if game_board.configuration.generation > (game_board.configuration.height + game_board.configuration.width)
      render json: { html: false }
      return
    end
    game_board.next_generation!
    render json: { html: render_to_string(partial: 'board_game', locals: {:@game_board => game_board}) }
  end

  private
  def game_config_params
    params.require(:game_config).permit(:attachment)
  end
end
