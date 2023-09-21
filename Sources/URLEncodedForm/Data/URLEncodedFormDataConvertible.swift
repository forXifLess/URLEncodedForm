import Foundation

// MARK: - URLEncodedFormDataConvertible

protocol URLEncodedFormDataConvertible {

  /// Converts self to `URLEncodedFormData`.
  func convertToURLEncodedFormData() throws -> URLEncodedFormData

  /// Converts `URLEncodedFormData` to self.
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self
}

// MARK: - String + URLEncodedFormDataConvertible

extension String: URLEncodedFormDataConvertible {

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> String {
    guard let string = data.string else {
      throw URLEncodedFormError(identifier: "url", reason: "Could not convert to `String`: \(data)")
    }
    return string
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(self)
  }

}

// MARK: - URL + URLEncodedFormDataConvertible

extension URL: URLEncodedFormDataConvertible {
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> URL {
    guard let url = data.url else {
      throw URLEncodedFormError(identifier: "url", reason: "Could not convert to `URL`: \(data)")
    }
    return url
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(absoluteString)
  }

}

extension FixedWidthInteger {
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self {
    guard let fwi = data.string.flatMap(Self.init) else {
      throw URLEncodedFormError(identifier: "fwi", reason: "Could not convert to `\(Self.self)`: \(data)")
    }
    return fwi
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

}

// MARK: - Int + URLEncodedFormDataConvertible

extension Int: URLEncodedFormDataConvertible { }

// MARK: - Int8 + URLEncodedFormDataConvertible

extension Int8: URLEncodedFormDataConvertible { }

// MARK: - Int16 + URLEncodedFormDataConvertible

extension Int16: URLEncodedFormDataConvertible { }

// MARK: - Int32 + URLEncodedFormDataConvertible

extension Int32: URLEncodedFormDataConvertible { }

// MARK: - Int64 + URLEncodedFormDataConvertible

extension Int64: URLEncodedFormDataConvertible { }

// MARK: - UInt + URLEncodedFormDataConvertible

extension UInt: URLEncodedFormDataConvertible { }

// MARK: - UInt8 + URLEncodedFormDataConvertible

extension UInt8: URLEncodedFormDataConvertible { }

// MARK: - UInt16 + URLEncodedFormDataConvertible

extension UInt16: URLEncodedFormDataConvertible { }

// MARK: - UInt32 + URLEncodedFormDataConvertible

extension UInt32: URLEncodedFormDataConvertible { }

// MARK: - UInt64 + URLEncodedFormDataConvertible

extension UInt64: URLEncodedFormDataConvertible { }

extension BinaryFloatingPoint {
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Self {
    guard let bfp = data.string.flatMap(Double.init).flatMap(Self.init) else {
      throw URLEncodedFormError(identifier: "bfp", reason: "Could not convert to `\(Self.self)`: \(data)")
    }

    return bfp
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str("\(self)")
  }

}

// MARK: - Float + URLEncodedFormDataConvertible

extension Float: URLEncodedFormDataConvertible { }

// MARK: - Double + URLEncodedFormDataConvertible

extension Double: URLEncodedFormDataConvertible { }

// MARK: - Bool + URLEncodedFormDataConvertible

extension Bool: URLEncodedFormDataConvertible {

  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Bool {
    guard let bool = data.string?.bool else {
      throw URLEncodedFormError(identifier: "bfp", reason: "Could not convert to `\(Self.self)`: \(data)")
    }
    return bool
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

}

// MARK: - Decimal + URLEncodedFormDataConvertible

extension Decimal: URLEncodedFormDataConvertible {
  static func convertFromURLEncodedFormData(_ data: URLEncodedFormData) throws -> Decimal {
    guard let string = data.string, let d = Decimal(string: string) else {
      throw URLEncodedFormError(identifier: "decimal", reason: "Could not convert to Decimal: \(data)")
    }
    return d
  }

  func convertToURLEncodedFormData() throws -> URLEncodedFormData {
    .str(description)
  }

}

extension String {
  /// Converts the string to a `Bool` or returns `nil`.
  fileprivate var bool: Bool? {
    switch lowercased() {
    case "true", "yes", "1", "y": return true
    case "false", "no", "0", "n": return false
    default: return nil
    }
  }
}
