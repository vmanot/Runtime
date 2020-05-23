//
// Copyright (c) Vatsal Manot
//

import Swift

struct SwiftRuntimeClassMetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    typealias ContextDescriptor = SwiftRuntimeClassContextDescriptor
    
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable>
    var isaPointer: Int
    var superclass: AnyClass?
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
    
    public var kind: Int {
        isaPointer
    }
}
