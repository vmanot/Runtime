//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public typealias Nominal = NominalTypeMetadata
}

public struct NominalTypeMetadata: NominalTypeMetadataType {
    public let base: Any.Type
    
    public var mangledName: String {
        (TypeMetadata(base).typed as! _opaque_NominalTypeMetadataType).mangledName
    }
    
    public var fields: [Field] {
        return (TypeMetadata(base).typed as! _opaque_NominalTypeMetadataType).fields
    }
    
    public init?(_ base: Any.Type) {
        guard TypeMetadata(base).typed is _opaque_NominalTypeMetadataType else {
            return nil
        }
        
        self.base = base
    }
}

// MARK: - Protocol Conformances -

extension TypeMetadata.Nominal: RandomAccessCollection {
    public typealias Index = Int
    
    public var startIndex: Index {
        return fields.startIndex
    }
    
    public var endIndex: Index {
        return fields.endIndex
    }
    
    public subscript(position: Index) -> Element {
        return fields[position]
    }
}

extension TypeMetadata.Nominal: Sequence {
    public typealias Element = Iterator.Element
    public typealias Iterator = Array<Field>.Iterator
    
    public func makeIterator() -> Iterator {
        return fields.makeIterator()
    }
}
