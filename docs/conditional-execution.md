# Conditional Execution

Conditional execution allows you to execute code based on certain conditions using the `if`, `and`, and `or` keywords. The `and` and `or` operators can also be used within `while` loops.

## Truth Table for `and`

The `and` operator executes the block if both conditions are true.

```beremiz
if true true and do
  "true and true" show
end

if true false and do
  "true and false" show
end

if true nil and do
  "true and nil" show
end

if false true and do
  "false and true" show
end

if false false and do
  "false and false" show
end

if false nil and do
  "false and nil" show
end

if nil true and do
  "nil and true" show
end

if nil false and do
  "nil and false" show
end

if nil nil and do
  "nil and nil" show
end
```

## Truth Table for `or`

The `or` operator executes the block if at least one of the conditions is true.

```beremiz
if true true or do
  "true or true" show
end

if true false or do
  "true or false" show
end

if true nil or do
  "true or nil" show
end

if false true or do
  "false or true" show
end

if false false or do
  "false or false" show
end

if false nil or do
  "false or nil" show
end

if nil true or do
  "nil or true" show
end

if nil false or do
  "nil or false" show
end

if nil nil or do
  "nil or nil" show
end
```
