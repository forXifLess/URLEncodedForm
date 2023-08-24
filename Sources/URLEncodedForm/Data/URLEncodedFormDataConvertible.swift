import Foundation

protocol URLEncodedFormDataConvertible {

  /// Converts self to `URLEncodedFormData`.
  func convertToURLEncodedFormData() throws -> URLEncodedFormData

  /// Converts `URLEncodedFormData` to self.
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self
}

extension String: URLEncodedFormDataConvertible {

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(self)
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> String {
    guard let string = data.string else {
      throw URLEncodedFormError(identifier: "url", reason: "Could not convert to `String`: \(data)")
    }
    return string
  }
}

extension URL: URLEncodedFormDataConvertible {
  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(self.absoluteString)
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> URL {
    guard let url = data.url else {
      throw URLEncodedFormError(identifier: "url", reason: "Could not convert to `URL`: \(data)")
    }
    return url
  }
}

extension FixedWidthInteger {
  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self {
    guard let fwi = data.string.flatMap(Self.init) else {
      throw URLEncodedFormError(identifier: "fwi", reason: "Could not convert to `\(Self.self)`: \(data)")
    }
    return fwi
  }
}

extension Int: URLEncodedFormDataConvertible {}

extension Int8: URLEncodedFormDataConvertible {}

extension Int16: URLEncodedFormDataConvertible {}

extension Int32: URLEncodedFormDataConvertible {}

extension Int64: URLEncodedFormDataConvertible {}

extension UInt: URLEncodedFormDataConvertible {}

extension UInt8: URLEncodedFormDataConvertible {}

extension UInt16: URLEncodedFormDataConvertible {}

extension UInt32: URLEncodedFormDataConvertible {}

extension UInt64: URLEncodedFormDataConvertible {}

extension BinaryFloatingPoint {
  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str("\(self)")
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self {
    guard let bfp = data.string.flatMap(Double.init).flatMap(Self.init) else {
      throw URLEncodedFormError(identifier: "bfp", reason: "Could not convert to `\(Self.self)`: \(data)")
    }

    return bfp
  }
}

extension Float: URLEncodedFormDataConvertible { }

extension Double: URLEncodedFormDataConvertible { }

extension Bool: URLEncodedFormDataConvertible {

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Bool {
    guard let bool = data.string?.bool else {
      throw URLEncodedFormError(identifier: "bfp", reason: "Could not convert to `\(Self.self)`: \(data)")
    }
    return bool
  }
}

extension Decimal: URLEncodedFormDataConvertible {
  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Decimal {
    guard let string = data.string, let d = Decimal(string: string) else {
      throw URLEncodedFormError(identifier: "decimal", reason: "Could not convert to Decimal: \(data)")
    }
    return d
  }
}

extension String {
  /// Converts the string to a `Bool` or returns `nil`.
  fileprivate var bool: Bool? {
    switch self.lowercased() {
    case "true", "yes", "1", "y": return true
    case "false", "no", "0", "n": return false
    default: return nil
    }
  }
}
