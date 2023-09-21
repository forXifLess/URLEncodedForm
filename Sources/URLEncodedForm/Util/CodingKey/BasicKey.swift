// MARK: - BasicKey

/// A basic `CodingKey` implementation.
public struct BasicKey: CodingKey {

  // MARK: Lifecycle

  /// Creates a new `BasicKey` from a `String.`
  public init(_ string: String) {
    stringValue = string
  }

  /// Creates a new `BasicKey` from a `Int.`
  ///
  /// These are usually used to specify array indexes.
  public init(_ int: Int) {
    intValue = int
    stringValue = int.description
  }

  /// See `CodingKey`.
  public init?(stringValue: String) {
    self.stringValue = stringValue
  }

  /// See `CodingKey`.
  public init?(intValue: Int) {
    self.intValue = intValue
    stringValue = intValue.description
  }

  // MARK: Public

  /// See `CodingKey`.
  public var stringValue: String

  /// See `CodingKey`.
  public var intValue: Int?
}

// MARK: - BasicKeyRepresentable

/// Capable of being represented by a `BasicKey`.
public protocol BasicKeyRepresentable {
  /// Converts this type to a `BasicKey`.
  func makeBasicKey() -> BasicKey
}

// MARK: - String + BasicKeyRepresentable

extension String: BasicKeyRepresentable {
  /// See `BasicKeyRepresentable`
  public func makeBasicKey() -> BasicKey {
    BasicKey(self)
  }
}

// MARK: - Int + BasicKeyRepresentable

extension Int: BasicKeyRepresentable {
  /// See `BasicKeyRepresentable`
  public func makeBasicKey() -> BasicKey {
    BasicKey(self)
  }
}

extension [BasicKeyRepresentable] {
  /// Converts an array of `BasicKeyRepresentable` to `[BasicKey]`
  public func makeBasicKeys() -> [BasicKey] {
    map { $0.makeBasicKey() }
  }
}
