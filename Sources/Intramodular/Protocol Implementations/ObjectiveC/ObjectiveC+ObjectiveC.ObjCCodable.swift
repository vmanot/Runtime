//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

extension ObjCClass: ObjCCodable {
    public var objCTypeEncoding: ObjCTypeEncoding {
        return .init("{\(name)=#}")
    }
    
    public init(decodingObjCValueFromRawBuffer buffer: UnsafeMutableRawPointer?, encoding: ObjCTypeEncoding) {
        self = buffer!.assumingMemoryBound(to: <<infer>>).pointee
    }
    
    public func encodeObjCValueToRawBuffer() -> UnsafeMutableRawPointer {
        return .init(UnsafeMutablePointer.allocate(initializingTo: self))
    }
}
