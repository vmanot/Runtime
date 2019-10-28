//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Function: SwiftRuntimeTypeMetadataWrapper {
        typealias TypeMetadata = SwiftRuntimeFunctionMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard TypeMetadata(value).kind == .function else {
                return nil
            }
            
            self.value = value
        }
    }
}
