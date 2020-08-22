//
// Copyright (c) Vatsal Manot
//

import Swift

/// A strongly typed mirror over a subject of a nominal type.
public struct NominalMirror<Subject> {
    public var subject: Subject
    public let typeMetadata: TypeMetadata.NominalOrTuple
    
    public var supervalue: NominalMirror<Any>? {
        children.supervalue.flatMap(NominalMirror<Any>.init)
    }
    
    public var children: AnyNominalOrTupleValue {
        .init(self)
    }
    
    private init(subject: Subject, typeMetadata: TypeMetadata.NominalOrTuple) {
        self.subject = subject
        self.typeMetadata = typeMetadata
    }
    
    public init(reflecting subject: Subject) {
        self.init(subject: subject, typeMetadata: .of(subject))
    }
}

extension NominalMirror {
    public subscript<T>(keyPath keyPath: KeyPath<Subject, T>) -> T{
        subject[keyPath: keyPath]
    }
    
    public subscript<T>(keyPath keyPath: WritableKeyPath<Subject, T>) -> T {
        get {
            subject[keyPath: keyPath]
        } set {
            subject[keyPath: keyPath] = newValue
        }
    }
}

// MARK: - Auxiliary Implementation -

extension NominalMirror {
    public init?(_ value: AnyNominalOrTupleValue) {
        guard let subject = value.value as? Subject else {
            return nil
        }
        
        self.init(subject: subject, typeMetadata: value.typeMetadata)
    }
}

extension AnyNominalOrTupleValue {
    public init<T>(_ mirror: NominalMirror<T>) {
        self.init(unchecked: mirror.subject, typeMetadata: mirror.typeMetadata)
    }
}
