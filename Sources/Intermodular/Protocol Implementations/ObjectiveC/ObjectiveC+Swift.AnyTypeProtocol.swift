//
// Copyright (c) Vatsal Manot
//

import ObjectiveC
import Swallow

extension ObjCTypeEncoding: MetatypeRepresentable {
    public typealias OpaqueValue = Any.Type
    
    public func toMetatype() -> Any.Type {
        return ObjCTypeCoder.decode(self)
    }
    
    public init?(metatype type: Any.Type) {
        guard let value = ObjCTypeCoder.encode(type) else {
            return nil
        }
        
        self = value
    }
}

extension ObjCClass: NominalTypeMetadataProtocol {
    public var mangledName: String {
        return name
    }
    
    public var fields: [NominalTypeMetadata.Field] {
        return instanceVariables.map({ .init(name: $0.name, type: .init($0.typeEncoding.toMetatype()), offset: $0.offset) })
    }
}
