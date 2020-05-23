//
// Copyright (c) Vatsal Manot
//

import Swift

struct SwiftRuntimeClassContextDescriptor: SwiftRuntimeContextDescriptor {
    var flags: Int32
    var parent: Int32
    var mangledName: SwiftRuntimeUnsafeRelativePointer<Int32, CChar>
    var fieldTypesAccessor: SwiftRuntimeUnsafeRelativePointer<Int32, Int>
    var fieldDescriptor: SwiftRuntimeUnsafeRelativePointer<Int32, SwiftRuntimeFieldDescriptor>
    var superClass: SwiftRuntimeUnsafeRelativePointer<Int32, Any.Type>
    var negativeSizeAndBoundsUnion: NegativeSizeAndBoundsUnion
    var metadataPositiveSizeInWords: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVectorOffset: SwiftRuntimeUnsafeRelativeVectorPointer<Int32, Int32>
    var genericContextHeader: TargetTypeGenericContextDescriptorHeader
}

extension SwiftRuntimeClassContextDescriptor {
    struct NegativeSizeAndBoundsUnion {
        var rawValue: Int32
        
        var metadataNegativeSizeInWords: Int32 {
            return rawValue
        }
    }
}
