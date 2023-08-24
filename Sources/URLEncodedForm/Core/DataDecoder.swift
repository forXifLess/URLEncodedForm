import Foundation

/// A type capable of decoding `Decodable` types from `Data`.
///
///     print(data) /// Data
///     let user = try JSONDecoder().decode(User.self, from: data)
///     print(user) /// User
///
///
public protocol DataDecoder {
  /// Decodes an instance of the supplied `Decodable` type from `Data`.
  ///
  ///     print(data) /// Data
  ///     let user = try JSONDecoder().decode(User.self, from: data)
  ///     print(user) /// User
  ///
  /// - parameters:
  ///     - decodable: Generic `Decodable` type (`D`) to decode.
  ///     - from: `Data` to decode a `D` from.
  /// - returns: An instance of the `Decodable` type (`D`).
  /// - throws: Any error that may occur while attempting to decode the specified type.
  func decode<D>(_ decodable: D.Type, from data: Data) throws -> D where D: Decodable
}


extension DataDecoder {
  /// Convenience method for decoding a `Decodable` type from something `LosslessDataConvertible`.
  ///
  ///
  ///     print(data) /// LosslessDataConvertible
  ///     let user = try JSONDecoder().decode(User.self, from: data)
  ///     print(user) /// User
  ///
  /// - parameters:
  ///     - decodable: Generic `Decodable` type (`D`) to decode.
  ///     - from: `LosslessDataConvertible` to decode a `D` from.
  /// - returns: An instance of the `Decodable` type (`D`).
  /// - throws: Any error that may occur while attempting to decode the specified type.
  public func decode<D>(_ decodable: D.Type, from data: LosslessDataConvertible) throws -> D where D: Decodable {
    return try decode(D.self, from: data.convertToData())
  }
}

extension JSONDecoder: DataDecoder { }
