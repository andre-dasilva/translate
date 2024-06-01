import error
import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/json
import gleam/result
import gleam/string
import simplifile

const language_file_name = "lang.json"

pub fn read_file(
  directory: String,
) -> Result(Dict(String, Dict(String, String)), error.TranslatorError) {
  let file =
    directory |> string.append("/") |> string.append(language_file_name)

  use json_content <- result.try(
    simplifile.read(file) |> result.map_error(error.FileError),
  )

  let decoder =
    dynamic.dict(dynamic.string, dynamic.dict(dynamic.string, dynamic.string))

  use translations <- result.try(result.map_error(
    json.decode(from: json_content, using: decoder),
    error.JsonError,
  ))

  Ok(translations)
}
