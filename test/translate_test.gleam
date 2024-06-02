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
    #("hello", 0, [], "Hallo"),
    #("welcome", 0, [], "Willkommen"),
    #("this_is_great", 0, [], "Das ist fantastisch"),
    #("i_have_books", 0, [#("COUNT", "1")], "Ich habe 1 Buch"),
    #("i_have_books", 1, [#("COUNT", "42")], "Ich habe 42 Bücher"),
    #(
      "amount_planets",
      0,
      [#("CURRENT", "7"), #("BEFORE", "8")],
      "Es gibt 7 Planeten. Aber es waren mal 8.",
    ),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, count, args, expected) = t

    let assert Ok(key) =
      translator |> translator.get_key_plural(input, count, args)

    key
    |> should.equal(expected)
  })
}

pub fn read_translation_en_us_test() {
  let translator = translator("en-US")

  let tests = [
    #("hello", 0, [], "Hello"),
    #("welcome", 0, [], "Welcome"),
    #("this_is_great", 0, [], "This is great"),
    #("i_have_books", 0, [#("COUNT", "1")], "I have 1 book"),
    #("i_have_books", 0, [#("COUNT", "42")], "I have 42 book"),
    #("amount_planets", 0, [#("CURRENT", "7")], "There are 7 planets"),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, count, args, expected) = t

    let assert Ok(key) =
      translator |> translator.get_key_plural(input, count, args)

    key
    |> should.equal(expected)
  })
}
