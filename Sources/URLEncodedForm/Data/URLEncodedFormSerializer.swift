import Foundation

// MARK: - URLEncodedFormSerializer

/// Converts `[String: URLEncodedFormData]` structs to `Data`.
final class URLEncodedFormSerializer {

  // MARK: Lifecycle

  /// Create a new form-urlencoded data serializer.
  init() { }

  // MARK: Internal

  /// Default form url encoded serializer.
  static let `default` = URLEncodedFormSerializer()

  /// Serializes the data.
  func serialize(_ URLEncodedFormEncoded: [String: URLEncodedFormData]) throws -> Data {
    var data: [Data] = []
    for (key, val) in URLEncodedFormEncoded {
      let key = try key.urlEncodedFormEncoded()
      let subdata = try serialize(val, forKey: key)
      data.append(subdata)
    }
    return data.joinedWithAmpersands()
  }

  // MARK: Private

  /// Serializes a `URLEncodedFormData` at a given key.
  private func serialize(_ data: URLEncodedFormData, forKey key: Data) throws -> Data {
    let encoded: Data
    switch data {
    case .arr(let subArray): encoded = try serialize(subArray, forKey: key)
    case .dict(let subDict): encoded = try serialize(subDict, forKey: key)
    case .str(let string): encoded = try key + [.equals] + string.urlEncodedFormEncoded()
    }
    return encoded
  }

  /// Serializes a `[String: URLEncodedFormData]` at a given key.
  private func serialize(_ dictionary: [String: URLEncodedFormData], forKey key: Data) throws -> Data {
    let values = try dictionary.map { subKey, value -> Data in
      let keyPath = try [.leftSquareBracket] + subKey.urlEncodedFormEncoded() + [.rightSquareBracket]
      return try serialize(value, forKey: key + keyPath)
    }
    return values.joinedWithAmpersands()
  }

  /// Serializes a `[URLEncodedFormData]` at a given key.
  private func serialize(_ array: [URLEncodedFormData], forKey key: Data) throws -> Data {
    let collection = try array.map { value -> Data in
      let keyPath = key + [.leftSquareBracket, .rightSquareBracket]
      return try serialize(value, forKey: keyPath)
    }

    return collection.joinedWithAmpersands()
  }
}

// MARK: Utilties

extension [Data] {
  /// Joins an array of `Data` with ampersands.
  fileprivate func joinedWithAmpersands() -> Data {
    Data(joined(separator: [.ampersand]))
  }
}

extension String {
  /// Prepares a `String` for inclusion in form-urlencoded data.
  fileprivate func urlEncodedFormEncoded() throws -> Data {
    guard let string = addingPercentEncoding(withAllowedCharacters: _allowedCharacters) else {
      throw URLEncodedFormError(identifier: "percentEncoding", reason: "Failed to percent encode string: \(self)")
    }

    guard let encoded = string.data(using: .utf8) else {
      throw URLEncodedFormError(identifier: "utf8Encoding", reason: "Failed to utf8 encode string: \(self)")
    }

    return encoded
  }
}

/// Characters allowed in form-urlencoded data.
private var _allowedCharacters: CharacterSet = {
  var allowed = CharacterSet.urlQueryAllowed
  allowed.remove(charactersIn: "?&=[];+")
  return allowed
}()
