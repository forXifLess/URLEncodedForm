import Foundation

// MARK: - DataEncoder

/// A type capable of encoding `Encodable` objects to `Data`.
///
///     print(user) /// User
///     let data = try JSONEncoder().encode(user)
///     print(data) /// Data
///
public protocol DataEncoder {
  /// Encodes the supplied `Encodable` object to `Data`.
  ///
  ///     print(user) /// User
  ///     let data = try JSONEncoder().encode(user)
  ///     print(data) /// Data
  ///
  /// - parameters:
  ///     - encodable: Generic `Encodable` object (`E`) to encode.
  /// - returns: Encoded `Data`
  /// - throws: Any error that may occur while attempting to encode the specified type.
  func encode<E>(_ encodable: E) throws -> Data where E: Encodable
}

// MARK: - JSONEncoder + DataEncoder

extension JSONEncoder: DataEncoder { }
