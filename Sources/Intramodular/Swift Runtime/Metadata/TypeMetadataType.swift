//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol TypeMetadataType {
    associatedtype Layout: SwiftRuntimeTypeMetadataLayout
}

public protocol NominalTypeMetadataProtocol {
    var mangledName: String { get }
    var fields: [NominalTypeMetadata.Field] { get }
}
