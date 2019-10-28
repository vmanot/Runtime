//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCPropertyAttributeKeyValuePair: CustomStringConvertible, Wrapper {
    public typealias Value = objc_property_attribute_t
    
    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    public init(name: String, value: String) {
        self.init(.init(name: name, value: value))
    }
}

// MARK: - Protocol Implementations -

extension ObjCPropertyAttributeKeyValuePair: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(rawValue)
    }
}

extension ObjCPropertyAttributeKeyValuePair: Named {
    public var name: String {
        get {
            return String(utf8String: value.name)
        } set {
            value.name = .init(newValue.nullTerminatedUTF8String())
        }
    }
}

extension ObjCPropertyAttributeKeyValuePair: RawRepresentable2 {
    public typealias RawValue = String

    public var rawValue: RawValue {
        get {
            return String(utf8String: value.value).initializedIfNil
        } set {
            value.value = newValue
                .nullTerminatedUTF8String()
                .value
                .immutableRepresentation
        }
    }
    
    public init?(rawValue: RawValue) {
        self = impossible() // such is life
    }
}
