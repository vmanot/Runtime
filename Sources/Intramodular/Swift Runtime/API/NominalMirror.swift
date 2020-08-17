//
// Copyright (c) Vatsal Manot
//

import Swift

public struct NominalMirror<Subject> {
    public var subject: Subject
    
    public var children: AnyNominalOrTupleValue {
        AnyNominalOrTupleValue(subject)!
    }
    
    public init(reflecting subject: Subject) {
        self.subject = subject
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
