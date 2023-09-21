import Foundation

/// Reference type wrapper around `URLEncodedFormData`.
final class URLEncodedFormDataContext {

  // MARK: Lifecycle

  init(_ data: URLEncodedFormData) {
    self.data = data
  }

  // MARK: Internal

  var data: URLEncodedFormData

}
