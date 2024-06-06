local TokenType = {
	NUMBER = "NUMBER",
	STRING = "STRING",
	NIL    = "NIL",

	PLUS    = "PLUS",
	MINUS   = "MINUS",
	STAR    = "STAR",
	SLASH   = "SLASH",
	MOD     = "MOD",
	GREATER = "GREATER",
	EQUAL   = "EQUAL",
	NEQUAL  = "NEQUAL",

	IDENTIFIER = "IDENTIFIER",
	SHOW       = "SHOW",
	IF         = "IF",
	ELSE       = "ELSE",
	WHILE      = "WHILE",
	DO         = "DO",
	END        = "END",
	DEFINE     = "DEFINE",
	INCLUDE    = "INCLUDE",

	DUP       = "DUP",
	OVER      = "OVER",
	DROP      = "DROP",
	SWAP      = "SWAP",
	DUMPSTACK = "DUMPSTACK",

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
