# Defining Variables, Constants, and Functions

In Beremiz, defining variables, constants, and functions can significantly enhance the readability and maintainability of your code. This section explains how to define and use these elements.

## Defining Variables

Variables in Beremiz are defined and redefined using the `set` keyword. Unlike constants, variables can be reassigned with new values at any time.

### Syntax:

```beremiz
<value> <variable_name> set
```

### Example:

```beremiz
42 magic set
magic show   # Output: 42

"don't panic!" magic set
magic show   # Output: "don't panic!"
```

## Defining Constants

Constants in Beremiz are defined using the `define` keyword followed by the constant's name, its value, and the `end` keyword. Constants are immutable once set, providing a reliable way to use fixed values throughout your code.

### Syntax:

```beremiz
define <constant_name> <value> end
```

### Example:

```beremiz
define name "Magdiel" end
define age 22 end
```

### Usage:

```beremiz
name   # Pushes "Magdiel" onto the stack
age    # Pushes 22 onto the stack
```

## Defining Functions

Functions in Beremiz are also defined using the `define` keyword, followed by the function's name, its body, and the `end` keyword. Functions allow you to encapsulate reusable logic within your code.

### Syntax:

```beremiz
define <function_name>
    <function_body>
end
```

### Example:

```beremiz
define dupl
    2 *
end
```

### Usage:

```beremiz
5 dupl   # Multiplies 5 by 2 and adds the result to the stack
```

## Example of Using Constants and Functions

By combining constants and functions, you can create more complex and reusable expressions. Here's an example that demonstrates how to use both constants and functions effectively:

### Example:

```beremiz
define name "Magdiel" end
define half_age 11 end

define dupl
    2 *
end

name            # Pushes "Magdiel" onto the stack
half_age dupl   # Multiplies half_age by 2 and adds the result to the stack

"Hi, I'm $1 and I have $0" show   # Output: "Hi, I'm Magdiel and I have 22"
```

In this example:
- `name` is a constant representing a string.
- `half_age` is a constant representing a numerical value.
- `dupl` is a function that doubles its input.
- The expression `"Hi, I'm $1 and I have $0" show` uses these constants and the function to produce a formatted output.

## Differences Between `define` and `set`

- **`define`**: Used to create constants and functions. The value assigned cannot be changed after the initial definition.
- **`set`**: Used to create or update variables. Variables can be reassigned with new values as needed.
