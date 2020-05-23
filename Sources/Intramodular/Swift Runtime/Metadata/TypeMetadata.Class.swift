//
// Copyright (c) Vatsal Manot
//

import Swallow

public typealias ClassTypeMetadata = TypeMetadata

extension TypeMetadata {
    public struct Class: SwiftRuntimeTypeMetadataWrapper, NominalTypeMetadataProtocol {
        typealias SwiftRuntimeTypeMetadata = SwiftRuntimeClassMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard SwiftRuntimeTypeMetadata(base: value).kind == .class else {
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

extension TypeMetadata.Class {
    public var superclass: ClassTypeMetadata? {
        return metadata.superclass().flatMap({ .init($0) })
    }
}
