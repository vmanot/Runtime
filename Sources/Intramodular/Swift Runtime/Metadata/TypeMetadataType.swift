//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _opaque_TypeMetadataType: _opaque_Hashable {
    var base: Any.Type { get }
    
    init(_unsafe base: Any.Type)
    init?(_ base: Any.Type)
}

public protocol TypeMetadataType: _opaque_TypeMetadataType, Hashable {
    var base: Any.Type { get }
    var supertypeMetadata: Self? { get }
    
    init(_unsafe base: Any.Type)
    init?(_ base: Any.Type)
}

public protocol _opaque_NominalTypeMetadataType: _opaque_TypeMetadataType {
    var mangledName: String { get }
    var fields: [NominalTypeMetadata.Field] { get }
}

public protocol NominalTypeMetadataType: _opaque_NominalTypeMetadataType, CustomStringConvertible, TypeMetadataType {
    var mangledName: String { get }
    var fields: [NominalTypeMetadata.Field] { get }
}

// MARK: - Implementation -

extension CustomStringConvertible where Self: TypeMetadataType {
    public var description: String {
        String(describing: base)
    }
}

extension Hashable where Self: TypeMetadataType {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(base))
    }
}

extension TypeMetadataType {
    public var supertypeMetadata: Self? {
        guard let value = (base as? AnyClass).map(ObjCClass.init) else {
            return nil
        }
        
        guard let superclass = value.superclass else {
            return nil
        }
        
        return .init(_unsafe: superclass.value)
    }
    
    public init(_unsafe base: Any.Type) {
        self = Self(base)!
    }
}

// MARK: - Extensions -

extension TypeMetadataType {
    public static func of<T>(_ value: T) -> Self {
        Self(type(of: value as Any))!
    }
}
