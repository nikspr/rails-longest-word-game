require 'open-uri'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    dictionary_serialized = URI.open(url).read
    result = JSON.parse(dictionary_serialized)

    score = 0
    message = nil
    time = (@end_time - @start_time).round(2)

    if params[:word].upcase.chars.all? { |letter| params[:word].upcase.chars.count(letter) <= @letters.upcase.chars.count(letter) } == false
      message = "Wrooooooong, you can't write #{params[:word]} from #{@letters.gsub(',', '').split(/ */).join(', ')}"
    elsif result["found"]
      message = "well done"
      score = (params[:word].length * 3 / time).round(2)
    else
      message = "Buuuh, that's not an English word"
    end

    @result = { score: score, message: message, time: time }
  end
end
