//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Function: SwiftRuntimeTypeMetadataWrapper {
        typealias SwiftRuntimeTypeMetadata = SwiftRuntimeFunctionMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard SwiftRuntimeTypeMetadata(base: value).kind == .function else {
                return nil
            }
            
            self.value = value
        }
    }
}
