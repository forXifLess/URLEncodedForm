import Foundation

/// Represents application/x-www-form-urlencoded encoded data.
enum URLEncodedFormData: Equatable {

  case dict([String: URLEncodedFormData])

  case str(String)

  case arr([URLEncodedFormData])

}

extension URLEncodedFormData: NestedData {
  static func dictionary(_ value: [String : URLEncodedFormData]) -> URLEncodedFormData {
    return .dict(value)
  }

  static func array(_ value: [URLEncodedFormData]) -> URLEncodedFormData {
    return .arr(value)
  }

  var string: String? {
    switch self {
    case .str(let item): return item
    default: return .none
    }
  }

  var url: URL? {
    switch self {
    case .str(let item): return .init(string: item)
    default: return .none
    }
  }

  var array: [URLEncodedFormData]? {
    switch self {
    case .arr(let list): return list
    default: return .none
    }
  }

  var dictionary: [String : URLEncodedFormData]? {
    switch self {
    case .dict(let map): return map
    default: return .none
    }
  }
}

extension URLEncodedFormData: ExpressibleByArrayLiteral, ExpressibleByStringLiteral, ExpressibleByDictionaryLiteral {
  init(arrayLiteral elements: URLEncodedFormData...) {
    self = .arr(elements)
  }

  init(stringLiteral value: String) {
    self = .str(value)
  }

  init(dictionaryLiteral elements: (String, URLEncodedFormData)...) {
    self = .dict(
      elements.reduce([:]) { curr, next in
        curr.merging([next.0: next.1]) { $1 }
      }
    )
  }
}
