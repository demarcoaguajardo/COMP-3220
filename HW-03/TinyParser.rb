#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        # Creates a new AST node with the token type of "expression"
        expression = term()
        while @lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP
            temp = AST.new(@lookahead)
            match(@lookahead.type)
            temp.addChild(term())
            temp.addChild(expression)
            expression = temp
        end
        return expression
    end

    def term()
        # Creates a new AST node with the token type of "term"
        trm = factor()
        while @lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP
            temp = AST.new(@lookahead)
            match(@lookahead.type)
            temp.addChild(factor()) # Adds the factor result to the term node as a child
            temp.addChild(trm) # Adds the term result to the term node as a child
            trm = temp
        end
        return trm
    end

    def factor()
        # Initialize a new AST node with the token type of "factor"
        fct = AST.new(Token.new("factor","factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            # Creates a new AST node for "expression"
            fct = exp()
            match(Token::RPAREN)
            # # --- I feel like this if and else statement is redundant ---
            # if (@lookahead.type == Token::RPAREN)
            #     match(Token::RPAREN)
            # else
			# 	match(Token::RPAREN)
            # end
            # # -----------------------------------------------------------
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead) # Creates a new AST node with the token type of "INT"
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead) # Creates a new AST node with the token type of "ID"
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return fct
    end

    def ttail()
        # Initialize a new AST node with the token type of "ttail"
        tt = AST.new(Token.new("ttail","ttail"))
        if (@lookahead.type == Token::MULTOP)
            tt = AST.new(@lookahead) # Creates a new AST node with the token type of "MULTOP"
            match(Token::MULTOP)
            tt.addChild(factor()) # Adds the factor result to the ttail node as a child
            tt.addChild(ttail()) # Adds the ttail result to the ttail node as a child
        elsif (@lookahead.type == Token::DIVOP)
            tt = AST.new(@lookahead) # Creates a new AST node with the token type of "DIVOP"
            match(Token::DIVOP)
            tt.addChild(factor()) # Adds the factor result to the ttail node as a child
            tt.addChild(ttail()) # Adds the ttail result to the ttail node as a child
		else
			return nil
        end
        return tt 
    end

    def etail()
        et = AST.new(Token.new("etail","etail")) 
        if (@lookahead.type == Token::ADDOP)
            et = AST.new(@lookahead) # Creates a new AST node with the token type of "ADDOP"
            match(Token::ADDOP)
            et.addChild(term()) # Adds the term result to the etail node as a child
            et.addChild(etail()) # Adds the etail result to the etail node as a child
        elsif (@lookahead.type == Token::SUBOP)
            et = AST.new(@lookahead) # Creates a new AST node with the token type of "SUBOP"
            match(Token::SUBOP)
            et.addChild(term()) # Adds the term result to the etail node as a child
            et.addChild(etail()) # Adds the etail result to the etail node as a child
		else
			return nil
        end
        return et
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end
