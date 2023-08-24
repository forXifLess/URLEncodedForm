import Foundation

public struct URLEncodedFormError: Error {
  public let identifier: String

  public let reason: String

  public init(identifier: String, reason: String) {
    self.identifier = identifier
    self.reason = reason
  }
}
