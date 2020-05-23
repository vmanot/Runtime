//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct MemoryLayout {
        private let typeMetadata: SwiftRuntimeGenericMetadata
        
        public init(_ type: Any.Type) {
            self.typeMetadata = SwiftRuntimeGenericMetadata(base: type)
        }
    }
}

// MARK: - Extensions -

extension TypeMetadata.MemoryLayout {
    public var size: Int {
        return typeMetadata.valueWitnessTable.pointee.size
    }
    
    public static func size(ofValue value: Any) -> Int {
        return OpaqueExistentialContainer.withUnretainedValue(value) {
            $0.type.memoryLayout.size
        }
    }
    
    public var stride: Int {
        return typeMetadata.valueWitnessTable.pointee.stride
    }

    public static func stride(ofValue value: Any) -> Int {
        return OpaqueExistentialContainer.withUnretainedValue(value) {
            $0.type.memoryLayout.stride
        }
    }
    
    public var alignment: Int {
        return typeMetadata.valueWitnessTable.pointee.alignment
    }
    
    public static func alignment(ofValue value: Any) -> Int {
        return OpaqueExistentialContainer.withUnretainedValue(value) {
            $0.type.memoryLayout.alignment
        }
    }
}

// MARK: - Protocol Implementations -

extension TypeMetadata.MemoryLayout: Equatable {
    public static func == (lhs: TypeMetadata.MemoryLayout, rhs: TypeMetadata.MemoryLayout) -> Bool {
        return true
            && lhs.size == lhs.size
            && lhs.stride == lhs.stride
            && lhs.alignment == lhs.alignment
    }
}

// MARK: - Helpers -

extension TypeMetadata {
    public var memoryLayout: TypeMetadata.MemoryLayout {
        return .init(value)
    }

    public var isSizeZero: Bool {
        return memoryLayout.size == 0
    }

    public var byteTupleRepresentation: TypeMetadata {
        return TypeMetadata(tupleWithTypes: Array<Any.Type>(repeating: Byte.self, count: memoryLayout.size))
    }
}

extension InitiableMutableRawBufferPointer {
    public static func allocate(for type: TypeMetadata) -> Self {
        return allocate(
            byteCount: type.memoryLayout.size,
            alignment: type.memoryLayout.alignment
        )
    }
}
