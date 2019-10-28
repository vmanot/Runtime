//
// Copyright (c) Vatsal Manot
//

import Swallow

public enum SwiftRuntimeTypeKind {
    case `struct`
    case `enum`
    case optional
    case opaque
    case tuple
    case function
    case existential
    case metatype
    case objCClassWrapper
    case existentialMetatype
    case foreignClass
    case heapLocalVariable
    case heapGenericLocalVariable
    case errorObject
    case `class`
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .struct
        case 2:
            self = .enum
        case 3:
            self = .optional
        case 8:
            self = .opaque
        case 9:
            self = .tuple
        case 10:
            self = .function
        case 12:
            self = .existential
        case 13:
            self = .metatype
        case 14:
            self = .objCClassWrapper
        case 15:
            self = .existentialMetatype
        case 16:
            self = .foreignClass
        case 64:
            self = .heapLocalVariable
        case 65:
            self = .heapGenericLocalVariable
        case 128:
            self = .errorObject
        default:
            self = .class
        }
    }
}
