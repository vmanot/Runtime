//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Existential: SwiftRuntimeTypeMetadataWrapper {
        typealias SwiftRuntimeTypeMetadata = SwiftRuntimeProtocolMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard SwiftRuntimeTypeMetadata(base: value).kind == .existential else {
                return nil
            }
            
            self.value = value
        }
        
        public var mangledName: String {
            return metadata.mangledName()
        }
    }
}
