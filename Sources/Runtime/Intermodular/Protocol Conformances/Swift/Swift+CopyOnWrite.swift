//
// Copyright (c) Vatsal Manot
//

import Swallow

extension Array: CopyOnWrite {
    public var isUniquelyReferenced: Bool {
        mutating get {
            isKnownUniquelyReferenced(&UnsafeMutablePointer.to(&self).assumingMemoryBound(to: AnyObject.self).pointee)
        }
    }

    public mutating func makeUniquelyReferenced() {
        self = .init(fauxRandomAccessView)
    }
}

extension ContiguousArray: CopyOnWrite {
    public var isUniquelyReferenced: Bool {
        mutating get {
            isKnownUniquelyReferenced(&UnsafeMutablePointer.to(&self).assumingMemoryBound(to: AnyObject.self).pointee)
        }
    }

    public mutating func makeUniquelyReferenced() {
        self = .init(fauxRandomAccessView)
    }
}

extension Dictionary: CopyOnWrite {
    public var isUniquelyReferenced: Bool {
        mutating get {
            isKnownUniquelyReferenced(&UnsafeMutablePointer.to(&self).assumingMemoryBound(to: AnyObject.self).pointee)
        }
    }

    public mutating func makeUniquelyReferenced() {
        self = .init(fauxRandomAccessView)
    }
}

extension Set: CopyOnWrite {
    public var isUniquelyReferenced: Bool {
        mutating get {
            isKnownUniquelyReferenced(&UnsafeMutablePointer.to(&self).assumingMemoryBound(to: AnyObject.self).pointee)
        }
    }

    public mutating func makeUniquelyReferenced() {
        self = .init(fauxRandomAccessView)
    }
}
