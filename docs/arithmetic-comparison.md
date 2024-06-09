# Arithmetic and Comparison Operations

This section covers a variety of arithmetic and comparison operations that are
intrinsic to the language for stack manipulation.

## Arithmetic Operations

The available arithmetic operators are as follows:

-  `+`: Adds the top two items on the stack.
-  `-`: Subtracts the top item from the second top item on the stack.
-  `*`: Multiplies the top two items on the stack.
-  `/`: Divides the second top item by the top item on the stack.
-  `%`: Computes the remainder of the division of the second top item by the
top item on the stack.
- `**`: Raises the second top item to the power of the top item on the stack.

### Examples:

```beremiz
 5 3  + show   # Result: 8
10 4  - show   # Result: 6
 2 3  * show   # Result: 6
10 2  / show   # Result: 5.0
10 3  % show   # Result: 1
 2 3 ** show   # Result: 8.0  (2 raised to the power of 3)
```

## Comparison Operations

The available comparison operators are as follows:

-  `>`: Checks if the second top item is greater than the top item on the stack.
-  `=`: Checks if the top two items on the stack are equal and pushes a boolean
result onto the stack.
- `!=`: Checks if the top two items on the stack are different and pushes a
boolean result onto the stack.

### Examples:

```beremiz
 5  3  > show   # Result: true
 2  3  > show   # Result: false
10 10  = show   # Result: true
10  5  = show   # Result: false
10 10 != show   # Result: false
10  5 != show   # Result: true
```
