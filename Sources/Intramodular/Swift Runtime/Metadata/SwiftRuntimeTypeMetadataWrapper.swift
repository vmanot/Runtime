//
// Copyright (c) Vatsal Manot
//

import Swallow

protocol SwiftRuntimeTypeMetadataWrapper: FailableWrapper where Value == Any.Type {
    associatedtype SwiftRuntimeTypeMetadata: SwiftRuntimeTypeMetadataProtocol
    
    var metadata: SwiftRuntimeTypeMetadata { get }
}

extension SwiftRuntimeTypeMetadataWrapper {
    var metadata: SwiftRuntimeTypeMetadata {
        SwiftRuntimeTypeMetadata.init(base: value)
    }
}
