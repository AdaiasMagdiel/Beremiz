# Including Files

The `include` keyword allows you to include code from other files. This can be useful for organizing and reusing code across multiple files. When you use `include "path"`, it first searches for the file in the directory where the code is being executed. If the file is not found there, it then looks in the language's `includes` directory, where standard files like `std.brz` are located.

Example:

```beremiz
include "path/to/file.brz"
```
