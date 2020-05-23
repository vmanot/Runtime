//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct SwiftRuntimeUnsafeRelativePointer<Offset: BinaryInteger, Pointee> {
    public var offset: Offset
    
    public mutating func pointee() -> Pointee {
        return advanced().pointee
    }
    
    public mutating func advanced() -> UnsafeMutablePointer<Pointee> {
        let offsetCopy = self.offset
        return withUnsafePointer(to: &self) {
            return $0
                .rawRepresentation
                .advanced(by: Int(offsetCopy))
                .assumingMemoryBound(to: Pointee.self)
                .mutableRepresentation
        }
    }
}

public struct SwiftRuntimeUnsafeRelativeVectorPointer<Offset: BinaryInteger, Pointee> {
    public var offset: Offset
    
    public mutating func vector<N: BinaryInteger>(metadata: UnsafePointer<Int>, count: N) -> [Pointee] {
        return .init(
            metadata
                .advanced(by: Int(offset))
                .rawRepresentation
                .assumingMemoryBound(to: Pointee.self)
                .buffer(withCount: Int(count))
        )
    }
}

public struct SwiftRuntimeUnsafeRelativeVector<Element> {
    var element: Element
    
    public mutating func vector<Integer: BinaryInteger>(count: Integer) -> [Element] {
        return withUnsafePointer(to: &self) {
            $0.withMemoryRebound(to: Element.self, capacity: 1) { start in
                return Array(start.buffer(withCount: count))
            }
        }
    }
    
    public mutating func element(at i: Int) -> UnsafeMutablePointer<Element> {
        return withUnsafePointer(to: &self) {
            $0.assumingMemoryBound(to: Element.self)
                .advanced(by: i)
                .mutableRepresentation
        }
    }
}

// MARK: - Protocol Implementations -

extension SwiftRuntimeUnsafeRelativePointer: CustomStringConvertible {
    public var description: String {
        return "\(offset)"
    }
}

extension SwiftRuntimeUnsafeRelativeVectorPointer: CustomStringConvertible {
    public var description: String {
        return "\(offset)"
    }
}
