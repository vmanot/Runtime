//
// Copyright (c) Vatsal Manot
//

import Swallow

extension TypeMetadata {
    public struct Structure: SwiftRuntimeTypeMetadataWrapper, NominalTypeMetadataProtocol {
        typealias TypeMetadata = SwiftRuntimeStructMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard TypeMetadata(value).kind == .struct else {
                return nil
            }
            
            self.value = value
        }
        
        public var mangledName: String {
            return metadata.mangledName()
        }
        
        public var fields: [NominalTypeMetadata.Field] {
            return .init(type: value, withFieldOffsets: metadata.fieldOffsets())
        }
    }
}
