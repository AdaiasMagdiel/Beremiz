# String Module

The `string` module provides methods for string manipulation.

## Available Methods:

### `upper`

Converts the string on top of the stack to uppercase.

**Usage**:

```beremiz
"string" string.upper
```

**Example**:

```beremiz
"hello" string.upper show   # Output: HELLO
```

### `lower`

Converts the string on top of the stack to lowercase.

**Usage**:

```beremiz
"string" string.lower
```

**Example**:

```beremiz
"WORLD" string.lower show   # Output: world
```

### `split`

Splits the string on top of the stack by the specified separator and pushes the resulting substrings onto the stack in reverse order. This ensures the first part of the string is on the top of the stack. To split a string into individual characters, you can use an empty string as a separator.

**Usage**:

```beremiz
"string" "separator" string.split
```

**Example**:

```beremiz
"hello world example" " " string.split
# Stack after execution: ["example", "world", "hello"]
```

Another example:

```beremiz
"one,two,three" "," string.split
# Stack after execution: ["three", "two", "one"]

show   # Output: one
show   # Output: two
show   # Output: three
```
