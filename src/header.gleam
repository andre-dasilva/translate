import gleam/float
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string

/// Parses the accept langauge header according to:
/// https://www.rfc-editor.org/rfc/rfc9110#field.accept-language
///
/// e.g. fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5
pub fn parse_accept_language_header(
  raw_header: String,
) -> List(#(String, Float)) {
  let quality_factor = ";q="

  raw_header
  |> string.replace(" ", "")
  |> string.split(",")
  |> list.filter(fn(lang) { !string.is_empty(lang) })
  |> list.filter_map(fn(lang) {
    case string.contains(lang, quality_factor) {
      True -> string.split_once(lang, quality_factor)
      False -> Ok(#(lang, "1.0"))
    }
  })
  |> list.filter_map(fn(lang_with_priority) {
    use priority <- result.try(float.parse(lang_with_priority.1))
    Ok(#(lang_with_priority.0, priority))
  })
  |> list.sort(fn(a, b) { float.compare(a.1, b.1) })
  |> list.reverse()
}

pub fn get_first_lang_from_accept_language_header(
  raw_header: String,
) -> Option(String) {
  let languages_with_priority = parse_accept_language_header(raw_header)

  languages_with_priority
  |> list.first()
  |> option.from_result()
  |> option.map(fn(lang_with_priority) { lang_with_priority.0 })
}
