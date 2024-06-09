# Stack Operations

Beremiz provides various operations for manipulating the stack, allowing you to
efficiently manage data during program execution.

## Basic Operations

- **`over`**: Duplicates the second item from the top of the stack.

    Example:

    ```beremiz
    1 2   # Stack: [1, 2]
    over  # Stack: [1, 2, 1]
    ```

- **`dup`**: Duplicates the top item of the stack.

    Example:

    ```beremiz
    3 4   # Stack: [3, 4]
    dup   # Stack: [3, 4, 4]
    ```

- **`drop`**: Removes the top item from the stack.

    Example:

    ```beremiz
    1 2   # Stack: [1, 2]
    drop  # Stack: [1]
    ```

- **`swap`**: Swaps the top two items on the stack.

    Example:

    ```beremiz
    1 2   # Stack: [1, 2]
    swap  # Stack: [2, 1]
    ```

- **`nil`**: Inserts a null value into the stack.

    Example:

    ```beremiz
    1 2   # Stack: [1, 2]
    nil   # Stack: [1, 2, nil]
    ```

- **`dumpstack`**: Dumps the current stack trace for debugging purposes. This operation doesn't consume the stack.

    Example:

    ```beremiz
    1 2
    dumpstack   # Output: [STACK]:
                #             NUMBER: 1 (number)
                #             NUMBER: 2 (number)
    swap

    dumpstack   # Output: [STACK]:
                #             NUMBER: 2 (number)
                #             NUMBER: 1 (number)

    ```
