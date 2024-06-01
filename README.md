# Beremiz

Beremiz is a fun, experimental language based on the stack-based principles of [Porth](https://gitlab.com/tsoding/porth), created by [Alexey Kutepov](https://twitch.tv/tsoding). While Beremiz is designed to be playful and educational, it's not intended for serious programming. Its performance is limited because it runs on top of Lua, making it relatively slow.

The name Beremiz is inspired by the character [Beremiz Samir](https://en.wikipedia.org/wiki/Beremiz_Samir), known as "The Man Who Counted." He was created by [Júlio César de Mello e Souza](https://en.wikipedia.org/wiki/J%C3%BAlio_C%C3%A9sar_de_Mello_e_Souza), a Brazilian teacher and writer better known as Malba Tahan.

## Getting Started

### Prerequisites

Ensure you have Lua installed on your system. You can download it from the [official Lua website](https://www.lua.org/download.html).

### Installation

Clone this repository locally:

```bash
git clone https://github.com/AdaiasMagdiel/beremiz.git
cd beremiz
```

### Running Beremiz Code

There are two ways to run Beremiz code:

- Using the REPL:
  ```bash
  lua main.lua
  ```

- Passing a file:
  ```bash
  lua main.lua [file]
  ```

You can find some example files in the `examples` folder to get started.

## Get Into the Code

### Hello, World!

A simple "Hello, World!" program in Beremiz looks like this:

```beremiz
"Hello, world!" show
```

### Comments

For single-line comments, use `#`:

```beremiz
1 3 +  # Sum 1 and 3
show   # Print the result
```

For multi-line comments, use `#[ comment ]#`:

```beremiz
"Hello!"

#[
This
is
a
multi-line
comment
]#

show
```

### Arithmetic Operations

Beremiz is a stack-based language, meaning operators appear after the operands. Beremiz supports the following operators:

- `+` - Takes two operands and performs addition.
- `-` - Takes two operands and performs subtraction.
- `*` - Takes two operands and performs multiplication.
- `/` - Takes two operands and performs division.
- `>` - Takes two operands and compares them.
- `=` - Takes two operands and checks for equality.
- `%` - Takes two operands and performs modulo operation.

Example:

```beremiz
1 2 +
```

This adds 2 to 1 and pushes the result onto the stack.

### Stack Manipulation

- `dup` - Duplicates the top value on the stack.
- `swap` - Swaps the top two values on the stack.
- `drop` - Removes the top value from the stack.
- `over` - Copies the second-to-top value to the top of the stack.

Example:

```beremiz
1 2 over   # Stack is now: 1 2 1
```

### Control Structures

#### If Statements

```beremiz
1 0 = if
    "Equal" show
else
    "Not equal" show
end
```

#### Loops

```beremiz
# Simple loop example that prints numbers 1 to 5

1
while 6 over > do
    dup show
    1 +
end
```

#### Factorial in Beremiz

```beremiz
#  A program to calculate the factorial of 5.

5 1

while over 0 > do
    over *
    swap 1 -
    swap
end

swap drop
show
```

## Code Structure

### main.lua

This is the main entry point of the Beremiz interpreter. It handles reading input from the user or from a file, tokenizing the input, and then parsing and executing it.

### src/token.lua

This file defines the various token types used by the lexer and parser, and provides a function for creating new tokens.

### src/lexer.lua

This file contains the lexer, which is responsible for converting a string of Beremiz code into a list of tokens. It includes functions for recognizing numbers, strings, identifiers, and comments.

### src/parser.lua

This file contains the parser, which takes a list of tokens and executes the corresponding Beremiz code. It includes functions for handling arithmetic operations, stack manipulation, control structures, and more.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please create an issue or submit a pull request. Please ensure your code adheres to the existing style guidelines and includes appropriate tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
