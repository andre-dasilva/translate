import error
import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import json
import simplifile

pub type Translator {
  Translator(
    language: String,
    directory: Option(String),
    translations: Option(Dict(String, Dict(String, String))),
  )
}

const default_translations_directory = "src/translations"

pub fn new_translator(language: String) -> Translator {
  Translator(
    language: language,
    directory: Some(default_translations_directory),
    translations: None,
  )
}

pub fn with_directory(translator: Translator, directory: String) -> Translator {
  Translator(..translator, directory: Some(directory))
}

pub fn from_json(
  translator: Translator,
) -> Result(Translator, error.TranslatorError) {
  use directory <- result.try(option.to_result(
    translator.directory,
    error.DirectoryNotSet,
  ))

  let directory_with_language =
    directory |> string.append("/") |> string.append(translator.language)

  use is_directory <- result.try(
    simplifile.is_directory(directory_with_language)
    |> result.map_error(error.FileError),
  )

  use translations <- result.try(case is_directory {
    True -> Ok(json.read_file(directory_with_language))
    False -> Error(error.DirectoryNotFound)
  })

  use translations <- result.try(translations)

  Ok(Translator(..translator, translations: Some(translations)))
}

fn priv_get_key(
  translator: Translator,
  key: String,
  value_key: String,
  args: List(#(String, String)),
) -> Result(String, error.TranslatorError) {
  let translations = translator.translations |> option.unwrap(dict.new())

  use translation <- result.try(
    dict.get(translations, key) |> result.replace_error(error.KeyNotFound(key)),
  )

  use value <- result.try(
    dict.get(translation, value_key)
    |> result.replace_error(error.KeyNotFound(value_key)),
  )

  Ok(rec_replace_args(value, args))
}

fn rec_replace_args(value: String, args: List(#(String, String))) -> String {
  case args {
    [head, ..tail] -> {
      let #(param, param_value) = head

      let updated_translation =
        string.replace(
          value,
          each: "{" <> string.uppercase(param) <> "}",
          with: param_value,
        )

      rec_replace_args(updated_translation, tail)
    }
    _ -> value
  }
}

pub fn get_key(
  translator: Translator,
  key: String,
) -> Result(String, error.TranslatorError) {
  get_key_with_args(translator, key, [])
}

pub fn get_key_with_args(
  translator: Translator,
  key: String,
  args: List(#(String, String)),
) -> Result(String, error.TranslatorError) {
  priv_get_key(translator, key, "value", args)
}

pub fn get_key_plural(
  translator: Translator,
  key: String,
  count: Int,
  args: List(#(String, String)),
) {
  case count {
    0 -> get_key_with_args(translator, key, args)
    _ -> priv_get_key(translator, key, "value_plural", args)
  }
}
