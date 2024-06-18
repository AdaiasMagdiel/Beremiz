# Table Module

The `table` module provides methods for manipulating tables in Beremiz.

## Available Methods:

- [**`length`**](#length)
- [**`pop`**](#pop)

---

## `length`

Returns the number of elements in the table.

**Usage**:

```beremiz
[1, 2, 3, "a", "b", "c"] table.length
```

**Example**:

```beremiz
[1, 2, 3, "a", "b", "c"] table.length show    # Output: 6
```

This method retrieves the length of the table, which represents the count of elements it contains.

### Notes:

- The `length` method is useful for determining the size of the table before performing operations that depend on the number of elements.
- Empty tables return a length of 0.

---

## `pop`

Removes and returns the last element from the table.

**Usage**:

```beremiz
[1, 2, 3, "a", "b", "c"] table.pop
```

**Example**:

```beremiz
define list
    [1, 2, 3, "abacate", "banana", "caju", true, false, nil]
end

while list table.length 0 > do
    list table.pop show
end
```

In this example, the `pop` operation iteratively removes elements from the `list` until it is empty, displaying each removed element using `show`.
```
