//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow
import Swift

protocol SwiftRuntimeTypeMetadataWrapper: FailableWrapper where Value == Any.Type {
    associatedtype TypeMetadata: SwiftRuntimeTypeMetadataProtocol
    
    var metadata: TypeMetadata { get }
}

extension SwiftRuntimeTypeMetadataWrapper {
    var metadata: TypeMetadata {
        return unsafeBitCast(value, to: TypeMetadata.self)
    }
}

typealias SwiftRuntimeGenericMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeGenericMetadataLayout>
typealias SwiftRuntimeClassMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeClassMetadataLayout>
typealias SwiftRuntimeEnumMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeEnumMetadataLayout>
typealias SwiftRuntimeFunctionMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeFunctionMetadataLayout>
typealias SwiftRuntimeProtocolMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeProtocolMetadataLayout>
typealias SwiftRuntimeStructMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeStructMetadataLayout>
typealias SwiftRuntimeTupleMetadata = SwiftRuntimeTypeMetadata<SwiftRuntimeTupleMetadataLayout>

protocol SwiftRuntimeTypeMetadataProtocol {
    var kind: SwiftRuntimeTypeKind { get }
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable> { get }
}

extension SwiftRuntimeTypeMetadata: SwiftRuntimeTypeMetadataProtocol {
    var kind: SwiftRuntimeTypeKind {
        return .init(rawValue: basePointer.pointee)
    }
    
    var valueWitnessTable: UnsafePointer<SwiftRuntimeValueWitnessTable> {
        return metadata.pointee.valueWitnessTable 
    }
}

public func getSwiftObjectBaseSuperclass() -> AnyClass {
    class Temp { }
    return class_getSuperclass(Temp.self)!
}

struct SwiftRuntimeTypeMetadata<MetadataLayout: SwiftRuntimeTypeMetadataLayout> {
    let base: Any.Type
    
    init(_ base: Any.Type) {
        self.base = base
    }
    
    var basePointer: UnsafeMutablePointer<Int> {
        return unsafeBitCast(base, to: UnsafeMutablePointer<Int>.self)
    }
    
    var metadata: UnsafePointer<MetadataLayout> {
        return basePointer
            .advanced(by: SwiftRuntimeValueWitnessTable.offset)
            .rawRepresentation
            .assumingMemoryBound(to: MetadataLayout.self)
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout: SwiftRuntimeContextualTypeMetadataLayout {
    var contextDescriptor: UnsafeMutablePointer<MetadataLayout.ContextDescriptor> {
        return metadata.pointee.contextDescriptor
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeClassMetadataLayout {
    func mangledName() -> String {
        return String(cString: contextDescriptor.pointee.className.advanced())
    }
    
    func numberOfFields() -> Int {
        return Int(contextDescriptor.pointee.numberOfFields)
    }
    
    func fieldOffsets() -> [Int] {
        return contextDescriptor
            .pointee
            .fieldOffsetVectorOffset
            .vector(metadata: basePointer, count: numberOfFields())
            .map{ Int($0) }
    }

    func superClass() -> AnyClass? {
        guard let superClass = metadata.pointee.superClass else {
            return nil
        }
        
        if superClass != getSwiftObjectBaseSuperclass() && superClass != NSObject.self {
            return superClass
        } else {
            return nil
        }
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeEnumMetadataLayout {
    func mangledName() -> String {
        return String(cString: contextDescriptor.pointee.mangledName.advanced())
    }
    
    func numberOfFields() -> Int {
        return Int(contextDescriptor.pointee.numberOfFields)
    }
    
    func fieldOffsets() -> [Int] {
        return contextDescriptor
            .pointee
            .offsetToTheFieldOffsetVector
            .vector(metadata: basePointer, count: numberOfFields())
            .map{ Int($0) }
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeFunctionMetadataLayout {
    func argumentTypes() -> (arguments: [Any.Type], result: Any.Type) {
        let argumentAndResultTypes = metadata
            .mutableRepresentation
            .pointee
            .argumentVector
            .vector(count: numberOfArguments() + 1)

        let argumentTypes = argumentAndResultTypes.removing(at: 0)
        let resultType = argumentAndResultTypes[0]
        
        return (argumentTypes, resultType)
    }
    
    func numberOfArguments() -> Int {
        return metadata.pointee.flags & 0x00FFFFFF
    }
    
    func `throws`() -> Bool {
        return metadata.pointee.flags & 0x01000000 != 0
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeProtocolMetadataLayout {
    func mangledName() -> String {
        let cString = metadata
            .pointee
            .protocolDescriptorVector
            .pointee
            .mangledName
        
        return String(cString: cString)
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeStructMetadataLayout {
    func mangledName() -> String {
        return String(cString: contextDescriptor.pointee.mangledName.advanced())
    }
    
    func numberOfFields() -> Int {
        return Int(contextDescriptor.pointee.numberOfFields)
    }
    
    func fieldOffsets() -> [Int] {
        return contextDescriptor
            .pointee
            .offsetToTheFieldOffsetVector
            .vector(metadata: basePointer, count: numberOfFields())
            .map{ Int($0) }
    }
}

extension SwiftRuntimeTypeMetadata where MetadataLayout == SwiftRuntimeTupleMetadataLayout {
    func numberOfElements() -> Int {
        return metadata.pointee.numberOfElements
    }
    
    func labels() -> [String] {
        guard Int(bitPattern: metadata.pointee.labelsString) != 0 else { return (0..<numberOfElements()).map{ a in "" } }
        var labels = String(cString: metadata.pointee.labelsString).components(separatedBy: " ")
        labels.removeLast()
        return labels
    }
    
    func elementLayouts() -> [SwiftRuntimeTupleMetadataLayout.ElementLayout] {
        let count = numberOfElements()
        guard count > 0 else {
            return []
        }
        return metadata.mutableRepresentation.pointee.elementVector.vector(count: count)
    }
}

