//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

extension ObjCMethodInvocation {
    public struct Payload {
        public var target: ObjCObject
        public var selector: ObjCSelector
        public var arguments: [AnyObjCCodable]
        
        public init(target: ObjCObject, selector: ObjCSelector, arguments: [AnyObjCCodable]) {
            self.target = target
            self.selector = selector
            self.arguments = arguments
        }
    }
}

extension ObjCMethodInvocation.Payload: Collection2, CustomStringConvertible, ImplementationForwardingWrapper {
    public typealias Element = Value.Element
    public typealias Index = Value.Index
    public typealias Iterator = Value.Iterator
    public typealias SubSequence = Value.SubSequence
    public typealias Value = [AnyObjCCodable]

    public var value: Value {
        return [.init(target), .init(selector)] + arguments
    }
    
    public init(_ value: Value) {
        self.init(
            target: try! cast(value[0]),
            selector: try! cast(value[1]),
            arguments: .init(value.dropFirst(2))
        )
    }
}
