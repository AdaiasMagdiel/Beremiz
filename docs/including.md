# Including Files

In Beremiz, the `include` keyword allows you to import code from other files.
This feature is particularly useful for organizing and reusing code across
multiple files, promoting modularity and maintainability.

## Usage

You can include files using the `include` keyword followed by the path to the
file you want to include.

Example:

```beremiz
include "path/to/file.brz"
```

Beremiz first searches for the specified file in the directory where the code
is being executed. If the file is not found there, it then looks in the
language's `includes` directory, where standard files like `std.brz` are
located.
