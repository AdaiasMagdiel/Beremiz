local TokenType = {
	NUMBER = "NUMBER",
	STRING = "STRING",

	PLUS    = "PLUS",
	MINUS   = "MINUS",
	STAR    = "STAR",
	SLASH   = "SLASH",
	GREATER = "GREATER",
	EQUAL   = "EQUAL",
	MOD     = "MOD",

	IDENTIFIER = "IDENTIFIER",
	SHOW       = "SHOW",
	IF         = "IF",
	ELSE       = "ELSE",
	DUP        = "DUP",
	WHILE      = "WHILE",
	DO         = "DO",
	END        = "END",

	OVER = "OVER",
	DROP = "DROP",
	SWAP = "SWAP",

	EOF = "EOF",
}



local Token = {}

function Token.new(type, value)
	return {
		type=type,
		value=value,
		ip_end=nil
	}
end



return {
	Token=Token,
	TokenType=TokenType
}
