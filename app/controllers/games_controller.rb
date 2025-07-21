require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:grid] = @letters
  end

  def score
    if params[:word].blank?
      redirect_to new_path, alert: "Please enter a word before submitting"
      return
    end

    @word = params[:word].upcase
    @grid = session[:grid]

    if @grid.nil?
      redirect_to new_game_path, alert: "Grid expired. Please start new game."
      return
    end

    if !word_in_grid?(@word, @grid)
      @message = "The word can't be build out of the grid"
      @score = 0
    elsif !english_word?(@word)
      @message = "That's a not a valid English word"
      @score = 0
    else
      @message = "Well done! #{helpers.pluralize(@word.length, 'point')} scored."
      @score = @word.length
    end

    session[:total_score] ||= 0
    session[:total_score] += @score
    @total_score = session[:total_score]
  end


  private

  def word_in_grid?(word, grid)
    grid_clone = grid.dup
    word.chars.all? do |letter|
      index = grid_clone.find_index(letter)
      if index.nil?
        false
      else
        grid_clone.delete_at(index)
        true
      end
    end
  end

  def english_word?(word)
    url = "http://wagon-dictionary.herokuapp.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  rescue
    false
  end
end
