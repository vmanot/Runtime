//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public enum Kind: Equatable {
        public typealias RawValue = Int
        
        struct Flags {
            static let kindIsNonHeap = 0x200
            static let kindIsRuntimePrivate = 0x100
            static let kindIsNonType = 0x400
        }

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
        
        public init(rawValue: RawValue) {
            switch rawValue {
                case 1:
                    self = .struct
                case (0 | Flags.kindIsNonHeap):
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
}

// MARK: - Helpers -

extension TypeMetadata {
    public var kind: TypeMetadata.Kind {
        return TypeMetadata.Kind(rawValue: unsafeBitCast(value, to: UnsafePointer<Int>.self)[0])
    }
    
    public var typed: Any {
        switch kind {
            case .`struct`:
                return unsafeBitCast(self, to: TypeMetadata.Structure.self)
            case .`enum`:
                return unsafeBitCast(self, to: TypeMetadata.Enumeration.self)
            case .tuple:
                return unsafeBitCast(self, to: TypeMetadata.Tuple.self)
            case .function:
                return unsafeBitCast(self, to: TypeMetadata.Function.self)
            case .existential:
                return unsafeBitCast(self, to: TypeMetadata.Existential.self)
            case .`class`:
                return unsafeBitCast(self, to: TypeMetadata.Class.self)
            case .objCClassWrapper:
                return unsafeBitCast(self, to: ObjCClass.self)
            default:
                return self
        }
    }
}
