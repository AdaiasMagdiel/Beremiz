# Defining Constants and Functions

In Beremiz, you can define constants and functions to enhance code readability
and maintainability.

## Defining Constants

Constants are defined using the `define` keyword followed by the constant's
name, its value, and the `end` keyword.

Example:

```beremiz
define name "Magdiel" end
define age 22 end
```

Once defined, these constants can be used throughout your code.

Example:

```beremiz
name   # Pushes "Magdiel" onto the stack
age    # Pushes 22 onto the stack
```

## Defining Functions

Functions can be defined using the `define` keyword followed by the function's
name, its body, and the `end` keyword.

Example:

```beremiz
define dupl
    2 *
end
```

After defining a function, you can utilize it within your code.

Example:

```beremiz
5 dupl   # Multiplies 5 by 2 and adds the result to the stack
```

## Example of Using Constants and Functions

By combining constants and functions, you can create more complex expressions.

Example:

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
