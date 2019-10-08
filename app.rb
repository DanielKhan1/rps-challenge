require 'sinatra/base'
require_relative 'player.rb'
require_relative 'game.rb'
require_relative 'computer.rb'

class Rockpaperscissors < Sinatra::Base
	enable :sessions

  get '/' do
    erb(:index)
  end

  before do
    @game = Game.load
  end

  post '/name' do
  	player = Player.new(params[:player_name])
  	@game = Game.create(player)
  	redirect to('/rock-paper-scissors')
  end

  get '/rock-paper-scissors' do
  	@player_name = @game.player.name
  	erb(:rock_paper_scissors)
  end

  post '/move' do
  	session[:move] = @game.player.make_move(params[:move])
  	redirect('/winner')
  end

  get '/winner' do
  	@player_name = @game.player.name
  	@player_move = session[:move]
  	@computer_move = Computer.move
  	@winner = @game.winner(@player_move, @computer_move)
  	erb(:winner)
  end

  run! if app_file == $0
end
