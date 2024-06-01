import gleam/list
import gleam/option.{None, Some}
import gleeunit/should
import header

pub fn parse_accept_language_header_test() {
  let tests = [
    #("fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5", [
      #("fr-CH", 1.0),
      #("fr", 0.9),
      #("en", 0.8),
      #("de", 0.7),
      #("*", 0.5),
    ]),
    #("fr-CH, de-CH;q=0.2, en;q=0.5, it;q=0.3", [
      #("fr-CH", 1.0),
      #("en", 0.5),
      #("it", 0.3),
      #("de-CH", 0.2),
    ]),
    #("fr-CH, de-CH;q=A, en;q=0.2", [#("fr-CH", 1.0), #("en", 0.2)]),
    #("", []),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, expected) = t

    header.parse_accept_language_header(input)
    |> should.equal(expected)
  })
}

pub fn get_first_lang_from_accept_language_header_test() {
  let tests = [
    #("fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5", Some("fr-CH")),
    #("", None),
  ]

  tests
  |> list.map(fn(t) {
    let #(input, expected) = t

    header.get_first_lang_from_accept_language_header(input)
    |> should.equal(expected)
  })
}
