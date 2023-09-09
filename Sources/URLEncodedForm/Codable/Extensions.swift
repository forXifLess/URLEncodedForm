import Foundation

extension Decodable {

  public static func decoded(data: Data) -> Self? {
    try? URLEncodedFormDecoder().decode(Self.self, from: data)
  }
}

extension Encodable {
  public func encode() -> String {
    guard let data = try? URLEncodedFormEncoder().encode(self) else { return "" }
    return String(data: data, encoding: .utf8) ?? ""
  }
}


extension String {
  public func decoded<T: Decodable>() -> T? {
    return try? URLEncodedFormDecoder().decode(T.self, from: self)
  }
}
