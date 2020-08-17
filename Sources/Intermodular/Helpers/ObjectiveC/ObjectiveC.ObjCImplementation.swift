//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCImplementation: _opaque_Hashable, Hashable, ImplementationForwardingMutableWrapper {
    public typealias Value = IMP
    
    public var value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

extension ObjCImplementation {
    public var blockView: ObjCBlock? {
        @inlinable
        get {
            return ObjCBlock(nilIfNil: imp_getBlock(value) as? ObjCObject)
        } set {
            _ = newValue
                .map({ value = imp_implementationWithBlock($0.value) })
                .or(try! removeBlock())
        }
    }
    
    @inlinable
    public init?(block: ObjCBlock) {
        self.init(imp_implementationWithBlock(block.value))
    }
    
    @discardableResult
    public func removeBlock() throws -> ObjCBlock? {
        let result = blockView
        try imp_removeBlock(value).orThrow()
        return result
    }
}

// MARK: - Helpers -

extension ObjCMethod {
    public var implementation: ObjCImplementation {
        get {
            return .init(method_getImplementation(value))
        }
        
        nonmutating set {
            method_setImplementation(value, newValue.value)
        }
    }
    
    public func exchangeImplementations(with other: ObjCMethod) {
        method_exchangeImplementations(value, other.value)
    }
}
