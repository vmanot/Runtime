//
// Copyright (c) Vatsal Manot
//

import Swift

public protocol MirrorType {
    associatedtype SupertypeMirror: MirrorType
    
    var supertypeMirror: SupertypeMirror? { get }
}

// MARK: - Concrete Implementations -

extension Mirror: MirrorType {
    public var supertypeMirror: Mirror? {
        superclassMirror
    }
}
