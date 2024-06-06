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
	WHILE      = "WHILE",
	DO         = "DO",
	END        = "END",
	DEFINE     = "DEFINE",

	DUP  = "DUP",
	OVER = "OVER",
	DROP = "DROP",
	SWAP = "SWAP",

	EOF = "EOF",
}



local Token = {}

function Token.new(type, value, loc)
	return {
		type=type,
		value=value,
		loc=loc,
		jump_ip=nil,
	}
end



local function Loc(file, line, col)
	return {
		file = file,
		line = line,
		col = col
	}
end


return {
	Token=Token,
	TokenType=TokenType,
	Loc=Loc
}
