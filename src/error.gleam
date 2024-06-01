import gleam/json
import simplifile

pub type TranslatorError {
  DirectoryNotSet
  DirectoryNotFound
  KeyNotFound
  LanguageFileNotFound
  JsonError(json.DecodeError)
  FileError(simplifile.FileError)
}
