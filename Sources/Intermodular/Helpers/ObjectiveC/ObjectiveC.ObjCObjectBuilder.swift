//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCObjectBuilder<T: AnyObject>: Initiable {
    public var pseudoHeader: ObjCProtocol
    public var builtClass: ObjCClass
    
    public init() {
        TODO.unimplemented
    }
}

extension ObjCObjectBuilder {
    public func build() -> T! {
        return try? cast((builtClass.value as? Initiable.Type)?.init())
    }
}

extension ObjCObjectBuilder {
    public func implement(method selector: ObjCSelector, _ implementation: ObjCImplementation) throws {
        try pseudoHeader.allMethods.find({ $0.name == selector.rawValue }).map({ try builtClass.insert($0, implementation) })
    }
    
    public func reimplement(method selector: ObjCSelector, _ implementation: ObjCImplementation) throws {
         _ = try pseudoHeader.allMethods.find({ $0.name == selector.rawValue }).map({ try builtClass.replace($0, with: implementation) })
    }
}
