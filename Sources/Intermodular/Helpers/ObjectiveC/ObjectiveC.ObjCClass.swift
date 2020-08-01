//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

public struct ObjCClass: CustomDebugStringConvertible, ExpressibleByStringLiteral, Wrapper {
    public typealias Value = AnyClass
    
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

extension ObjCClass {
    public static func existsWithName(_ name: String) -> Bool {
        return objc_getClass(name) != nil
    }
    
    public var isMetaClass: Bool {
        return class_isMetaClass(value)
    }
    
    public var metaClass: ObjCClass? {
        return (-?>objc_getMetaClass(name)).map({ .init($0) })
    }
    
    public var superclass: ObjCClass? {
        return (class_getSuperclass(value) as Optional).map({ .init($0) })
    }
    
    public var version: Int {
        get {
            return Int(class_getVersion(value))
        }
        nonmutating set {
            class_setVersion(value, .init(newValue))
        }
    }
    
    public var instanceSize: Int {
        return .init(class_getInstanceSize(value))
    }
    
    public func duplicate(name: String, extraByteCount count: Int = 0) -> ObjCClass? {
        return (objc_duplicateClass(value, name, count) as Optional).map({ .init($0) })
    }
}

extension ObjCClass {
    public subscript(instanceVariableNamed name: String) -> ObjCInstanceVariable? {
        return (class_getInstanceVariable(value, name) as Optional).map({ .init($0) })
    }
    
    public subscript(methodNamed selector: ObjCSelector) -> ObjCMethod? {
        return (class_getInstanceMethod(value, selector.value) as Optional).map({ .init($0) })
    }
    
    public func method(for selector: ObjCSelector) throws -> ObjCMethod {
        return try (class_getInstanceMethod(value, selector.value) as Optional)
            .map({ ObjCMethod($0) })
            .unwrapOrThrow(ObjCRuntime.Error.instanceMethodNotFound(for: selector))
    }
    
    public subscript(methodNamed name: String) -> ObjCMethod? {
        return self[methodNamed: ObjCSelector(.init(name))]
    }
    
    public subscript(classMethodNamed selector: ObjCSelector) -> ObjCMethod? {
        return (class_getClassMethod(value, selector.value) as Optional).map({ .init($0) })
    }
    
    public subscript(classMethodNamed name: String) -> ObjCMethod? {
        return self[classMethodNamed: ObjCSelector(.init(name))]
    }
    
    public subscript(propertyNamed name: String) -> ObjCProperty? {
        return (class_getProperty(value, name) as Optional).map({ .init($0) })
    }
    
    public func property(withName name: String) throws -> ObjCProperty {
        return try (class_getProperty(value, name) as Optional)
            .map(ObjCProperty.init)
            .unwrapOrThrow(ObjCRuntime.Error.propertyNotFound(name: name))
    }
}

// MARK: - Protocol Implementations -

extension ObjCClass: ApproximatelyEquatable {
    public static func ~= (lhs: ObjCClass, rhs: ObjCClass) -> Bool {
        return lhs.value ~= rhs.value
    }
    
    public func responds(to selector: ObjCSelector) -> Bool {
        return class_respondsToSelector(value, selector.value)
    }
    
    public static func ~= (lhs: ObjCClass, rhs: ObjCSelector) -> Bool {
        return lhs.responds(to: rhs)
    }
    
    public static func ~= (lhs: ObjCClass, rhs: ObjCMethod) -> Bool {
        return lhs ~= rhs.getDescription().selector
    }
    
    public func has(_ property: ObjCProperty) -> Bool {
        return class_getProperty(value, property.name) == property.value
    }
    
    public static func ~= (lhs: ObjCClass, rhs: ObjCProperty) -> Bool {
        return lhs.has(rhs)
    }
    
    public func conforms(to protocol_: ObjCProtocol) -> Bool {
        return class_conformsToProtocol(value, protocol_.value)
    }
    
    public static func ~= (lhs: ObjCClass, rhs: ObjCProtocol) -> Bool {
        return lhs.conforms(to: rhs)
    }
}

extension ObjCClass: CaseIterable {
    public static var allCases: AnyRandomAccessCollection<ObjCClass> {
        return objc_realizeListAllocator({ objc_copyClassList($0) })
    }
}

extension ObjCClass: CustomStringConvertible {
    public var description: String {
        return String(describing: value)
    }
}

extension ObjCClass: ExtensibleSequence {
    public func insert(_ instanceVariable: ObjCInstanceVariable) throws {
        try insert(instanceVariable, name: instanceVariable.name)
    }
    
    public func insert(_ instanceVariable: ObjCInstanceVariable, name: String) throws {
        try class_addIvar(
            value,
            name.nullTerminatedUTF8String().value,
            instanceVariable.typeEncoding.sizeInBytes,
            .init(log2(Double(instanceVariable.typeEncoding.alignmentInBytes))),
            instanceVariable.typeEncoding.value
        )
        .throw(if: ==false)
    }
    
    public static func += (lhs: ObjCClass, rhs: ObjCInstanceVariable) {
        try! lhs.insert(rhs)
    }
    
    public func insert(_ description: ObjCMethodDescription, _ implementation: ObjCImplementation) throws {
        try class_addMethod(value, Selector(description.name), implementation.value, description.signature.value).orThrow()
    }
    
    public func insert(_ method: ObjCMethod) throws {
        try class_addMethod(value, Selector(method.name), method.implementation.value, method.getDescription().signature.value).orThrow()
    }
    
    public static func += (lhs: ObjCClass, rhs: ObjCMethod) {
        try! lhs.insert(rhs)
    }
    
    public func insert(_ property: ObjCProperty) throws {
        let attributes = property.attributeKeyValuePairs.map(keyPath: \.value)
        
        try class_addProperty(value, property.name, attributes, .init(attributes.count)).orThrow()
    }
    
    public static func += (lhs: ObjCClass, rhs: ObjCProperty) {
        try! lhs.insert(rhs)
    }
    
    public func insert(_ protocol_: ObjCProtocol) throws {
        try class_addProtocol(value, protocol_.value).orThrow()
    }
    
    public func insertIfNecessary(_ protocol_: ObjCProtocol) throws {
        guard !conforms(to: protocol_) else {
            return
        }
        try class_addProtocol(value, protocol_.value).orThrow()
    }
    
    public static func += (lhs: ObjCClass, rhs: ObjCProtocol) {
        try! lhs.insert(rhs)
    }
    
    public func insert(_ item: ObjCClassItem) throws {
        switch item {
            case .instanceVariable(let value):
                return try insert(value)
            case .method(let value):
                return try insert(value)
            case .property(let value):
                return try insert(value)
            case .`protocol`(let value):
                return try insert(value)
        }
    }
    
    public func insert(_ item: ObjCClassItem) -> Result<Void, Error> {
        return Result(try insert(item))
    }
    
    public func append(_ item: ObjCClassItem) -> Result<Void, Error> {
        return insert(item)
    }
}

extension ObjCClass: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(value))
    }
    
    public static func == (lhs: ObjCClass, rhs: ObjCClass) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension ObjCClass: Named, NameInitiable {
    public var name: String {
        return .init(utf8String: class_getName(value))
    }
    
    public init(name: String, superclass: ObjCClass, extraByteCount: Int = 0) {
        if let value = objc_getClass(name) as? AnyClass {
            self.init(value)
        } else {
            self.init(objc_allocateClassPair(superclass.value, name, extraByteCount)!)
            
            register()
        }
    }
    
    public init(name: String) {
        self.init(name: name, superclass: ObjCClass(Object.self))
    }
}

extension ObjCClass {
    public func swizzle(_ selector1: ObjCSelector, and selector2: ObjCSelector) throws {
        let method1 = try method(for: selector1)
        let method2 = try method(for: selector2)
        
        do {
            try addMethod(named: selector1, implementation: method2.implementation, signature: method2.signature)
            try replace(method2, with: method1.implementation, signature: method2.signature)
        } catch {
            method1.exchangeImplementations(with: method2)
        }
    }
    
    public func replace(methodNamed selector: ObjCSelector, with newImpl: ObjCImplementation, preservingTo otherSelector: ObjCSelector) throws {
        let method = try self.method(for: selector)
        try addMethod(named: otherSelector, implementation: method.implementation, signature: method.signature)
        try replace(methodNamed: selector, with: newImpl)
    }
    
    public func addMethod(named name: ObjCSelector, implementation: ObjCImplementation, signature: ObjCMethodSignature) throws {
        try class_addMethod(value, name.value, implementation.value, signature.value).orThrow()
    }
    
    @discardableResult
    public func replace(methodNamed name: ObjCSelector, with newImpl: ObjCImplementation) throws -> ObjCImplementation?  {
        return replace(try method(for: name), with: newImpl)
    }
    
    @discardableResult
    public func replace(_ description: ObjCMethodDescription, with implementation: ObjCImplementation) throws -> ObjCImplementation? {
        return class_replaceMethod(value, Selector(description.name), implementation.value, description.signature.value).map { .init($0) }
    }
    
    @discardableResult
    public func replace(_ method: ObjCMethod, with implementation: ObjCImplementation) -> ObjCImplementation? {
        return class_replaceMethod(value, Selector(method.name), implementation.value, method.getDescription().signature.value).map({ .init($0) })
    }
    
    @discardableResult
    public func replace(_ method: ObjCMethod, with implementation: ObjCImplementation, signature: ObjCMethodSignature) throws -> ObjCImplementation? {
        return class_replaceMethod(value, Selector(method.name), implementation.value, signature.value).map { .init($0) }
    }
}

extension ObjCClass: ObjCDisposableRegistree {
    public func register() {
        objc_registerClassPair(value)
    }
    
    public func dispose() {
        objc_disposeClassPair(value)
    }
}

extension ObjCClass: Sequence {
    public typealias Iterator = RandomAccessCollectionView.Iterator
    public typealias RandomAccessCollectionView = AnyRandomAccessCollection<ObjCClassItem>
    
    public var instanceVariables: AnyRandomAccessCollection<ObjCInstanceVariable> {
        return objc_realizeListAllocator({ class_copyIvarList($0, $1) }, value)
    }
    
    public var methods: AnyRandomAccessCollection<ObjCMethod> {
        return objc_realizeListAllocator({ class_copyMethodList($0, $1) }, value)
    }
    
    public var properties: AnyRandomAccessCollection<ObjCProperty> {
        return objc_realizeListAllocator({ class_copyPropertyList($0, $1) }, value)
    }
    
    public var protocols: AnyRandomAccessCollection<ObjCProtocol> {
        return objc_realizeListAllocator({ class_copyProtocolList($0, $1) }, value)
    }
    
    public var randomAccessCollectionView: RandomAccessCollectionView {
        let instanceVariables = self.instanceVariables.lazy.map(ObjCClassItem.init)
        let methods = self.methods.lazy.map(ObjCClassItem.init)
        let properties = self.properties.lazy.map(ObjCClassItem.init)
        let protocols = self.protocols.lazy.map(ObjCClassItem.init)
        
        return .init(instanceVariables.join(methods).join(properties).join(protocols))
    }
    
    public func makeIterator() -> Iterator {
        return randomAccessCollectionView.makeIterator()
    }
}
