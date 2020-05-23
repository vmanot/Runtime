//
// Copyright (c) Vatsal Manot
//

import Swallow

extension AnyProtocol {
    public static func Array_Self() -> Any.Type {
        return Array<Self>.self
    }
    
    public static func UnsafePointer_Self() -> Any.Type {
        return UnsafePointer<Self>.self
    }
    
    public static func UnsafeMutablePointer_Self() -> Any.Type {
        return UnsafeMutablePointer<Self>.self
    }
}
