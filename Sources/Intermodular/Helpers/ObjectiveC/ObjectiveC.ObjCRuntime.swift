//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCRuntime {
    public enum Error: Swift.Error {
        case methodAlreadyExists
        case instanceMethodNotFound(for: ObjCSelector)
        case propertyNotFound(name: String)
        case unknown
    }
}

extension ObjCRuntime {
    static let _libobjcHandle = try! POSIXDynamicLibraryHandle.open(at: "/usr/lib/libobjc.A.dylib", .now)

    static var _objc_msgForward_stret: ObjCImplementation = {
        return .init(unsafeBitCast(_libobjcHandle.rawSymbolAddress(forName: "_objc_msgForward_stret"), to: IMP.self))
    }()

    static var _objc_msgForward: ObjCImplementation = {
        return .init(unsafeBitCast(_libobjcHandle.rawSymbolAddress(forName: "_objc_msgForward"), to: IMP.self))
    }()
}
