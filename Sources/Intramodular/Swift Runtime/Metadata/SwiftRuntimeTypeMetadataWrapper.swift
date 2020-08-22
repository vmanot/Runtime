//
// Copyright (c) Vatsal Manot
//

import Swallow

protocol SwiftRuntimeTypeMetadataWrapper: TypeMetadataType {
    associatedtype SwiftRuntimeTypeMetadata: SwiftRuntimeTypeMetadataProtocol
    
    var metadata: SwiftRuntimeTypeMetadata { get }
}

extension SwiftRuntimeTypeMetadataWrapper {
    var metadata: SwiftRuntimeTypeMetadata {
        SwiftRuntimeTypeMetadata.init(base: base)
    }
}
