import gleam/list
import gleeunit
import gleeunit/should
import translator

pub fn main() {
  gleeunit.main()
}

fn translator(language: String) -> translator.Translator {
  let assert Ok(translator) =
    translator.new_translator(language)
    |> translator.with_directory("test/locale")
    |> translator.from_json()

  translator
}

pub fn read_translation_de_ch_test() {
  let translator = translator("de-CH")

  let tests = [
    #("hello", [], "Hallo"),
    #("welcome", [], "Willkommen"),
    #("this_is_great", [], "Das ist fantastisch"),
    #(
      "amount_planets",
      [#("CURRENT", "7"), #("BEFORE", "8")],
      "Es gibt 7 Planeten. Aber es waren mal 8.",
    ),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, args, expected) = t

    let assert Ok(key) = translator |> translator.get_key_with_args(input, args)

    key
    |> should.equal(expected)
  })
}

pub fn read_translation_en_us_test() {
  let translator = translator("en-US")

  let tests = [
    #("hello", [], "Hello"),
    #("welcome", [], "Welcome"),
    #("this_is_great", [], "This is great"),
    #("amount_planets", [#("CURRENT", "7")], "There are 7 planets"),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, args, expected) = t

    let assert Ok(key) = translator |> translator.get_key_with_args(input, args)

    key
    |> should.equal(expected)
  })
}
