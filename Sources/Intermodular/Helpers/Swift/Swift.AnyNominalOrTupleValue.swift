//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct AnyNominalOrTupleValue: FailableWrapper {
    public typealias Value = Any
    
    public var value: Value
    
    public var valueType: TypeMetadata.NominalOrTuple {
        return TypeMetadata.NominalOrTuple(type(of: value))!
    }
    
    public init(unchecked value: Value) {
        self.value = value
    }
    
    public init?(_ value: Value) {
        guard let _ = TypeMetadata.NominalOrTuple(unsafeBitCast(value, to: OpaqueExistentialContainer.self).type.value) else {
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
    public typealias DictionaryKey = String
    public typealias DictionaryValue = Any
    
    public var keys: [String] {
        return valueType.fields.map({ $0.name })
    }
    
    public subscript(_ key: String) -> Any? {
        get {
            return valueType
                .fields
                .index(of: { $0.name == key })
                .map({ self[$0] })
        } set {
            valueType
                .fields
                .index(of: { $0.name == key })
                .map({ self[$0] = try! newValue.unwrap() })
        }
    }
}

extension AnyNominalOrTupleValue: RandomAccessCollection {
    public typealias Index = Int
    
    public var startIndex: Index {
        return valueType.fields.startIndex
    }
    
    public var endIndex: Index {
        return valueType.fields.endIndex
    }
    
    public subscript(index: Index) -> Any {
        get {
            let field = valueType.fields[index]
            
            return OpaqueExistentialContainer.withUnretainedValue(value) {
                $0.withUnsafeBytes { bytes in
                    OpaqueExistentialContainer(copyingBytesOfValueAt: (bytes.baseAddress! + field.offset), type: field.type).unretainedValue
                }
            }
        } set {
            let field = valueType.fields[index]
            
            OpaqueExistentialContainer.withUnretainedValue(&value) {
                $0.withUnsafeMutableBytes { bytes in
                    OpaqueExistentialContainer.withUnretainedValue(newValue) {
                        $0.reintializeValue(at: bytes.baseAddress?.advanced(by: field.offset))
                    }
                }
            }
        }
    }
}
