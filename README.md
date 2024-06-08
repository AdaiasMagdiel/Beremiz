# Beremiz

Beremiz is a fun, experimental language based on the stack-based principles of [Porth](https://gitlab.com/tsoding/porth), created by [Alexey Kutepov](https://twitch.tv/tsoding). While Beremiz is designed to be playful and educational, it's not intended for serious programming. Its performance is limited because it runs on top of Lua, making it relatively slow.

The name Beremiz is inspired by the character [Beremiz Samir](https://en.wikipedia.org/wiki/Beremiz_Samir), known as "The Man Who Counted." He was created by [Júlio César de Mello e Souza](https://en.wikipedia.org/wiki/J%C3%BAlio_C%C3%A9sar_de_Mello_e_Souza), a Brazilian teacher and writer better known as Malba Tahan.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running Beremiz Code](#running-beremiz-code)
- [Documentation](#documentation)
  - [Comments](#comments)
    - [Single Line Comments](#single-line-comments)
    - [Multi-line Comments](#multi-line-comments)
  - [Control Structures](#control-structures)
    - [While Loops](#while-loops)
    - [If-Else Conditional Structures](#if-else-conditional-structures)
  - [Stack Operations](#stack-operations)
    - [Basic Operations](#basic-operations)
  - [Displaying Data](#displaying-data)
    - [Showing Last Stack Element](#showing-last-stack-element)
    - [String Interpolation](#string-interpolation)
  - [Arithmetic and Comparison Operations](#arithmetic-and-comparison-operations)
    - [Arithmetic Operations](#arithmetic-operations)
    - [Comparison Operations](#comparison-operations)
  - [Defining Constants and Functions](#defining-constants-and-functions)
    - [Defining Constants](#defining-constants)
    - [Defining Functions](#defining-functions)
    - [Example of Using Constants and Functions](#example-of-using-constants-and-functions)
  - [Including Files](#including-files)
  - [Modules and Methods](#modules-and-methods)
    - [Using Modules and Methods](#using-modules-and-methods)
      - [Example:](#example)
    - [String Module](#string-module)
      - [Available Methods:](#available-methods)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

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

## Documentation

### Comments

#### Single Line Comments

Single line comments can be inserted using the `#` character. They will be ignored by the interpreter.

Example:

```beremiz
# This is a single line comment
```

#### Multi-line Comments

Multi-line comments can be inserted between `#[` and `]#`.

Example:

```beremiz
#[
This is a multi-line comment.
It can span multiple lines.
]#
```

### Control Structures

#### While Loops

The `while` loop allows the execution of a set of statements repeatedly as long as a condition is true.

Example:

```beremiz
# Print all numbers between 0 and 10.

10   # Put 10 on the stack

while dup 0 > do
    dup show

    1 -
end
```

#### If-Else Conditional Structures

The `if-else` structure allows conditional execution of code blocks.

Example:

```beremiz
1 1 +  # Sum 1 plus 1 and put the result on the stack
2 =    # Verify if the result (on the stack) is equal to 2 and add to the stack

if
    "Equal" show
else
    "Not equal" show
end
```

### Stack Operations

#### Basic Operations

- `over`: Duplicates the second item from the top of the stack.

Example:

```beremiz
1 2   # Stack: [1, 2]
over  # Stack: [1, 2, 1]
```

- `dup`: Duplicates the top item of the stack.

Example:

```beremiz
3 4   # Stack: [3, 4]
dup   # Stack: [3, 4, 4]
```

- `drop`: Removes the top item from the stack.

Example:

```beremiz
1 2   # Stack: [1, 2]
drop  # Stack: [1]
```

- `swap`: Swaps the top two items on the stack.

Example:

```beremiz
1 2   # Stack: [1, 2]
swap  # Stack: [2, 1]
```

- `nil`: Inserts a null value into the stack.

Example:

```beremiz
1 2   # Stack: [1, 2]
nil   # Stack: [1, 2, nil]
```

- `dumpstack`: Dumps the current stack trace for debugging purposes. This operation don't consume the stack.

Example:

```beremiz
1 2

dumpstack   # Output: [STACK]: [1, 2]

swap

dumpstack   # Output: [STACK]: [2, 1]
```

### Displaying Data

#### Showing Last Stack Element

The keyword `show` is used to remove and display the last element of the stack.

Example:

```beremiz
1 2 3  # Stack: [1, 2, 3]
show   # Output: 3 -> Stack: [1, 2]
```

#### String Interpolation

String interpolation allows you to create formatted strings by consuming elements from the stack.

- Use `$0`, `$1`, etc., within a string to refer to the elements of the stack.
- `$0` refers to the top element of the stack, `$1` refers to the second element, and so on.
- String interpolations consume the referenced stack elements in the process.

Example:

```beremiz
7 42                        # Stack: [7, 42]
"Num1: $1, Num2: $0" show   # Output: "Num1: 7, Num2: 42" -> Stack: []
```

If you try to consume more elements than are present in the stack, an error is raised. You can also escape the `$` using `\$`:

Example:

```beremiz
"Magdiel"
"Name: $0 | Escaping: \$ \$1" show   # Output: "Name: Magdiel | Escaping: $ $1"
```

### Arithmetic and Comparison Operations

#### Arithmetic Operations

- `+`: Adds the top two items on the stack.
- `-`: Subtracts the top item from the second top item on the stack.
- `*`: Multiplies the top two items on the stack.
- `/`: Divides the second top item by the top item on the stack.
- `%`: Computes the remainder of the division of the second top item by the top item on the stack.
- `**`: Raises the second top item to the power of the top item on the stack.

Examples:

```beremiz
 5 3  + show   # Output: 8
10 4  - show   # Output: 6
 2 3  * show   # Output: 6
10 2  / show   # Output: 5.0
10 3  % show   # Output: 1
 2 3 ** show   # Output: 8.0  (2 raised to the power of 3)
```

#### Comparison Operations

- `>`: Checks if the second top item is greater than the top item on the stack.
- `=`: Checks if the top two items on the stack are equal and pushes a boolean result onto the stack.
- `!=`: Checks if the top two items on the stack are different and pushes a boolean result onto the stack.

Examples:

```beremiz
 5  3  > show   # Output: true
 2  3  > show   # Output: false

10 10  = show   # Output: true
10  5  = show   # Output: false

10 10 != show   # Output: false
10  5 != show   # Output: true
```

### Defining Constants and Functions

#### Defining Constants

Constants can be defined using the `define` keyword followed by the name of the constant, its value, and the `end` keyword.

Example:

```beremiz
define name "Magdiel" end
define age 22 end
```

After defining, you can use these constants in your code.

Example:

```beremiz
name   # Puts "Magdiel" on the stack
age    # Puts 22 on the stack
```

#### Defining Functions

Functions can be defined using the `define` keyword followed by the name of the function, the function body, and the `end` keyword.

Example:

```beremiz
define dupl
    2 *
end
```

After defining, you can use these functions in your code.

Example:

```beremiz
5 dupl   # Multiplies 5 by 2 and adds the result to the stack
```

#### Example of Using Constants and Functions

Combining constants and functions, you can create more complex expressions.

Example:

```beremiz
define name "Magdiel" end
define half_age 11 end

define dupl
    2 *
end

name            # Puts "Magdiel" on the stack
half_age dupl   # Multiplies half_age by 2 and adds the result to the stack

"Hi, I'm $1 and I have $0" show   # Output: "Hi, I'm Magdiel and I have 22"
```

### Including Files

The `include` keyword allows you to include code from other files. This can be useful for organizing and reusing code across multiple files. When you use `include "path"`, it first searches for the file in the directory where the code is being executed. If the file is not found there, it then looks in the language's `includes` directory, where standard files like `std.brz` are located.

Example:

```beremiz
include "path/to/file.brz"
```

### Modules and Methods

Beremiz supports the organization of functionalities into predefined modules, each containing various methods that can be used to manipulate data on the stack. A module is a logical grouping of related methods.

#### Using Modules and Methods

To use a method from a module, you first place the value on the stack and then call the method using the syntax `module.method`.

#### String Module

The `string` module provides methods for string manipulation.

##### Available Methods:

- **`upper`**: Converts the string on top of the stack to uppercase.

  **Usage**:

  `"string" string.upper`

  **Example**:
  
  ```beremiz
  "hello" string.upper show   # Output: HELLO
  ```

- **`lower`**: Converts the string on top of the stack to lowercase.

  **Usage**:

  `"string" string.lower`

  **Example**:
  
  ```beremiz
  "WORLD" string.lower show   # Output: world
  ```

- **`split`**: Splits the string on top of the stack by the specified separator and pushes the resulting substrings onto the stack in reverse order. This ensures the first part of the string is on the top of the stack. To split a string into individual characters, you can use an empty string as a separator.

  **Usage**:

  `"string" "separator" string.split`

  ```beremiz
  "hello world example" " " string.split
  # Stack after execution: ["example", "world", "hello"]
  ```

  **Example**:

  ```beremiz
  "one,two,three" "," string.split
  # Stack after execution: ["three", "two", "one"]

  show   # Output: one
  show   # Output: two
  show   # Output: three
  ```

#### Math Module

The `math` module provides methods for math manipulation.

##### Available Methods:

- **`toint`**: Converts a valid string value in a number.

  **Usage**:

  `"value" math.toint`

  **Example**:
  
  ```beremiz
  "10" math.toint
  5 + show          # Output: 15
  ```



## Running Tests

This project uses [Leste](https://github.com/AdaiasMagdiel/Leste) for test cases. Ensure that [Leste](https://github.com/AdaiasMagdiel/Leste) is installed and run the tests with:

```bash
leste -vx
```

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please create an issue or submit a pull request. Please ensure your code adheres to the existing style guidelines and includes appropriate tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
