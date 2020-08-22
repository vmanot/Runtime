//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct AnyNominalOrTupleMirror: MirrorType, FailableWrapper {
    public var value: Any
    public var typeMetadata: TypeMetadata.NominalOrTuple
    
    public var supertypeMirror: AnyNominalOrTupleMirror? {
        guard let supertypeMetadata = typeMetadata.supertypeMetadata else {
            return nil
        }
        
        return .init(
            unchecked: value,
            typeMetadata: supertypeMetadata
        )
    }
    
    init(
        unchecked value: Any,
        typeMetadata: TypeMetadata.NominalOrTuple
    ) {
        self.value = value
        self.typeMetadata = typeMetadata
    }
    
    public init(unchecked value: Value) {
        self.init(unchecked: value, typeMetadata: .of(value))
    }
    
    public init?(_ value: Value) {
        guard let _ = TypeMetadata.NominalOrTuple(type(of: value)) else {
            return nil
        }
        
        self.init(unchecked: value)
    }
}

// MARK: - Protocol Implementations -

extension AnyNominalOrTupleMirror: CustomStringConvertible {
    public var description: String {
        return String(describing: value)
    }
}

extension AnyNominalOrTupleMirror: KeyExposingMutableDictionaryProtocol {
    public var keys: [AnyStringKey] {
        typeMetadata.fields.map({ .init(stringValue: $0.name) })
    }
    
    public subscript(field: NominalTypeMetadata.Field) -> Any {
        get {
            return OpaqueExistentialContainer.withUnretainedValue(value) {
                $0.withUnsafeBytes { bytes in
                    field.type.opaqueExistentialInterface.copyValue(
                        from: bytes.baseAddress?.advanced(by: field.offset)
                    )
                }
            }
        } set {
            OpaqueExistentialContainer.withUnretainedValue(&value) {
                $0.withUnsafeMutableBytes { bytes in
                    field.type.opaqueExistentialInterface.reinitializeValue(
                        at: bytes.baseAddress?.advanced(by: field.offset),
                        to: newValue
                    )
                }
            }
        }
    }
    
    public subscript(_ key: AnyStringKey) -> Any? {
        get {
            return typeMetadata
                .allFields
                .first(where: { $0.key == key })
                .map({ self[$0] })
        } set {
            typeMetadata
                .allFields
                .first(where: { $0.key == key })
                .map({ self[$0] = try! newValue.unwrap() })
        }
    }
}

extension AnyNominalOrTupleMirror: Sequence {
    public typealias Element = (key: AnyStringKey, value: Any)
    public typealias Children = AnySequence<Element>
    public typealias AllChildren = AnySequence<Element>
    
    public var children: Children {
        .init(self)
    }
    
    public var allChildren: Children {
        guard let supertypeMirror = supertypeMirror else {
            return children
        }
        
        return .init(supertypeMirror.children.join(children))
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        AnyIterator(keys.lazy.map(({ ($0, self[$0]!) })).makeIterator())
    }
}
