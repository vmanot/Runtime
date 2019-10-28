//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct NominalOrTuple: FailableWrapper {
        public let value: Any.Type
        
        public var fields: [NominalTypeMetadata.Field] {
            if let type = TypeMetadata.Tuple(value) {
                return type.fields
            } else {
                return TypeMetadata.Nominal(value)!.fields
            }
        }
        
        public init?(_ value: Any.Type) {
            if let type = TypeMetadata.Nominal(value) {
                self.value = type.value
            } else if let type = TypeMetadata.Tuple(value) {
                self.value = type.value
            } else {
                return nil
            }
        }
    }
}
