//
// Copyright (c) Vatsal Manot
//

import Swallow

public typealias ClassTypeMetadata = TypeMetadata

extension TypeMetadata {
    public struct Class: SwiftRuntimeTypeMetadataWrapper, NominalTypeMetadataProtocol {
        typealias TypeMetadata = SwiftRuntimeClassMetadata
        
        public let value: Any.Type
        
        public init?(_ value: Any.Type) {
            guard TypeMetadata(value).kind == .class else {
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

extension TypeMetadata.Class {
    public var superclass: ClassTypeMetadata? {
        return metadata.superClass().flatMap({ .init($0) })
    }
}
