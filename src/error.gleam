import gleam/json
import simplifile

pub type TranslatorError {
  DirectoryNotSet
  DirectoryNotFound
  KeyNotFound(String)
  JsonError(json.DecodeError)
  FileError(simplifile.FileError)
}
