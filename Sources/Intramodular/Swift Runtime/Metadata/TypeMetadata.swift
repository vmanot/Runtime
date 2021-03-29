//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct TypeMetadata: TypeMetadataType {
    public let base: Any.Type
    
    public init(_ base: Any.Type) {
        self.base = base
    }
}

// MARK: - Conformances -

extension TypeMetadata: MetatypeRepresentable {
    public init(metatype: Any.Type) {
        self.init(metatype)
    }
    
    public func toMetatype() -> Any.Type {
        return base
    }
}
