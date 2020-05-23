//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Enumeration: SwiftRuntimeTypeMetadataWrapper, NominalTypeMetadataProtocol {
        typealias SwiftRuntimeTypeMetadata = SwiftRuntimeEnumMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard SwiftRuntimeTypeMetadata(base: value).kind == .enum else {
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
