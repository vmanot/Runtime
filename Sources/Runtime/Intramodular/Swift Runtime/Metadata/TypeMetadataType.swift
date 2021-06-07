//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _opaque_TypeMetadataType: _opaque_Hashable {
    var base: Any.Type { get }
    
    init(_unsafe base: Any.Type)
    init?(_ base: Any.Type)
}

/// A `TypeMetadata`-like type.
public protocol TypeMetadataType: _opaque_TypeMetadataType, Hashable {
    var base: Any.Type { get }
    
    /// The supertype of this type, if any.
    var supertypeMetadata: Self? { get }
    
    init(_unsafe base: Any.Type)
    init?(_ base: Any.Type)
}

public protocol _opaque_NominalTypeMetadataType: _opaque_TypeMetadataType {
    /// The mangled name of this type.
    var mangledName: String { get }
    
    /// The field layout of this type.
    var fields: [NominalTypeMetadata.Field] { get }
}

/// A `NominalTypeMetadata`-like type.
public protocol NominalTypeMetadataType: _opaque_NominalTypeMetadataType, CustomStringConvertible, TypeMetadataType {
    var mangledName: String { get }
    
    var supertypeFields: [NominalTypeMetadata.Field]? { get }
    var fields: [NominalTypeMetadata.Field] { get }
}

// MARK: - Implementation -

extension CustomStringConvertible where Self: TypeMetadataType {
    public var description: String {
        String(describing: base)
    }
}

extension Equatable where Self: TypeMetadataType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
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

extension NominalTypeMetadataType {
    public var supertypeFields: [NominalTypeMetadata.Field]? {
        supertypeMetadata?.fields
    }
}

// MARK: - Extensions -

extension TypeMetadataType {
    public var isSwiftObject: Bool {
        ObjCClass(base)?.isSwiftObject ?? false
    }
    
    public static func of<T>(_ value: T) -> Self {
        Self(type(of: value as Any))!
    }
}

extension NominalTypeMetadataType {
    public var allFields: [NominalTypeMetadata.Field] {
        (supertypeMetadata?.allFields ?? []) + fields
    }
}
