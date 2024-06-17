# Beremiz Language Reference

This reference guide provides an overview of the syntax, operations, and modules available in the Beremiz programming language.

## Table of Contents

- [Comments](#comments)
  - [Single Line Comments](#single-line-comments)
  - [Multi-line Comments](#multi-line-comments)
- [Control Structures](#control-structures)
  - [If-Else](#if-else)
    - [Using `and` with `if`](#using-and-with-if)
    - [Using `or` with `if`](#using-or-with-if)
  - [Loop](#loop)
    - [Using `and` with `while`](#using-and-with-while)
    - [Using `or` with `while`](#using-or-with-while)
- [Stack Operations](#stack-operations)
  - [Basic Operations](#basic-operations)
    - [Examples:](#examples)
- [Displaying Data](#displaying-data)
  - [Showing Last Stack Element](#showing-last-stack-element)
  - [String Interpolation](#string-interpolation)
- [Arithmetic and Comparison Operations](#arithmetic-and-comparison-operations)
  - [Arithmetic Operations](#arithmetic-operations)
    - [Examples:](#examples)
  - [Comparison Operations](#comparison-operations)
    - [Examples:](#examples)
- [Defining Constants and Functions](#defining-constants-and-functions)
  - [Defining Constants](#defining-constants)
  - [Defining Functions](#defining-functions)
    - [Example Usage:](#example-usage)
- [Including Files](#including-files)
  - [Including Other Files](#including-other-files)
- [Modules](#modules)
  - [String Module](#string-module)
    - [Methods](#methods)
      - [Examples:](#examples)
  - [Math Module](#math-module)
    - [Methods](#methods)
      - [Example:](#example)

## Comments

### Single Line Comments

Use the `#` character.

```beremiz
# This is a single line comment
```

### Multi-line Comments

Use `#[` to start and `]#` to end.

```beremiz
#[
This is a multi-line comment.
]#
```

## Control Structures

### If-Else

Conditional execution based on the top stack value.

```beremiz
if condition do
    # Code if true
else
    # Code if false
end
```

#### Using `and` with `if`

The `and` operator executes the block if both conditions are true.

```beremiz
if true true and do
    "true and true" show
end

if true false and do
    "true and false" show
end
```

#### Using `or` with `if`

The `or` operator executes the block if at least one of the conditions is true.

```beremiz
if true true or do
    "true or true" show
end

if true false or do
    "true or false" show
end
```

### Loop

Repeated execution based on a condition.

```beremiz
while condition do
    # Loop body
end
```

#### Using `and` with `while`

The `while` loop executes the block as long as both conditions are true.

```beremiz
5 10

while
    over 15 != 
    over 15 !=
    and
do
    over over " $0 and $1 are not equal 15" show

    1 +
    swap
    1 +
    swap
end
```

#### Using `or` with `while`

The `while` loop executes the block as long as at least one of the conditions is true.

```beremiz
5 10

while
    over -1 > 
    over -1 >
    or
do
    over over " $0 and $1 are positive" show

    1 -
    swap
    1 -
    swap
end
```

## Stack Operations

### Basic Operations

- **`over`**: Duplicates the second item from the top of the stack.
- **`dup`**: Duplicates the top item of the stack.
- **`drop`**: Removes the top item from the stack.
- **`swap`**: Swaps the top two items on the stack.
- **`nil`**: Inserts a null value into the stack.
- **`dumpstack`**: Dumps the current stack trace.
- **`exit`**: Exits the program with an optional status code and message.

#### Examples:

```beremiz
1 2 over     # Stack: [1, 2, 1]
3 4 dup      # Stack: [3, 4, 4]
5 6 drop     # Stack: [5]
7 8 swap     # Stack: [8, 7]
9 nil        # Stack: [9, nil]
dumpstack    # Output: stack trace
0 exit       # Exit with status 0
1 "Error" exit   # Exit with status 1 and message "Error"
```

## Displaying Data

### Showing Last Stack Element

```beremiz
show   # Displays the top stack element
```

### String Interpolation

```beremiz
"Num1: $1, Num2: $0" show   # Uses stack elements in the string
```

## Arithmetic and Comparison Operations

### Arithmetic Operations

-  `+`: Adds the top two items.
-  `-`: Subtracts the top item from the second top item.
-  `*`: Multiplies the top two items.
-  `/`: Divides the second top item by the top item.
-  `%`: Computes the remainder.
- `**`: Raises to the power.

#### Examples:

```beremiz
 5 3  + show  # Result: 8
10 4  - show  # Result: 6
 2 3  * show  # Result: 6
10 2  / show  # Result: 5.0
10 3  % show  # Result: 1
 2 3 ** show  # Result: 8.0
```

### Comparison Operations

-  `>`: Checks if the second top item is greater than the top item.
-  `=`: Checks if the top two items are equal.
- `!=`: Checks if the top two items are different.

#### Examples:

```beremiz
 5  3  > show  # Result: true
 2  3  > show  # Result: false
10 10  = show  # Result: true
10  5  = show  # Result: false
10 10 != show  # Result: false
10  5 != show  # Result: true
```

## Defining Constants and Functions

### Defining Constants

```beremiz
define name "Magdiel" end
define age 22 end
```

### Defining Functions

```beremiz
define dupl
    2 *
end
```

#### Example Usage:

```beremiz
name   # Pushes "Magdiel" onto the stack
age    # Pushes 22 onto the stack
5 dupl # Multiplies 5 by 2 and adds to the stack
```

## Including Files

### Including Other Files

```beremiz
include "path/to/file.brz"
```

## Modules

Beremiz provides various modules to extend the functionality of the language.
Modules contain methods that can be applied to specific types of data, such as
strings or numbers.

### String Module

The `string` module provides methods for string manipulation.

#### Methods

- `upper`: Converts the top string to uppercase.
- `lower`: Converts the top string to lowercase.
- `split`: Splits the top string by a separator.

##### Examples:

```beremiz
"hello" string.upper show   # Output: HELLO
"WORLD" string.lower show   # Output: world
"one,two,three" "," string.split
# Stack: ["three", "two", "one"]
```

### Math Module

The `math` module provides methods for mathematical operations.

#### Methods

- `toint`: Converts the top stack item to an integer.

##### Example:

```beremiz
"123.45" math.toint show   # Output: 123
```
