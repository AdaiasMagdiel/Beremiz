# Control Structures

In Beremiz, control structures such as while loops and if-else conditional
structures enable you to manage the flow of execution within your code.

## While Loops

The `while` loop executes a set of statements repeatedly as long as a condition
is true or not nil.

Example:

```beremiz
# Print all numbers between 0 and 10.

10   # Push 10 onto the stack

while dup 0 > do
    dup show
    1 -
end
```

### Break Statement

The `break` keyword is used to immediately exit a `while` loop, regardless of
the loop's condition.

Example:

```beremiz
# Print numbers from 10 to 6, then exit the loop

10   # Push 10 onto the stack

while dup 0 > do
    if dup 5 = do
        break       # Exit the loop if the number is 5
    end

    dup show

    1 -
end
```

### Continue Statement

The `continue` keyword is used to skip the current iteration of a `while` loop
and proceed to the next iteration.

Example:

```beremiz
# Print numbers from 10 to 1, but skip 5

10   # Push 10 onto the stack

while dup 0 > do
    if dup 5 = do
        1 -        # Decrement to avoid an infinite loop
        continue   # Skip the rest of the loop when the number is 5
    end

    dup show

    1 -
end
```

## If-Else Conditional Structures

The `if-else` structure allows conditional execution of code blocks based on
specified conditions.

Example:

```beremiz
1 1 +        # Add 1 to 1 and push the result onto the stack

if 2 = do    # Check if the result (on the stack) is equal to 2
    "Equal" show
else
    "Not equal" show
end
```
