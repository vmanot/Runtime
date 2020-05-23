//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Structure: SwiftRuntimeTypeMetadataWrapper, NominalTypeMetadataProtocol {
        typealias SwiftRuntimeTypeMetadata = SwiftRuntimeStructMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard SwiftRuntimeTypeMetadata(base: value).kind == .struct else {
                return nil
            }
            
            self.value = value
        }
        
        public var mangledName: String {
            metadata.mangledName()
        }
        
        public var fields: [NominalTypeMetadata.Field] {
            metadata.fields
        }
    }
}
