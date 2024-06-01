# Translator for gleam

[![Package Version](https://img.shields.io/hexpm/v/translate)](https://hex.pm/packages/translate)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/translate/)
[![Tests](https://github.com/andre-dasilva/translate/actions/workflows/test.yml/badge.svg)](https://github.com/andre-dasilva/translate/actions/workflows/test.yml)


Further documentation can be found at <https://hexdocs.pm/translate>.

## Getting Started

### Installation

```sh
gleam add translate
```

### Usage

Create a file for each locale in `src/`

```md
src/
└── locale/
    └── de-CH/
        └── lang.json
    └── en-US/
        └── lang.json
```

de-CH/lang.json

```json
{
    "hello": {
        "value": "Willkommen"
    },
    "amount_planets": {
        "value": "Es gibt {AMOUNT} Planeten. Aber es waren mal {AMOUNT_BEFORE}."
    }
}
```

en-US/lang.json

```json
{
    "hello": {
        "value": "Welcome"
    },
    "amount_planets": {
        "value": "There are {CURRENT} planets"
    }
}
```

And use the translator like this

```gleam
import translate/translator

let assert Ok(translator) =
  translator.new_translator("de-CH")
  |> translator.with_directory("src/locale")
  |> translator.from_json()

let assert Ok(value) =
  translator
  |> translator.get_key("hello")
  // value -> Willkommen

let assert Ok(value) =
  translator
  |> translator.get_key_with_args("amount_planets",  [#("CURRENT", "7"), #("BEFORE", "8")])
  // Es gibt 7 Planeten. Aber es waren mal 8.
```

## Development

Fork the project and clone it

You can run the tests with:

```sh
gleam test
```
