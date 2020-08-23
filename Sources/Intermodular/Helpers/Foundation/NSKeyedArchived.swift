//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

@propertyWrapper
public struct NSKeyedArchived<Value: NSCoding>: Codable {
    public var wrappedValue: Value
    
    @inlinable
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.init(wrappedValue: try Value.init(coder: try NSKeyedUnarchiver(forReadingFrom: try container.decode(Data.self))).unwrap())
    }
    
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: wrappedValue is NSSecureCoding))
    }
}

@propertyWrapper
public struct NSKeyedArchivedOptional<Value: NSCoding>: Codable {
    public var wrappedValue: Value?
    
    @inlinable
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
    
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(wrappedValue: nil)
        } else {
            self.init(wrappedValue: Value.init(coder: try NSKeyedUnarchiver(forReadingFrom: try container.decode(Data.self))))
        }
    }
    
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let wrappedValue = wrappedValue {
            try container.encode(try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: wrappedValue is NSSecureCoding))
        } else {
            try container.encodeNil()
        }
    }
}
