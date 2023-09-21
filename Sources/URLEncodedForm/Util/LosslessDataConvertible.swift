import Foundation

// MARK: - LosslessDataConvertible

/// A type that can be represented as `Data` in a lossless, unambiguous way.
public protocol LosslessDataConvertible {
  /// Losslessly converts this type to `Data`.
  func convertToData() -> Data

  /// Losslessly converts `Data` to this type.
  static func convertFromData(_ data: Data) -> Self
}

extension Data {
  /// Converts this `Data` to a `LosslessDataConvertible` type.
  ///
  ///     let string = Data([0x68, 0x69]).convert(to: String.self)
  ///     print(string) // "hi"
  ///
  /// - parameters:
  ///     - type: The `LosslessDataConvertible` to convert to.
  /// - returns: Instance of the `LosslessDataConvertible` type.
  public func convert<T>(to _: T.Type = T.self) -> T where T: LosslessDataConvertible {
    T.convertFromData(self)
  }
}

// MARK: - String + LosslessDataConvertible

extension String: LosslessDataConvertible {
  /// Converts `Data` to a `utf8` encoded String.
  ///
  /// - throws: Error if String is not UTF8 encoded.
  public static func convertFromData(_ data: Data) -> String {
    guard let string = String(data: data, encoding: .utf8) else {
      /// FIXME: string convert _from_ data is not actually lossless.
      /// this should really only conform to a `LosslessDataRepresentable` protocol.
      return ""
    }
    return string
  }

  /// Converts this `String` to data using `.utf8`.
  public func convertToData() -> Data {
    Data(utf8)
  }

}

// MARK: - Array + LosslessDataConvertible

extension [UInt8]: LosslessDataConvertible {
  /// Converts `Data` to `[UInt8]`.
  public static func convertFromData(_ data: Data) -> [UInt8] { .init(data) }

  /// Converts this `[UInt8]` to `Data`.
  public func convertToData() -> Data { .init(self) }

}

// MARK: - Data + LosslessDataConvertible

extension Data: LosslessDataConvertible {
  /// `LosslessDataConvertible` conformance.
  public static func convertFromData(_ data: Data) -> Data { data }

  /// `LosslessDataConvertible` conformance.
  public func convertToData() -> Data { self }

}
