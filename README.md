# Beremiz

Beremiz is a fun, experimental language based on the stack-based principles of
[Porth](https://gitlab.com/tsoding/porth), created by
[Alexey Kutepov](https://twitch.tv/tsoding). While Beremiz is designed to be
playful and educational, it's not intended for serious programming. Its
performance is limited because it runs on top of Lua, making it relatively slow.

The name Beremiz is inspired by the character
[Beremiz Samir](https://en.wikipedia.org/wiki/Beremiz_Samir), known as
"The Man Who Counted." He was created by
[Júlio César de Mello e Souza](https://en.wikipedia.org/wiki/J%C3%BAlio_C%C3%A9sar_de_Mello_e_Souza), a Brazilian teacher and writer better known as Malba Tahan.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running Beremiz Code](#running-beremiz-code)
  - [Example Files](#example-files)
- [Documentation](#documentation)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

### Prerequisites

Ensure you have Lua installed on your system. You can download it from the
[official Lua website](https://www.lua.org/download.html).

### Installation

Clone this repository locally:

```bash
git clone https://github.com/AdaiasMagdiel/beremiz.git
cd beremiz
```

### Running Beremiz Code

There are two ways to run Beremiz code:

- Using the REPL:
  ```bash
  lua main.lua
  ```

- Passing a file:
  ```bash
  lua main.lua [file]
  ```

### Example Files

You can find several example files in the `examples` folder to help you get
started. Here are some key examples:

- [**Factorial**](./examples/factorial.brz): A program that calculates the
factorial of a number.
- [**Pythagorean Theorem**](./examples/pythagorean_theorem.brz): Demonstrates
the calculation of the hypotenuse in a right-angled triangle using the
Pythagorean theorem.
- [**Quadratic Equation**](./examples/quadratic_equation.brz): Solves quadratic
equations and finds their roots.
- [**FizzBuzz**](./examples/fizzbuzz.brz): Implements the classic FizzBuzz problem, printing numbers from 1 to 15 but replacing multiples of 3 with "Fizz", multiples of 5 with "Buzz", and multiples of both with "FizzBuzz".

## Documentation

For a complete understanding of the Beremiz language, we recommend exploring
our detailed documentation. It covers from basic syntax to advanced features.

[Go to the documentation.](https://adaiasmagdiel.github.io/Beremiz/)

## Running Tests

This project uses [Leste](https://github.com/AdaiasMagdiel/Leste) for test
cases. Ensure that [Leste](https://github.com/AdaiasMagdiel/Leste) is installed
and run the tests with:

```bash
leste -vx
```

## Contributing

Contributions are welcome! If you have suggestions for improvements or new
features, please create an issue or submit a pull request. Please ensure your
code adheres to the existing style guidelines and includes appropriate tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details.
