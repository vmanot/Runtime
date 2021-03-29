//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

@frozen
public struct OpaqueExistentialContainer: CustomDebugStringConvertible {
    @frozen
    public struct Buffer: MutableWrapper, Trivial {
        public typealias Value = (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?)
        
        public var value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public init() {
            value = (nil, nil, nil)
        }
    }
    
    public enum Error: Swift.Error {
        case runtimeCastError
    }
    
    public static var headerSize: Int {
        if CPU.Architecture.is64Bit {
            return 16
        } else {
            return 8
        }
    }
    
    public var buffer: Buffer
    public var type: TypeMetadata
    
    public init(buffer: Buffer, type: TypeMetadata) {
        self.buffer = buffer
        self.type = type
    }
    
    public init(unitialized type: TypeMetadata) {
        self.init(buffer: .init(), type: type)
    }
}

// MARK: - Extensions -

extension OpaqueExistentialContainer {
    public func getUnretainedValue<T>() -> T {
        precondition(type.base == T.self)
        
        return unretainedValue as! T
    }
}

// MARK: - Conformances -

extension OpaqueExistentialContainer: MutableContiguousStorage {
    public typealias Element = Byte
    
    public func withBufferPointer<BP: InitiableBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        var container = self
        
        return try container.withMutableBufferPointer({ try body($0) })
    }
    
    @_transparent
    public mutating func withMutableBufferPointer<BP: InitiableBufferPointer, T>(_ body: ((BP) throws -> T)) rethrows -> T where Element == BP.Element {
        let result: T
        
        if type.kind == .class {
            let classType: AnyClass = type.base as! AnyClass
            result = try body(BP(start: buffer.value.0, count: class_getInstanceSize(classType)))
        } else if type.kind == .struct || type.kind == .tuple {
            if type.memoryLayout.size > MemoryLayout<Buffer>.size {
                result = try body(BP(start: buffer.value.0?.advanced(by: OpaqueExistentialContainer.headerSize), count: type.memoryLayout.size))
            } else {
                result = try buffer.withUnsafeMutableBytes({ try body(BP(start: $0.baseAddress, count: type.memoryLayout.size)) })
            }
        } else {
            fatalError("unsupported kind: \(type.kind)")
        }
        
        return result
    }
}

extension OpaqueExistentialContainer: ObjCCodable {
    public var objCTypeEncoding: ObjCTypeEncoding {
        return ObjCTypeEncoding(metatype: type.base) ?? .unknown
    }
    
    public init(decodingObjCValueFromRawBuffer buffer: UnsafeMutableRawPointer?, encoding: ObjCTypeEncoding) {
        let type = TypeMetadata(encoding.toMetatype())
        
        if let buffer = buffer {
            if let type = type.base as? ObjCCodable.Type {
                let value: Any = type.init(decodingObjCValueFromRawBuffer: buffer, encoding: encoding)
                self = .passUnretained(value)
            } else {
                self.init(copyingBytesOfValueAt: buffer, type: type)
            }
        } else {
            assert(encoding.isSizeZero)
            
            self.init(unitialized: type)
        }
    }
    
    public func encodeObjCValueToRawBuffer() -> UnsafeMutableRawPointer {
        if type.base is AnyClass {
            return UnsafePointer
                .allocate(initializingTo: -*>buffer.value.0! as AnyObject)
                .mutableRawRepresentation
        } else if let value = takeUnretainedValue() as? ObjCCodable {
            return value.encodeObjCValueToRawBuffer()
        } else {
            return createRawCopy().baseAddress!
        }
    }
    
    public func deinitializeRawObjCValueBuffer(_ buffer: UnsafeMutableRawPointer) {
        if type.base is AnyClass {
            buffer.assumingMemoryBound(to: AnyObject.self).deinitialize(count: 1)
        }
    }
}

// MARK: - Auxiliary Extensions -

extension Array where Element == OpaqueExistentialContainer {
    public func combineCast(to type: TypeMetadata) throws -> OpaqueExistentialContainer {
        if count == 0 && type.memoryLayout.size == 0 {
            return OpaqueExistentialContainer(unitialized: type)
        } else if count == 1 && self[0].type == type {
            return self[0]
        } else if let tuple = TypeMetadata.Tuple(type.base), tuple.fields.map({ $0.type }) == map({ $0.type }) {
            return OpaqueExistentialContainer(type: type) { bytes in
                var offset = 0
                for element in self {
                    element.assignValue(to: bytes.baseAddress?.advanced(by: offset))
                    offset += element.type.memoryLayout.size
                }
            }
        } else {
            throw OpaqueExistentialContainer.Error.runtimeCastError
        }
    }
    
    public func combineUnsafeBitCast(to type: TypeMetadata) throws -> OpaqueExistentialContainer {
        if count == 0 && type.memoryLayout.size == 0 {
            return OpaqueExistentialContainer(unitialized: type)
        } else if count == 1 && self[0].type.memoryLayout == type.memoryLayout {
            return self[0]
        } else if let tuple = TypeMetadata.Tuple(type.base), tuple.fields.map({ $0.type.memoryLayout }) == map({ $0.type.memoryLayout }) {
            return OpaqueExistentialContainer(type: type) { bytes in
                var offset = 0
                for element in self {
                    element.assignValue(to: bytes.baseAddress?.advanced(by: offset))
                    offset += element.type.memoryLayout.size
                }
            }
        } else {
            throw OpaqueExistentialContainer.Error.runtimeCastError
        }
    }
}
