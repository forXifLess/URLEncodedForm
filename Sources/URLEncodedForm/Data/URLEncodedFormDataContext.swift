import Foundation

/// Reference type wrapper around `URLEncodedFormData`.
final class URLEncodedFormDataContext {
  var data: URLEncodedFormData

  init(_ data: URLEncodedFormData) {
    self.data = data
  }
}
