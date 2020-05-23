//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow
import Swift

extension SwiftRuntimeTypeMetadata where MetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    var isGeneric: Bool {
        (metadata.pointee.contextDescriptor.pointee.flags & 0x80) != 0
    }
    
    func mangledName() -> String {
        String(cString: metadata.pointee.contextDescriptor.pointee.mangledName.advanced())
    }
    
    func numberOfFields() -> Int {
        Int(metadata.pointee.contextDescriptor.pointee.numberOfFields)
    }
    
    func fieldOffsets() -> [Int] {
        return metadata.pointee.contextDescriptor
            .pointee
            .fieldOffsetVectorOffset
            .vector(metadata: basePointer, count: numberOfFields())
            .map(numericCast)
    }
    
    func genericArguments() -> UnsafeMutableBufferPointer<Any.Type> {
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
        
        return UnsafeMutableBufferPointer(start: genericArgumentVector(), count: count)
    }
    
    func genericArgumentVector() -> UnsafeMutablePointer<Any.Type> {
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
        
        return (0..<numberOfFields()).map { i in
            let record = fieldDescriptor
                .pointee
                .fields
                .element(at: i)
            
            return NominalTypeMetadata.Field(
                name: record.pointee.fieldName(),
                type: TypeMetadata(record.pointee.type(
                    genericContext: metadata.pointee.contextDescriptor,
                    genericArguments: genericVector)
                ),
                offset: offsets[i]
            )
        }
    }
}
