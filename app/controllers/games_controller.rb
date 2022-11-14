require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:answer]
    @letters_array = params[:letters].split(' ')

    reponse = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(reponse.read)

    if @word.chars.all? { |letter| @word.count(letter) <= @letters_array.count(letter) } || json['found']
      @answer = "Congratulations! <b>#{@word.upcase}</b> is a valid English word!".html_safe
      @score = @word.length * @word.length
    elsif @word.chars.all? { |letter| @word.count(letter) <= @letters_array.count(letter) } || !json['found']
      @answer = "Sorry but <b>#{@word.upcase}</b> does not seem to be valid English word".html_safe
      @score = @word.length
    else
      @answer = "Sorry but <b>#{@word.upcase}</b> can't be build out of #{@letters}".html_safe
      @score = 0
    end
  end
end
