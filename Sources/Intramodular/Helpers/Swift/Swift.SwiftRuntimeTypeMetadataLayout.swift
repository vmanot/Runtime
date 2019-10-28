//
// Copyright (c) Vatsal Manot
//

import Swallow

protocol SwiftRuntimeTypeMetadataLayout {
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable> { get set }
}

protocol SwiftRuntimeContextualTypeMetadataLayout: SwiftRuntimeTypeMetadataLayout {
    associatedtype ContextDescriptor: SwiftRuntimeContextDescriptor

    var contextDescriptor: UnsafeMutablePointer<ContextDescriptor> { get set }
}

// MARK: - Concrete Implementations -

struct SwiftRuntimeGenericMetadataLayout: SwiftRuntimeTypeMetadataLayout {
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
}

struct SwiftRuntimeClassMetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    typealias ContextDescriptor = SwiftRuntimeClassContextDescriptor
    
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var isaPointer: Int
    var superClass: AnyClass?
    var objCRuntimeReserve1: Int
    var objCRuntimeReserve2: Int
    var rodataPointer: Int
    var classFlags: Int32
    var instanceAddressPoint: Int32
    var instanceSize: Int32
    var instanceAlignmentMask: Int16
    var runtimeReserveField: Int16
    var classObjectSize: Int32
    var classObjectAddressPoint: Int32
    var contextDescriptor: UnsafeMutablePointer<ContextDescriptor>
    var genericParameterVector: SwiftRuntimeUnsafeRelativeVectorPointer<Int32, Any.Type>
}

struct SwiftRuntimeEnumMetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var kind: Int
    var contextDescriptor: UnsafeMutablePointer<SwiftRuntimeStructMetadataLayout.ContextDescriptor>
    var parent: Int
}

struct SwiftRuntimeFunctionMetadataLayout: SwiftRuntimeTypeMetadataLayout {
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var kind: Int
    var flags: Int
    var argumentVector: SwiftRuntimeUnsafeRelativeVector<Any.Type>
}

struct SwiftRuntimeProtocolMetadataLayout: SwiftRuntimeTypeMetadataLayout {
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var kind: Int
    var layoutFlags: Int
    var numberOfProtocols: Int
    var protocolDescriptorVector: UnsafeMutablePointer<SwiftRuntimeProtocolContextDescriptor>
}

struct SwiftRuntimeStructMetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    typealias ContextDescriptor = SwiftRuntimeStructContextDescriptor
    
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var kind: Int
    var contextDescriptor: UnsafeMutablePointer<ContextDescriptor>
}

struct SwiftRuntimeTupleMetadataLayout: SwiftRuntimeTypeMetadataLayout {
    struct ElementLayout {
        var type: Any.Type
        var offset: Int
    }
    
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var kind: Int
    var numberOfElements: Int
    var labelsString: UnsafeMutablePointer<CChar>
    var elementVector: SwiftRuntimeUnsafeRelativeVector<ElementLayout>
}
