class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].to_s.upcase
    @grid = params[:grid].to_s.split(',')

    if !word_in_grid?(@word, @letters)
      @result = "Sorry, #{@word} can't be builf form #{@letters.join(',')}"
    elsif !english_word?(@word)
      @result = "Sorry, #{@word} is not a valid English word"
    else
      @result = "Congratulations, #{@word} is valid!"
    end
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
