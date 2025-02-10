# Load the TinyToken class
load "TinyToken.rb"

# Create instances of TinyToken and test methods
token1 = Token.new(Token::ID, "variable")
token2 = Token.new(Token::INT, "123")
token3 = Token.new(Token::PRINT, "print")
token4 = Token.new(Token::ASSIGN, "=")

# Test get_type and get_text methods
puts "Token 1 Type: #{token1.get_type}, Text: #{token1.get_text}"
puts "Token 2 Type: #{token2.get_type}, Text: #{token2.get_text}"
puts "Token 3 Type: #{token3.get_type}, Text: #{token3.get_text}"
puts "Token 4 Type: #{token4.get_type}, Text: #{token4.get_text}"

# Test to_s method
puts "Token 1: #{token1}"
puts "Token 2: #{token2}"
puts "Token 3: #{token3}"
puts "Token 4: #{token4}"
