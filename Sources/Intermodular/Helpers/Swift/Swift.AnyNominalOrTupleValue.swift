//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct AnyNominalOrTupleValue: FailableWrapper {
    public typealias Value = Any
    
    public var value: Value
    public var typeMetadata: TypeMetadata.NominalOrTuple
    
    public var supervalue: AnyNominalOrTupleValue? {
        guard let type = (typeMetadata.value as? AnyClass).map(ObjCClass.init) else {
            return nil
        }
        
        guard let supertype = type.superclass else {
            return nil
        }
        
        return .init(unchecked: value, typeMetadata: .init(uncheckedValue: supertype.value))
    }
    
    init(
        unchecked value: Value,
        typeMetadata: TypeMetadata.NominalOrTuple
    ) {
        self.value = value
        self.typeMetadata = typeMetadata
    }
    
    public init(unchecked value: Value) {
        self.init(unchecked: value, typeMetadata: .init(uncheckedValue: type(of: value)))
    }
    
    public init?(_ value: Value) {
        guard let _ = TypeMetadata.NominalOrTuple(type(of: value)) else {
            return nil
        }
        
        self.init(unchecked: value)
    }
}

// MARK: - Protocol Implementations -

extension AnyNominalOrTupleValue: CustomStringConvertible {
    public var description: String {
        return String(describing: value)
    }
}

extension AnyNominalOrTupleValue: KeyExposingMutableDictionaryProtocol {
    public var keys: [AnyStringKey] {
        return typeMetadata.fields.map({ .init(stringValue: $0.name) })
    }
    
    public subscript(_ key: AnyStringKey) -> Any? {
        get {
            return typeMetadata
                .fields
                .index(of: { $0.name == key.stringValue })
                .map({ self[$0] })
        } set {
            typeMetadata
                .fields
                .index(of: { $0.name == key.stringValue })
                .map({ self[$0] = try! newValue.unwrap() })
        }
    }
}

extension AnyNominalOrTupleValue: Sequence {
    public typealias Element = (key: AnyStringKey, value: Any)
    
    public subscript(index: Int) -> Any {
        get {
            let field = typeMetadata.fields[index]
            
            return OpaqueExistentialContainer.withUnretainedValue(value) {
                $0.withUnsafeBytes { bytes in
                    field.type.opaqueExistentialInterface.copyValue(
                        from: bytes.baseAddress?.advanced(by: field.offset)
                    )
                }
            }
        } set {
            let field = typeMetadata.fields[index]
            
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
    
    public func makeIterator() -> AnyIterator<Element> {
        AnyIterator(keys.lazy.map(({ ($0, self[$0]!) })).makeIterator())
    }
}
