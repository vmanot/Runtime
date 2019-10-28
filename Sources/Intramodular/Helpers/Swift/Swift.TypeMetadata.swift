//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct TypeMetadata: Wrapper {
    public typealias Value = Any.Type
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }

    public init(of x: Any) {
        self.init(type(of: x))
    }
}

// MARK: - Protocol Implementations -

extension TypeMetadata: CustomStringConvertible {
    public var description: String {
        return String(describing: value)
    }
}

extension TypeMetadata: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(value))
    }
}

extension TypeMetadata: MetatypeRepresentable {
    public init(metatype: Any.Type) {
        self.init(metatype)
    }
    
    public func toMetatype() -> Any.Type {
        return value
    }
}
