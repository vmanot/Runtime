//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCMethodSignature: CustomStringConvertible, Hashable, ImplementationForwardingWrapper {
    public typealias Value = String
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - Extensions -

extension ObjCMethodSignature {
    public var returnType: ObjCTypeEncoding {
        return ObjCTypeEncoding(returnTypeFrom: toNSMethodSignature())
    }

    public var isVoidReturn: Bool {
        return returnType == .void
    }
}

extension ObjCMethodSignature {
    var isSpecialStructReturn: Bool {
        return toNSMethodSignature().debugDescription.contains("is special struct return? YES")
    }

    public func toNSMethodSignature() -> NSMethodSignatureProtocol {
        return (-*>ObjCClass(name: "NSMethodSignature") as NSMethodSignatureProtocol.Type).signatureWithObjCTypes(value)
    }
    
    public func toEmptyNSInvocation() -> NSInvocationProtocol {
        return (-*>ObjCClass(name: "NSInvocation") as NSInvocationProtocol.Type).invocationWithMethodSignature(toNSMethodSignature())
    }
}
