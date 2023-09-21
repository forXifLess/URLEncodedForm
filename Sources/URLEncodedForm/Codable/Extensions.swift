import Foundation

extension Decodable {

  public static func decodedObject(data: Data) -> Self? {
    try? URLEncodedFormDecoder().decode(Self.self, from: data)
  }
}

extension Encodable {
  public func encodeString() -> String {
    guard let data = try? URLEncodedFormEncoder().encode(self) else { return "" }
    return String(data: data, encoding: .utf8) ?? ""
  }
}

extension String {
  public func decodedObject<T: Decodable>() -> T? {
    try? URLEncodedFormDecoder().decode(T.self, from: self)
  }
}
