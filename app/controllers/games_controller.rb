require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = ('A'..'Z').to_a.sample(9).join(' ')
    @start_time = Time.now.to_i
  end

  def score
    @score = 0
    @message = ''
    @word = params[:word]
    @grid_passed = params[:grid].split
    @time_passed = Time.at(params[:time].to_i)
    @time = Time.now - @time_passed
    @word.split.each do |letter|
      if @grid_passed.delete(letter)
        @message = "Sorry but #{@word} can not be built out of #{@grid_passed.join(', ')}"
      else
        @grid_passed.delete(letter)
      end
    end
    @word_info = parse(@word)
    if @message == ''
      @message = if @word_info['found']
                   "Congradulations! #{@word} is a valid English word!"
                 else
                   @message = "Sorry but #{@word} does not seem to be a valid English word..."
                 end
    end
    if @message.include? 'Congradulations!'
      @score += 5 if @time < 15
      @score += 10 if @time < 10
      @score += 20 if @time < 5
      @score += 30 if @time < 3
      @score += 5 if @word.length < 4
      @score += 10 if @word.length >= 4 && @word.length < 6
      @score += 30 if @word.length >= 6 && @word.length < 10
    end
  end

  private

  def parse(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)
  end
end
