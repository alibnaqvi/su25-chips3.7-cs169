class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter == '' || letter.match(/[^a-zA-Z]/)
      raise ArgumentError
    end

    letter = letter.downcase

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.downcase.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

    return true
  end

  def word_with_guesses
    displayed_word = ''

    for char in @word.chars
      if @guesses.include?(char.downcase)
        displayed_word += char
      else
        displayed_word += '-'
      end
    end
  
    return displayed_word
  end

  def check_win_or_lose
    all_guessed = true

    for letter in @word.downcase.chars.uniq
      if not @guesses.include?(letter)
        all_guessed = false

        break
      end
    end

    if all_guessed
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
