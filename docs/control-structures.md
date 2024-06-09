# Control Structures

## While Loops

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

## If-Else Conditional Structures

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
