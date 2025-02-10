#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
    def initialize(filename)
        begin
            # Need to modify this code so that the program
            # doesn't abend if it can't open the file but rather
            # displays an informative message
            @f = File.open(filename,'r:utf-8')
            
            # Go ahead and read in the first character in the source
            # code file (if there is one) so that you can begin
            # lexing the source code file 
            if (! @f.eof?)
                @c = @f.getc()
            else
                @c = "eof"
                @f.close()
            end
        rescue Errno::ENOENT
            puts "Error: File not found."
            exit
        end
    end
    # Method nextCh() returns the next character in the file
    def nextCh()
        if (! @f.eof?)
            @c = @f.getc()
        else
            @c = "eof"
        end
        
        return @c
    end

    # Method nextToken() reads characters in the file and returns
    # the next token
    def nextToken()
        if @c == "eof"
          puts "Next token is: EOF"
          return Token.new(Token::EOF, "eof")
        elsif (whitespace?(@c))
          str = ""
      
          while whitespace?(@c)
            str += @c
            nextCh()
          end
      
          tok = Token.new(Token::WS, str)
          puts "Next token is: WS, Next Lexeme is: #{str}"
          return tok

         #elsif ...
		 # more code needed here! complete the code here 
		 # so that your scanner can correctly recognize,
		 # print (to a text file), and display all tokens
		 # in our grammar that we found in the source code file
		
		 # FYI: You don't HAVE to just stick to if statements
		 # any type of selection statement "could" work. We just need
		 # to be able to programatically identify tokens that we 
		 # encounter in our source code file.
		
		 # don't want to give back nil token!
		 # remember to include some case to handle
		 # unknown or unrecognized tokens.
		 # below is an example of how you "could"
		 # create an "unknown" token directly from 
		 # this scanner. You could also choose to define
		 # this "type" of token in your token class
        elsif letter?(@c)
          identifier = ""
      
          while letter?(@c) || numeric?(@c)
            identifier += @c
            nextCh()
          end
      
          case identifier
          when "print"
            puts "Next token is: PRINT, Next Lexeme is: #{identifier}"
            return Token.new(Token::PRINT, "print")
          else
            puts "Next token is: ID, Next Lexeme is: #{identifier}"
            return Token.new(Token::ID, identifier)
          end
        elsif numeric?(@c)
          number = ""
      
          while numeric?(@c)
            number += @c
            nextCh()
          end
          puts "Next token is: INT, Next Lexeme is: #{number}"
          return Token.new(Token::INT, number)
        elsif @c == "="
          nextCh()
          puts "Next token is: ASSIGN, Next Lexeme is: ="
          return Token.new(Token::ASSIGN, "=")
        elsif @c == "+"
          nextCh()
          puts "Next token is: ADDOP, Next Lexeme is: +"
          return Token.new(Token::ADDOP, "+")
        elsif @c == "*"
          nextCh()
          puts "Next token is: MULTOP, Next Lexeme is: *"
          return Token.new(Token::MULTOP, "*")
        elsif @c == "/"
          nextCh()
          puts "Next token is: DIVOP, Next Lexeme is: /"
          return Token.new(Token::DIVOP, "/")
        elsif @c == "("
          nextCh()
          puts "Next token is: LPAREN, Next Lexeme is: ("
          return Token.new(Token::LPAREN, "(")
        elsif @c == ")"
          nextCh()
          puts "Next token is: RPAREN, Next Lexeme is: )"
          return Token.new(Token::RPAREN, ")")
        else
          # Handle unknown tokens
          nextCh()
          puts "Next token is: UNKWN, Next Lexeme is: #{@c}"
          return Token.new(Token::UNKWN, @c)
        end
    end
      
end 
#
# Helper methods for Scanner
#
def letter?(lookAhead)
    lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
    lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
    lookAhead =~ /^(\s)+$/
end