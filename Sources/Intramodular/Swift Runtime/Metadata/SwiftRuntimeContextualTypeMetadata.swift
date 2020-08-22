//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

private final class _DummyClass { }

extension SwiftRuntimeTypeMetadata where MetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    var isGeneric: Bool {
        (metadata.pointee.contextDescriptor.pointee.flags & 0x80) != 0
    }
    
    func mangledName() -> String {
        String(cString: metadata.pointee.contextDescriptor.pointee.mangledName.advanced())
    }
    
    func numberOfFields() -> Int {
        guard base != class_getSuperclass(_DummyClass.self) else {
            return 0
        }
        
        return Int(metadata.pointee.contextDescriptor.pointee.numberOfFields)
    }
    
    func fieldOffsets() -> [Int] {
        guard base != class_getSuperclass(_DummyClass.self) else {
            return []
        }
        
        return metadata
            .pointee
            .contextDescriptor
            .pointee
            .fieldOffsetVectorOffset
            .vector(metadata: basePointer.assumingMemoryBound(to: Int.self), count: numberOfFields())
            .map(numericCast)
    }
    
    func genericArguments() -> UnsafeBufferPointer<Any.Type> {
        guard isGeneric else {
            return .init(start: nil, count: 0)
        }
        
        let count = metadata
            .pointee
            .contextDescriptor
            .pointee
            .genericContextHeader
            .base
            .numberOfParams
        
        return UnsafeBufferPointer(start: genericArgumentVector(), count: count)
    }
    
    func genericArgumentVector() -> UnsafePointer<Any.Type> {
        return basePointer
            .assumingMemoryBound(to: UnsafeRawPointer.self)
            .advanced(by: metadata.pointee.genericArgumentOffset)
            .assumingMemoryBound(to: Any.Type.self)
    }
    
    var fields: [NominalTypeMetadata.Field] {
        let offsets = fieldOffsets()
        let fieldDescriptor = metadata.pointee.contextDescriptor.pointee
            .fieldDescriptor
            .advanced()
        
        let genericVector = genericArgumentVector()
        
        return (0..<numberOfFields()).map { index in
            let record = fieldDescriptor
                .pointee
                .fields
                .element(at: index)
            
            return NominalTypeMetadata.Field(
                name: record.pointee.fieldName(),
                type: TypeMetadata(
                    record.pointee.type(
                        genericContext: metadata.pointee.contextDescriptor,
                        genericArguments: genericVector
                    )
                ),
                offset: offsets[index]
            )
        }
    }
}
