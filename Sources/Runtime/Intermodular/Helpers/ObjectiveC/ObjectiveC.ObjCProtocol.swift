//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCProtocol: CustomStringConvertible, ExpressibleByStringLiteral, Wrapper {
    public typealias Value = Protocol
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - Conformances

extension ObjCProtocol: CaseIterable {
    public static var allCases: AnyRandomAccessCollection<ObjCProtocol> {
        return objc_realizeListAllocator({ objc_copyProtocolList($0) })
    }
}

extension ObjCProtocol: ExtensibleSequence {
    public func insert(instanceMethod method: ObjCMethodDescription) {
        protocol_addMethodDescription(value, Selector(method.name), method.signature.rawValue, true, true)
    }
    
    public func insert(classMethod method: ObjCMethodDescription) {
        protocol_addMethodDescription(value, Selector(method.name), method.signature.rawValue, true, false)
    }
    
    public func insert(optionalInstanceMethod method: ObjCMethodDescription) {
        protocol_addMethodDescription(value, Selector(method.name), method.signature.rawValue, false, true)
    }
    
    public func insert(optionalClassMethod method: ObjCMethodDescription) {
        protocol_addMethodDescription(value, Selector(method.name), method.signature.rawValue, false, false)
    }
    
    public func insert(adoptedProtocol `protocol`: ObjCProtocol) {
        protocol_addProtocol(value, `protocol`.value)
    }
    
    public func insert(instanceProperty property: ObjCProperty) {
        let attributes = Array(property.attributeKeyValuePairs.map(keyPath: \.value))
        
        protocol_addProperty(value, property.name, attributes, .init(attributes.count), true, true)
    }
    
    public func insert(classProperty property: ObjCProperty) {
        let attributes = Array(property.attributeKeyValuePairs.map(keyPath: \.value))
        
        protocol_addProperty(value, property.name, attributes, .init(attributes.count), true, false)
    }
    
    public func insert(optionalInstanceProperty property: ObjCProperty) {
        let attributes = Array(property.attributeKeyValuePairs.map(keyPath: \.value))
        
        protocol_addProperty(value, property.name, attributes, .init(attributes.count), false, true)
    }
    
    public func insert(optionalClassProperty property: ObjCProperty) {
        let attributes = Array(property.attributeKeyValuePairs.map(keyPath: \.value))
        
        protocol_addProperty(value, property.name, attributes, .init(attributes.count), false, false)
    }
    
    public func insert(_ element: Element) {
        switch element {
            case .instanceMethod(let value):
                insert(instanceMethod: value)
            case .classMethod(let value):
                insert(classMethod: value)
            case .optionalInstanceMethod(let value):
                insert(optionalInstanceMethod: value)
            case .optionalClassMethod(let value):
                insert(optionalClassMethod: value)
                
            case .instanceProperty(let value):
                insert(instanceProperty: value)
            case .classProperty(let value):
                insert(classProperty: value)
            case .optionalInstanceProperty(let value):
                insert(optionalInstanceProperty: value)
            case .optionalClassProperty(let value):
                insert(optionalClassProperty: value)
                
            case .adoptedProtocol(let value):
                insert(adoptedProtocol: value)
        }
    }
    
    public func append(_ element: Element) {
        insert(element)
    }
}

extension ObjCProtocol: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value === rhs.value
    }
}

extension ObjCProtocol: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension ObjCProtocol: Named, NameInitiable {
    public var name: String {
        return .init(utf8String: protocol_getName(value))
    }
    
    public init(name: String) {
        if let value = objc_getProtocol(name) {
            self.init(value)
        } else {
            self.init(objc_allocateProtocol(name)!)
            
            register()
        }
    }
}

extension ObjCProtocol: ObjCRegistree {
    public func register() {
        objc_registerProtocol(value)
    }
}

extension ObjCProtocol: Sequence {
    public typealias Iterator = RandomAccessCollectionView.Iterator
    public typealias RandomAccessCollectionView = AnyRandomAccessCollection<ObjCProtocolItem>

    public var instanceMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return protocol_realizeListAllocator(value, with: { protocol_copyMethodDescriptionList($0, $1, $2, $3) }, (true, true)).filterOutInvalids()
    }

    public var optionalInstanceMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return protocol_realizeListAllocator(value, with: { protocol_copyMethodDescriptionList($0, $1, $2, $3) }, (false, true)).filterOutInvalids()
    }

    public var allInstanceMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return .init(EmptyCollection()
            .join(instanceMethods)
            .join(optionalInstanceMethods)
        )
    }

    public var classMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return protocol_realizeListAllocator(value, with: { protocol_copyMethodDescriptionList($0, $1, $2, $3) }, (true, false)).filterOutInvalids()
    }

    public var optionalClassMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return protocol_realizeListAllocator(value, with: { protocol_copyMethodDescriptionList($0, $1, $2, $3) }, (false, false)).filterOutInvalids()
    }

    public var allClassMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return .init(EmptyCollection()
            .join(classMethods)
            .join(optionalClassMethods)
        )
    }

    public var allMethods: AnyRandomAccessCollection<ObjCMethodDescription> {
        return .init(EmptyCollection()
            .join(optionalInstanceMethods)
            .join(optionalClassMethods)
            .join(instanceMethods)
            .join(classMethods)
        )
    }
    
    public var instanceProperties: AnyRandomAccessCollection<ObjCProperty> {
        return protocol_realizeListAllocator(value, with: { protocol_copyPropertyList2($0, $1, $2, $3) }, (true, true))
    }
    
    public var classProperties: AnyRandomAccessCollection<ObjCProperty> {
        return protocol_realizeListAllocator(value, with: { protocol_copyPropertyList2($0, $1, $2, $3) }, (true, false))
    }
    
    public var optionalInstanceProperties: AnyRandomAccessCollection<ObjCProperty> {
        return protocol_realizeListAllocator(value, with: { protocol_copyPropertyList2($0, $1, $2, $3) }, (false, true))
    }
    
    public var optionalClassProperties: AnyRandomAccessCollection<ObjCProperty> {
        return protocol_realizeListAllocator(value, with: { protocol_copyPropertyList2($0, $1, $2, $3) }, (false, false))
    }
    
    public var allProperties: AnyRandomAccessCollection<ObjCProperty> {
        return objc_realizeListAllocator({ protocol_copyPropertyList($0, $1) }, value)
    }

    public var adoptedProtocols: AnyRandomAccessCollection<ObjCProtocol> {
        return objc_realizeListAllocator({ protocol_copyProtocolList($0, $1) }, value)
    }
    
    public var randomAccessCollectionView: RandomAccessCollectionView {
        let instanceMethods = self.instanceMethods
            .lazy
            .map(ObjCProtocolItem.instanceMethod)
        let classMethods = self.instanceMethods
            .lazy
            .map(ObjCProtocolItem.classMethod)
        let optionalInstanceMethods = self.optionalInstanceMethods
            .lazy
            .map(ObjCProtocolItem.optionalInstanceMethod)
        let optionalClassMethods = self.optionalInstanceMethods
            .lazy
            .map(ObjCProtocolItem.optionalClassMethod)

        let instanceProperties = self.instanceProperties
            .lazy
            .map(ObjCProtocolItem.instanceProperty)
        let classProperties = self.classProperties
            .lazy
            .map(ObjCProtocolItem.classProperty)
        let optionalInstanceProperties = self.optionalInstanceProperties
            .lazy
            .map(ObjCProtocolItem.optionalInstanceProperty)
        let optionalClassProperties = self.optionalClassProperties
            .lazy
            .map(ObjCProtocolItem.optionalClassProperty)

        let adoptedProtocols = self.adoptedProtocols
            .lazy
            .map(ObjCProtocolItem.adoptedProtocol)

        return .init(EmptyCollection()
            .join(instanceMethods)
            .join(classMethods)
            .join(optionalInstanceMethods)
            .join(optionalClassMethods)
            .join(instanceProperties)
            .join(classProperties)
            .join(optionalInstanceProperties)
            .join(optionalClassProperties)
            .join(adoptedProtocols)
        )
    }
    
    public func makeIterator() -> Iterator {
        return randomAccessCollectionView.makeIterator()
    }
}

// MARK: - Helpers

extension ObjCClass {
    public func inheritedMethodDescription(for selector: ObjCSelector) throws -> ObjCMethodDescription {
        guard !responds(to: selector) else {
            return try! method(for: selector).getDescription()
        }

        let allInstanceMethods = protocols
            .lazy
            .flatMap { $0.allInstanceMethods }

        let allAdoptedInstanceMethods = protocols
            .lazy
            .flatMap { $0.adoptedProtocols }
            .flatMap({ $0.allInstanceMethods })

        let result = nil
            ?? allInstanceMethods.find({ $0.selector == selector })
            ?? allAdoptedInstanceMethods.find({ $0.selector == selector })

        return try result.unwrap()
    }
}
