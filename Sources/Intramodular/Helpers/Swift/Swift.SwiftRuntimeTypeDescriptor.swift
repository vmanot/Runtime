//
// Copyright (c) Vatsal Manot
//

import Swallow

protocol SwiftRuntimeContextDescriptor {
    
}

// MARK: - Concrete Implementations -

struct SwiftRuntimeClassContextDescriptor: SwiftRuntimeContextDescriptor {
    var flags: Int32
    var parent: Int32
    var className: SwiftRuntimeUnsafeRelativePointer<Int32, CChar>
    var fieldTypesAccessor: SwiftRuntimeUnsafeRelativePointer<Int32, Int>
    var superClass: SwiftRuntimeUnsafeRelativePointer<Int32, Any.Type>
    var resilientMetadataBounds: Int32
    var metadataPositiveSizeInWords: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVectorOffset: SwiftRuntimeUnsafeRelativeVectorPointer<Int32, Int>
}

struct SwiftRuntimeProtocolContextDescriptor: SwiftRuntimeContextDescriptor {
    var isaPointer: Int
    var mangledName: NullTerminatedUTF8String
    var inheritedProtocolsList: Int
    var requiredInstanceMethods: Int
    var requiredClassMethods: Int
    var optionalInstanceMethods: Int
    var optionalClassMethods: Int
    var instanceProperties: Int
    var protocolDescriptorSize: Int32
    var flags: Int32
}

struct SwiftRuntimeStructContextDescriptor: SwiftRuntimeContextDescriptor {
    typealias FieldTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<Int>
    
    var flags: Int32
    var parent: Int32
    var mangledName: SwiftRuntimeUnsafeRelativePointer<Int32, CChar>
    var unknown3: Int32
    var numberOfFields: Int32
    var offsetToTheFieldOffsetVector: SwiftRuntimeUnsafeRelativeVectorPointer<Int32, Int32>
    var fieldTypeAccessor: SwiftRuntimeUnsafeRelativePointer<Int32, Int>
    var metadataPattern: Int32
    var inclusiveGenericParametersCount: Int32
    var exclusiveGenericParametersCount: Int32
    var idk2: Int32
    var genericParameterVector: SwiftRuntimeUnsafeRelativeVectorPointer<Int32, Any.Type>
}
