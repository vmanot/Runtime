//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCAssociationKey<T> {
    private let storage: HeapWrapper<ObjCAssociationPolicy>
    
    public var policy: ObjCAssociationPolicy {
        return storage.value
    }
    
    public init(policy: ObjCAssociationPolicy) {
        self.storage = .init(policy)
    }
}

// MARK: - Protocol Implementations -

extension ObjCAssociationKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension ObjCAssociationKey: Initiable {
    public init() {
        self.init(policy: .retain)
    }
}

extension ObjCAssociationKey: RawValueConvertible {
    public typealias RawValue = UnsafeRawPointer
    
    public var rawValue: RawValue {
        unsafeBitCast(storage, to: UnsafeRawPointer.self)
    }
}

// MARK: - Auxiliary Implementation -

public struct ObjCAssociation<Object: ObjCObject, AssociatedValue> {
    private weak var object: Object?
    private let key: ObjCAssociationKey<AssociatedValue>
    
    public init(object: Object?, key: ObjCAssociationKey<AssociatedValue>) {
        self.object = object
        self.key = key
    }
    
    public init(object: Object?, value: AssociatedValue) {
        self.object = object
        self.key = ObjCAssociationKey<AssociatedValue>()
        
        object?[key] = value
    }
    
    public func dissociate() {
        object?[key] = nil
    }
}
