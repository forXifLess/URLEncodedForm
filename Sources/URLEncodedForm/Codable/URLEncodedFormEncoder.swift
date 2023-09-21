import Foundation

// MARK: - URLEncodedFormEncoder

/// Encodes `Encodable` instances to `application/x-www-form-urlencoded` data.
///
///     print(user) /// User
///     let data = try URLEncodedFormEncoder().encode(user)
///     print(data) /// Data
///
/// URL-encoded forms are commonly used by websites to send form data via POST requests. This encoding is relatively
/// efficient for small amounts of data but must be percent-encoded.  `multipart/form-data` is more efficient for sending
/// large data blobs like files.
///
/// See [Mozilla's](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST) docs for more information about
/// url-encoded forms.
public final class URLEncodedFormEncoder: DataEncoder {

  // MARK: Lifecycle

  /// Create a new `URLEncodedFormEncoder`.
  public init() { }

  // MARK: Public

  /// Encodes the supplied `Encodable` object to `Data`.
  ///
  ///     print(user) // User
  ///     let data = try URLEncodedFormEncoder().encode(user)
  ///     print(data) // "name=Vapor&age=3"
  ///
  /// - parameters:
  ///     - encodable: Generic `Encodable` object (`E`) to encode.
  /// - returns: Encoded `Data`
  /// - throws: Any error that may occur while attempting to encode the specified type.
  public func encode(_ encodable: some Encodable) throws -> Data {
    let context = URLEncodedFormDataContext(.dict([:]))
    let encoder = _URLEncodedFormEncoder(context: context, codingPath: [])
    try encodable.encode(to: encoder)
    let serializer = URLEncodedFormSerializer()
    guard case .dict(let dict) = context.data else {
      throw URLEncodedFormError(
        identifier: "invalidTopLevel",
        reason: "form-urlencoded requires a top level dictionary")
    }
    return try serializer.serialize(dict)
  }
}

// MARK: - _URLEncodedFormEncoder

/// MARK: Private

/// Private `Encoder`.
private final class _URLEncodedFormEncoder: Encoder {

  // MARK: Lifecycle

  /// Creates a new form url-encoded encoder
  init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
    self.context = context
    self.codingPath = codingPath
  }

  // MARK: Internal

  /// See `Encoder`
  let codingPath: [CodingKey]

  /// The data being decoded
  var context: URLEncodedFormDataContext

  /// See `Encoder`
  var userInfo: [CodingUserInfoKey: Any] {
    [:]
  }

  /// See `Encoder`
  func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key>
    where Key: CodingKey
  {
    let container = _URLEncodedFormKeyedEncoder<Key>(context: context, codingPath: codingPath)
    return .init(container)
  }

  /// See `Encoder`
  func unkeyedContainer() -> UnkeyedEncodingContainer {
    _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath)
  }

  /// See `Encoder`
  func singleValueContainer() -> SingleValueEncodingContainer {
    _URLEncodedFormSingleValueEncoder(context: context, codingPath: codingPath)
  }
}

// MARK: - _URLEncodedFormSingleValueEncoder

/// Private `SingleValueEncodingContainer`.
private final class _URLEncodedFormSingleValueEncoder: SingleValueEncodingContainer {

  // MARK: Lifecycle

  /// Creates a new single value encoder
  init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
    self.context = context
    self.codingPath = codingPath
  }

  // MARK: Internal

  /// See `SingleValueEncodingContainer`
  var codingPath: [CodingKey]

  /// The data being encoded
  let context: URLEncodedFormDataContext

  /// See `SingleValueEncodingContainer`
  func encodeNil() throws {
    // skip
  }

  /// See `SingleValueEncodingContainer`
  func encode(_ value: some Encodable) throws {
    if let convertible = value as? URLEncodedFormDataConvertible {
      try context.data.set(to: convertible.convertToURLEncodedFormData(), at: codingPath)
    } else {
      let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath)
      try value.encode(to: encoder)
    }
  }
}

// MARK: - _URLEncodedFormKeyedEncoder

/// Private `KeyedEncodingContainerProtocol`.
private final class _URLEncodedFormKeyedEncoder<K>: KeyedEncodingContainerProtocol where K: CodingKey {

  // MARK: Lifecycle

  /// Creates a new `_URLEncodedFormKeyedEncoder`.
  init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
    self.context = context
    self.codingPath = codingPath
  }

  // MARK: Internal

  /// See `KeyedEncodingContainerProtocol`
  typealias Key = K

  /// See `KeyedEncodingContainerProtocol`
  var codingPath: [CodingKey]

  /// The data being encoded
  let context: URLEncodedFormDataContext

  /// See `KeyedEncodingContainerProtocol`
  func encodeNil(forKey _: K) throws {
    // skip
  }

  /// See `KeyedEncodingContainerProtocol`
  func encode(_ value: some Encodable, forKey key: K) throws {
    if let convertible = value as? URLEncodedFormDataConvertible {
      try context.data.set(to: convertible.convertToURLEncodedFormData(), at: codingPath + [key])
    } else {
      let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath + [key])
      try value.encode(to: encoder)
    }
  }

  /// See `KeyedEncodingContainerProtocol`
  func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey>
    where NestedKey: CodingKey
  {
    .init(_URLEncodedFormKeyedEncoder<NestedKey>(context: context, codingPath: codingPath + [key]))
  }

  /// See `KeyedEncodingContainerProtocol`
  func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
    _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath + [key])
  }

  /// See `KeyedEncodingContainerProtocol`
  func superEncoder() -> Encoder {
    _URLEncodedFormEncoder(context: context, codingPath: codingPath)
  }

  /// See `KeyedEncodingContainerProtocol`
  func superEncoder(forKey key: K) -> Encoder {
    _URLEncodedFormEncoder(context: context, codingPath: codingPath + [key])
  }

}

// MARK: - _URLEncodedFormUnkeyedEncoder

/// Private `UnkeyedEncodingContainer`.
private final class _URLEncodedFormUnkeyedEncoder: UnkeyedEncodingContainer {

  // MARK: Lifecycle

  /// Creates a new `_URLEncodedFormUnkeyedEncoder`.
  init(context: URLEncodedFormDataContext, codingPath: [CodingKey]) {
    self.context = context
    self.codingPath = codingPath
    count = 0
  }

  // MARK: Internal

  /// See `UnkeyedEncodingContainer`.
  var codingPath: [CodingKey]

  /// See `UnkeyedEncodingContainer`.
  var count: Int

  /// The data being encoded
  let context: URLEncodedFormDataContext

  /// Converts the current count to a coding key
  var index: CodingKey {
    BasicKey(count)
  }

  /// See `UnkeyedEncodingContainer`.
  func encodeNil() throws {
    // skip
  }

  /// See UnkeyedEncodingContainer.encode
  func encode(_ value: some Encodable) throws {
    defer { count += 1 }
    if let convertible = value as? URLEncodedFormDataConvertible {
      try context.data.set(to: convertible.convertToURLEncodedFormData(), at: codingPath + [index])
    } else {
      let encoder = _URLEncodedFormEncoder(context: context, codingPath: codingPath + [index])
      try value.encode(to: encoder)
    }
  }

  /// See UnkeyedEncodingContainer.nestedContainer
  func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>
    where NestedKey: CodingKey
  {
    defer { count += 1 }
    return .init(_URLEncodedFormKeyedEncoder<NestedKey>(context: context, codingPath: codingPath + [index]))
  }

  /// See UnkeyedEncodingContainer.nestedUnkeyedContainer
  func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
    defer { count += 1 }
    return _URLEncodedFormUnkeyedEncoder(context: context, codingPath: codingPath + [index])
  }

  /// See UnkeyedEncodingContainer.superEncoder
  func superEncoder() -> Encoder {
    defer { count += 1 }
    return _URLEncodedFormEncoder(context: context, codingPath: codingPath + [index])
  }
}
