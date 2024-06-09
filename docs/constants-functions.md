# Defining Constants and Functions

## Defining Constants

Constants can be defined using the `define` keyword followed by the name of the constant, its value, and the `end` keyword.

Example:

```beremiz
define name "Magdiel

" end
define age 22 end
```

After defining, you can use these constants in your code.

Example:

```beremiz
name   # Puts "Magdiel" on the stack
age    # Puts 22 on the stack
```

## Defining Functions

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

## Example of Using Constants and Functions

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
