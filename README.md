[![Swift](https://img.shields.io/badge/Swift-5.8-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.8-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

# URLEncodedForm
Parse and serialize url-encoded form data with Codable support.

## 🙏🏻 Notice
- This is an (En/De)coder that converts URL query item parameters to Codable.
- The original source has been modified to use the url-encoded-form created by [the Vapor team](https://github.com/vapor/url-encoded-form) through Foundation.

## Installation
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/interactord/URLEncodedForm", .upToNextMajor(from: "1.0.0"))
]
```

## ✍🏻 Usage

It supports Codable provided by the Swift Foundation.

```swift
struct MyInfo: Codable {
  let height: Double
  let name: String
  let friends: [String]
  let family: Family

  struct Family: Codable {
    let names: [String]
  }
}

do {
  let data = try URLEncodedFormEncoder().encode(me)
  print(String(data: data, encoding: .utf8) ?? "nil")

  let origin = "name=Scott&height=172.2&friends[]=tom&friends[]=john&friends[]=mike&family[names][]=Father&family[names][]=Mother&family[names][]=Brother"
  let obj = try URLEncodedFormDecoder().decode(MyInfo.self, from: origin)
  print(obj)
} catch {
  print(error)
}
```

## License

URLEncodedForm is released under the MIT license. [See LICENSE](https://github.com/interactord/URLEncodedForm/blob/main/LICENSE) for details.



