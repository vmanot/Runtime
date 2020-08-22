//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public typealias Nominal = NominalTypeMetadata
}

public struct NominalTypeMetadata: FailableWrapper {
    public let value: Any.Type
    
    public var fields: [Field] {
        return (TypeMetadata(value).typed as! NominalTypeMetadataProtocol).fields
    }
    
    public init?(_ value: Any.Type) {
        guard TypeMetadata(value).typed is NominalTypeMetadataProtocol else {
            return nil
        }
        
        self.value = value
    }
    
    public static func of<T>(_ value: T) -> Self {
        .init(uncheckedValue: type(of: value))
    }
}

// MARK: - Protocol Implementations -

extension TypeMetadata.Nominal: CustomStringConvertible {
    public var description: String {
        return String(describing: value)
    }
}

extension TypeMetadata.Nominal: RandomAccessCollection2 {
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
