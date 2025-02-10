#
#  Parser Class
#
load "TinyToken.rb"
load "TinyLexer.rb"
class Parser < Lexer

	# Constructor - Is passed a file to parse
	def initialize(filename)
    	super(filename)
		@parseErrors = 0
    	consume()
   	end
   	
	# Reads next token from input and skips whitespace
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	# Verifies that the look ahead token matches the type of the token expected
	# If not, an error message is printed
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
			@parseErrors += 1
      	end
      	consume()
   	end
   	
	# Repeatedly calls the statement rule until the end of file is reached
	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()  
      	end
		# Print the number of parse errors found.
		puts "There were #{@parseErrors} parse errors found."
   	end

	# Parses the EXP rule unless the token is a print token
	# If the token is a print token, the EXP rule is called
	# If the token is not a print token, the ASSGN rule is called
	# Includes the IFOP and WHILEOP token
	def statement()
		if (@lookahead.type == Token::IFOP)
			puts "Entering IF Rule"
			ifStatement()
		elsif (@lookahead.type == Token::WHILEOP)
			puts "Entering WHILE Rule"
			whileStatement()
		elsif (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end
		
		puts "Exiting STMT Rule"
	end

	# Parses the if statement rule
	# if <exp> then <stmt> end
	# Expects an IFOP token, an EXP rule, a THENOP token, a STMT rule, and an ENDOP token
	def ifStatement()
		if (@lookahead.type == Token::IFOP)
			puts "Found IF Token: #{@lookahead.text}"
		end
		match(Token::IFOP)
		puts "Entering EXP Rule"
		exp()
		if (@lookahead.type == Token::THENOP)
			puts "Found THEN Token: #{@lookahead.text}"
		end
		match(Token::THENOP)
		puts "Entering STMT Rule"
		statement()
		if (@lookahead.type == Token::ENDOP)
			puts "Found END Token: #{@lookahead.text}"
		end
		match(Token::ENDOP)
		puts "Exiting IF Rule"
	end

	# Parses the while statement rule
	# while <exp> then <stmt> end
	# Expects a WHILEOP token, an EXP rule, a THENOP token, a STMT rule, and an ENDOP token
	def whileStatement()
		if (@lookahead.type == Token::WHILEOP)
			puts "Found WHILE Token: #{@lookahead.text}"
		end
		match(Token::WHILEOP)
		puts "Entering EXP Rule"
		exp()
		if (@lookahead.type == Token::THENOP)
			puts "Found THEN Token: #{@lookahead.text}"
		end
		match(Token::THENOP)
		puts "Entering STMT Rule"
		statement()
		if (@lookahead.type == Token::ENDOP)
			puts "Found END Token: #{@lookahead.text}"
		end
		match(Token::ENDOP)
		puts "Exiting WHILE Rule"
	end


	# Parses the assignment rule
	# id = <exp>
	# Expects an ID token, an assignment token, and an EXP rule
	def assign()
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
		end
		match(Token::ID)
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		puts "Entering EXP Rule"
		exp()

		puts "Exiting ASSGN Rule"
	end

	# Parses the expression rule
	# <term> {(ADDOP | SUBOP) <term>}
	# Expects a TERM rule and an ETAIL rule
	# Deals with GT and LT tokens
	def exp()
		puts "Entering TERM Rule"
		term()
		if (@lookahead.type == Token::GT || @lookahead.type == Token::LT || @lookahead.type == Token::ANDOP)
			puts "Found #{tokenTypeToString(@lookahead.type)} Token: #{@lookahead.text}"
			consume()
			puts "Entering TERM Rule"
			term()
		end
		puts "Entering ETAIL Rule"
		etail()

		puts "Exiting EXP Rule"
	end

	# Parses the term rule
	# <factor> {(MULTOP | DIVOP) <factor>}
	# Expects a FACTOR rule and a TTAIL rule
	def term()
		puts "Entering FACTOR Rule"
		factor()
		puts "Entering TTAIL Rule"
		ttail()

		puts "Exiting TERM Rule"
	end

	# Parses the factor rule
	# id | int | ( <exp> )
	# Expects an ID token, an INT token, or an LPAREN token
	def factor()
		if @lookahead.type == Token::LPAREN
			puts "Found LPAREN Token: #{@lookahead.text}"
			match(Token::LPAREN)
			puts "Entering EXP Rule"
			exp()
			puts "Found RPAREN Token: #{@lookahead.text}"
			match(Token::RPAREN)
		elsif @lookahead.type == Token::ID
			puts "Found ID Token: #{@lookahead.text}"
			match(Token::ID)
		elsif @lookahead.type == Token::INT
			puts "Found INT Token: #{@lookahead.text}"
			match(Token::INT)
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@parseErrors += 1
		end

		puts "Exiting FACTOR Rule"
	end

	# Parses the ttail rule
	# {(MULTOP | DIVOP) <factor>}
	# Expects a MULTOP token or a DIVOP token and a FACTOR rule
	def ttail()
		if @lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP
			puts "Found #{tokenTypeToString(@lookahead.type)} Token: #{@lookahead.text}"
			consume()
			puts "Entering FACTOR Rule"
			factor()
			puts "Entering TTAIL Rule"
			ttail()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end

		puts "Exiting TTAIL Rule"
	end

	# Parses the etail rule
	# {(ADDOP | SUBOP) <term>}
	# Expects an ADDOP token or a SUBOP token and a TERM rule
	def etail()
		if @lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP
			puts "Found #{tokenTypeToString(@lookahead.type)} Token: #{@lookahead.text}"
			consume()
			puts "Entering TERM Rule"
			term()
			puts "Entering ETAIL Rule"
			etail()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end

		puts "Exiting ETAIL Rule"
	end

	# Converts a token type to a string for the tail methods.
	def tokenTypeToString(token_type)
		case token_type
		when Token::ADDOP
			"ADDOP"
		when Token::MULTOP
			"MULTOP"
		when Token::DIVOP
			"DIVOP"
		when Token::SUBOP
			"SUBOP"
		when Token::LT
			"LT"
		when Token::GT
			"GT"
		when Token::ANDOP
			"ANDOP"
		else
			"UNKNOWN"
		end
	end
end
