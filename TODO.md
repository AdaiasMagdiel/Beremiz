# TODO

## New Keywords

### nthtop (or nth-top)

Removes the nth element from the stack and places it on top of the stack. Index 0 is the top, index 1 is the second, and so on.

**Example**:

```beremiz
7 8 9 10   # stack: 7, 8, 9, 10
2 nthtop   # stack: 7, 9, 10, 8
```

Certainly! Here's the corrected and improved TODO section for the Table Module and String Module:

## Modules

### Table Module

- **`push`**: Push elements to a table.
- **`remove`**: Remove an element from a table at a specified index.
- **`reverse`**: Reverse the order of elements in a table.
- **`join`**: Join elements of a table into a single string using a specified separator.

### String Module

- **`split_into`**: Splits a string into parts and creates a table with these parts, adding the table to the stack instead of individual elements.

## New Modules

### stack module

Useful for obtaining information about the current stack. The methods include:

- `length`: Used to determine how many elements are in the stack. This can be used in functions to check and validate the argument count.

```beremiz
1 2 3

stack.length show # output: 3

if stack.length 4 != do
	1 "Expected 4 arguments in the stack" exit
end
```
