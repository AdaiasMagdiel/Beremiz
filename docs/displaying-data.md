# Displaying Data

In Beremiz, you can display data in various formats using the `show` keyword
and string interpolation.

## Showing Last Stack Element

The keyword `show` removes and displays the last element of the stack.

Example:

```beremiz
1 2 3  # Stack: [1, 2, 3]
show   # Output: 3 -> Stack: [1, 2]
```

## String Interpolation

String interpolation allows you to create formatted strings by consuming
elements from the stack.

- Use `$0`, `$1`, etc., within a string to refer to the elements of the stack.
- `$0` refers to the top element of the stack, `$1` refers to the second
element, and so on.
- String interpolations consume the referenced stack elements in the process.

Example:

```beremiz
7 42                        # Stack: [7, 42]
"Num1: $1, Num2: $0" show   # Output: "Num1: 7, Num2: 42" -> Stack: []
```

If you try to consume more elements than are present in the stack, an error is
raised. You can also escape the `$n` using `\$n`.

Example:

```beremiz
"Magdiel"
"Name: $0 | Escaping: \$1" show   # Output: "Name: Magdiel | Escaping: $1"
```
