# Arithmetic and Comparison Operations

## Arithmetic Operations

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

## Comparison Operations

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
