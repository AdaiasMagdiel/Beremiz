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
